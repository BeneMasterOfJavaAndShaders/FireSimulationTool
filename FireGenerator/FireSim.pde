public final class FireSimulation {
  int simWidth, simHeight, targetWidth, targetHeight, margin;

  NoiseMap noiseMap;
  int noiseMapSpeed, flameSteps;

  PGraphics fire;
  float coolDown;

  ColorRamp colors;


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
  }

  public final void addFireMask(PImage mask, int x, int y) {
    fire.beginDraw();
    fire.image(mask, this.margin+x, this.margin+y);
    fire.endDraw();
  }

  public final PImage getFrame() {
    PImage heat = this.fire.get(this.margin, this.margin, this.targetWidth, this.targetHeight);//remove margin
    heat.loadPixels();
    for (int x = 0; x < this.targetWidth; x++)
      for (int y = 0; y < this.targetHeight; y++)
        heat.pixels[y*this.targetWidth+x] = setAlpha(this.colors.sample(brightness(heat.pixels[y*this.targetWidth+x])/255.), min(brightness(heat.pixels[y*this.targetWidth+x])*2, 255));

    heat.updatePixels();
    return heat;
  }

  public void update() {
    this.noiseMap.advance(this.noiseMapSpeed);
    this.flame(this.flameSteps, this.coolDown);
    //for (int i=0; i<2; i++)
    //this.flame(1, .4);
  }

  void flame(int isteps, float sub) {
    int steps = isteps;
    PGraphics nextFrame = createGraphics(this.simWidth, this.simHeight);

    this.fire.beginDraw();
    this.fire.loadPixels();
    nextFrame.beginDraw();
    nextFrame.background(0, 0);
    nextFrame.loadPixels();

    int w = this.simWidth;
    for (int x = 0; x < this.simWidth; x++) {
      for (int y = 0; y < this.simHeight; y++) {
        if (x==0 || x==this.simWidth-1 || y<=steps || y==this.simHeight-1) {
          nextFrame.pixels[y * this.simWidth + x] = color(0);
          continue;
        }

        int index0 = w*y + x;
        int index1 = w*(y+0) + (x+1);
        int index2 = w*(y+0) + (x-1);
        int index3 = w*(y+1) + (x+0);
        int index4 = w*(y-1) + (x+0);

        int index5 = w*(y-steps) + x;

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
