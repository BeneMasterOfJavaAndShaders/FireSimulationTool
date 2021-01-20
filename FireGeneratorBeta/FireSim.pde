public final class FireSimulation {
  int simWidth, simHeight, targetWidth, targetHeight, margin;

  NoiseMap noiseMap;
  int noiseMapSpeed, flameSteps;

  PGraphics fire;
  float coolDown;

  ColorRamp colors;

  ComputeShader computeShader;

  public FireSimulation(int simWidth, int simHeight, int margin, float increment) {
    this.simWidth = simWidth;
    this.simHeight = simHeight;
    this.margin = margin;
    this.targetWidth = this.simWidth - this.margin*2;
    this.targetHeight = this.simHeight - this.margin*2;

    this.fire = createGraphics(this.simWidth, this.simHeight);
    this.fire.beginDraw();
    this.fire.background(0);
    this.fire.endDraw();
    this.coolDown = 1;

    this.noiseMap = new NoiseMap(this.simWidth, this.simHeight, increment);
    this.flameSteps = 2;
    this.noiseMapSpeed = 3;

    this.colors = new ColorRamp(loadImage(sketchPath()+"\\data\\Fire-1x.png"), false);

    final String computeShaderCode
      = "#version 430 core \n"
      + "#extension GL_ARB_compute_variable_group_size : enable \n"
      + "layout (local_size_variable) in; \n"        //+ "layout (local_size_x = 8, local_size_y = 8, local_size_z = 1) in; \n"

      + "uniform uint steps;"
      + "uniform float sub;"

      + "layout (std430, binding = 0) buffer buffer1 {"
      + "  float current[];"
      + "};"

      + "layout (std430, binding = 1) buffer buffer2 {"
      + "  float next[];"
      + "};"

      + "uint index(uint x, uint y) {"
      + "  uint globalSizeX = gl_NumWorkGroups.x * gl_LocalGroupSizeARB.x;"
      + "  return y * globalSizeX + x;"
      + "}"

      + "uint index(uvec2 pos) {"
      + "  uint globalSizeX = gl_NumWorkGroups.x * gl_LocalGroupSizeARB.x;"
      + "  return pos.y * globalSizeX + pos.x;"
      + "}"

      + "uvec2 globalSize() {"
      + "  return gl_NumWorkGroups.xy * gl_LocalGroupSizeARB.xy;"
      + "}"

      + "uvec2 globalCoords() {"
      + "  return gl_WorkGroupID.xy * gl_LocalGroupSizeARB.xy + gl_LocalInvocationID.xy;"
      + "}"

      + "float getFire(uint x, uint y) {"
      + "  uint w = globalSize().x;"
      + "  uint h = globalSize().y;"

      + "  if(x==0 || x==w-1 || y==steps || y>=h-1-steps)"
      + "    return 0.;"

      + "  uint index0 = w*(y+0) + x;"
      + "  uint index1 = w*(y+steps+0) + (x+1);"
      + "  uint index2 = w*(y+steps+0) + (x-1);"
      + "  uint index3 = w*(y+steps+1) + (x+0);"
      + "  uint index4 = w*(y+steps-1) + (x+0);"
      + "  uint index5 = w*(y+steps) + x;"

      + "  float c0 = current[index1];"
      + "  float c1 = current[index2];"
      + "  float c2 = current[index3];"
      + "  float c3 = current[index4];"
      + "  float c4 = current[index5];"
      + "  float avg = (c0 + c1 + c2 + c3 + c4)/5.;"

      + "  float c5 = next[index0];"
      + "  return max(avg - c5*sub, 0);"
      + "}"

      + "void main(void) {"
      + "  next[index(globalCoords())] = getFire(globalCoords().x, globalCoords().y);"
      + "}";

    this.computeShader = new ComputeShader(computeShaderCode, 2);
  }

  public final void addFireMask(PImage mask, int x, int y) {
    fire.beginDraw();
    fire.image(mask, this.margin+x, this.margin+y);
    fire.endDraw();
  }

  public final PImage noMargin() {
    return this.fire.get(this.margin, this.margin, this.targetWidth, this.targetHeight);//remove margin
  }

  public final PImage getFrame() {
    return this.colors.filter(this.noMargin());
    //return this.noMargin();
  }

  public final void update() {
    this.noiseMap.advance(this.noiseMapSpeed);
    this.flame(this.flameSteps, this.coolDown);
    //this.updateFlameShader(this.flameSteps, this.coolDown);
  }

  public final FloatBuffer toBuffer(PImage src) {
    src.loadPixels();
    float[] res = new float[src.width*src.height];
    for (int i=0; i<res.length; i++)
      res[i] = brightness(src.pixels[i]);
    FloatBuffer fb = Buffers.newDirectFloatBuffer(src.width*src.height);
    fb.put(res);
    fb.rewind();
    return fb;
  }

  public final PGraphics toImg(FloatBuffer fb) {
    float[] src = new float[this.simWidth*this.simHeight];
    fb.get(src, 0, src.length); 
    PImage res = createImage(this.simWidth, this.simHeight, RGB);
    res.loadPixels();
    for (int i=0; i<src.length; i++)
      res.pixels[i] = color(src[i]);
    res.updatePixels();
    return toGraphics(res);
  }

  void updateFlameShader(int steps, float sub) {
    println("------------------------------------------------------------ Sim Start -----------------------------------------------------------");

    this.computeShader.buffers[0] = toBuffer(this.fire);
    this.computeShader.buffers[1] = toBuffer(this.noiseMap.map);

    this.computeShader.upload();
    this.computeShader.startCompute();
    this.computeShader.gl.glUniform1ui(this.computeShader.gl.glGetUniformLocation(this.computeShader.programId, "steps"), steps);
    this.computeShader.gl.glUniform1f(this.computeShader.gl.glGetUniformLocation(this.computeShader.programId, "sub"), sub);
    this.computeShader.compute(simWidth/8, simHeight/8, 1, 8, 8, 1);
    this.computeShader.download();
    this.fire = toGraphics(toImg((FloatBuffer)this.computeShader.buffers[1]));
  }

  void flame(int isteps, float sub) {
    int steps = isteps;
    PGraphics nextFrame = createGraphics(this.simWidth, this.simHeight);

    this.fire.beginDraw();
    this.fire.loadPixels();
    nextFrame.beginDraw();
    nextFrame.loadPixels();

    for (int x = 0; x < this.simWidth; x++) {
      for (int y = 0; y < this.simHeight; y++) {
        if (x==0 || x==this.simWidth-1 || y==steps || y>=this.simHeight-1-steps) {
          nextFrame.pixels[y * this.simWidth + x] = color(0);
          continue;
        }

        int index0 = this.simWidth*(y+0) + x;

        int index1 = this.simWidth*(y+steps+0) + (x+1);
        int index2 = this.simWidth*(y+steps+0) + (x-1);
        int index3 = this.simWidth*(y+steps+1) + (x+0);
        int index4 = this.simWidth*(y+steps-1) + (x+0);
        int index5 = this.simWidth*(y+steps) + x;

        float c0 = brightness(fire.pixels[index1]);
        float c1 = brightness(fire.pixels[index2]);
        float c2 = brightness(fire.pixels[index3]);
        float c3 = brightness(fire.pixels[index4]);
        float c4 = brightness(fire.pixels[index5]);
        float avg = (c0 + c1 + c2 + c3 + c4)/5;

        float c5 = brightness(noiseMap.map.pixels[index0]);

        float newC = max(avg - c5*sub, 0);

        nextFrame.pixels[index0] = color(newC);
      }
    }

    nextFrame.updatePixels();

    nextFrame.endDraw();
    this.fire.endDraw();
    this.fire = nextFrame;
  }
}
