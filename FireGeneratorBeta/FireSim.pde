public final class FireSimulation {
  int simWidth, simHeight, targetWidth, targetHeight, margin;

  NoiseMap noiseMap;
  int noiseMapSpeed, flameSteps;

  PGraphics fire;
  float coolDown;

  ColorRamp colors;

  ComputeShader computeShader;

  public FireSimulation(int targetWidth, int targetHeight, int margin, float increment) {
    this.targetWidth = targetWidth;
    this.targetHeight = targetHeight;
    this.margin = margin;
    this.simWidth = this.targetWidth + this.margin*2;
    this.simHeight = this.targetHeight + this.margin*2;

    this.fire = createGraphics(this.simWidth, this.simHeight);
    this.coolDown = 1;

    this.noiseMap = new NoiseMap(this.simWidth, this.simHeight, increment);
    this.flameSteps = 2;
    this.noiseMapSpeed = 3;

    this.colors = new ColorRamp(loadImage(sketchPath()+"\\data\\Fire-1x.png"), false);

    final String computeShaderCode
      = "#version 430 core \n"
      + "#extension GL_ARB_compute_variable_group_size : enable \n"
      + "layout (local_size_variable) in; \n"        //+ "layout (local_size_x = 8, local_size_y = 8, local_size_z = 1) in; \n"

      + "struct packet {"
      + "  float val;"
      //+ "  float padding;"
      //+ "  vec2 data;"
      + "};"

      + "layout (std430, binding = 0) buffer entities {"
      + "  packet e[];"
      + "};"

      + "layout (std430, binding = 1) buffer entities2 {"
      + "  packet e2[];"
      + "};"

      + "void main(void) {"
      + "  uvec3 globalSize = gl_NumWorkGroups * gl_LocalGroupSizeARB;"
      + "  uvec3 globalCoords = gl_WorkGroupID * gl_LocalGroupSizeARB + gl_LocalInvocationID;"
      + "  uint t = globalCoords.y * globalSize.x + globalCoords.x;"
      //+ "  t = min(t, 63);"
      + "  e2[t].val = e[t].val;"
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
  }

  public final void update() {
    this.noiseMap.advance(this.noiseMapSpeed);
    this.flame(this.flameSteps, this.coolDown);
  }

  public final float[] toBuffer(PImage src) {
    src.loadPixels();
    float[] res = new float[src.width*src.height];
    for (int i=0; i<res.length; i++)
      res[i] = brightness(src.pixels[i]);
    return res;
  }

  public final PImage toImg(float[] src, int w, int h) {
    PImage res = createImage(w, h, RGB);
    res.loadPixels();
    for (int i=0; i<src.length; i++)
      res.pixels[i] = color(src[i]);
    res.updatePixels();
    return res;
  }

  void applyShader() {
    println("------------------------------------------------------------ Sim Start -----------------------------------------------------------");
    this.computeShader.buffers[0] = Buffers.newDirectFloatBuffer(this.simWidth*this.simHeight);

    ((FloatBuffer)computeShader.buffers[0]).put(toBuffer(this.fire));
    this.computeShader.buffers[0].rewind();
    //this.computeShader.buffers[0] = FloatBuffer.wrap(toBuffer(this.fire));
    this.computeShader.buffers[1] = Buffers.newDirectFloatBuffer(this.simWidth*this.simHeight);

    this.computeShader.upload();
    //this.computeShader.compute(11, 11, 1, 8, 8, 8);
    //this.computeShader.compute(8, 8, 1, 8, 8, 1);
    this.computeShader.compute(64, 64, 1, 3, 2, 1);
    this.computeShader.download();
    float[] res = new float[this.simWidth*this.simHeight];
    ((FloatBuffer)this.computeShader.buffers[1]).get(res, 0, res.length); 
    this.fire = scale(toImg(res, this.simWidth, this.simHeight), this.simWidth, this.simHeight);
  }

  void flame(int isteps, float sub) {
    applyShader();


    int steps = isteps;
    PGraphics nextFrame = createGraphics(this.simWidth, this.simHeight);

    this.fire.beginDraw();
    this.fire.loadPixels();
    nextFrame.beginDraw();
    nextFrame.loadPixels();

    for (int x = 0; x < this.simWidth; x++) {
      for (int y = 0; y < this.simHeight; y++) {
        if (x==0 || x==this.simWidth-1 || y<=steps || y==this.simHeight-1) {
          nextFrame.pixels[y * this.simWidth + x] = color(0);
          continue;
        }

        int index0 = this.simWidth*y + x;
        int index1 = this.simWidth*(y+0) + (x+1);
        int index2 = this.simWidth*(y+0) + (x-1);
        int index3 = this.simWidth*(y+1) + (x+0);
        int index4 = this.simWidth*(y-1) + (x+0);

        int index5 = this.simWidth*(y-steps) + x;

        float c1 = brightness(fire.pixels[index1]);
        float c2 = brightness(fire.pixels[index2]);
        float c3 = brightness(fire.pixels[index3]);
        float c4 = brightness(fire.pixels[index4]);

        float c5 = brightness(noiseMap.map.pixels[index0]);

        float newC = max((c1 + c2 + c3 + c4)/4 - c5*sub, 0);

        nextFrame.pixels[index5] = color(newC);
      }
    }

    nextFrame.updatePixels();

    nextFrame.endDraw();
    this.fire.endDraw();
    this.fire = nextFrame;
  }
}
