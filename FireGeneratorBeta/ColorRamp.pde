public final class ColorRamp {
  color[] colors;
  boolean filter;

  public ColorRamp() {
    this.colors = new color[]{};
    this.filter = false;
  }

  public ColorRamp(PImage source) {
    this.setPalette(source);
    this.filter = false;
  }

  public ColorRamp(PImage source, boolean filter) {
    this.setPalette(source);
    this.filter = filter;
  }

  public final void setPalette(PImage source) {
    //this.colors = new color[]{color(0), color(0), color(0)};
    //this.colors = new color[]{color(0)};
    this.colors = new color[]{};

    source.loadPixels();

    boolean backwards = brightness(source.pixels[source.width-1]) < brightness(source.pixels[0]);
    backwards = false;
    for (int i = 0; i < source.width; i++) {
      int index = backwards ? source.width-1-i : i;
      this.colors = append(this.colors, this.preProcess(source.pixels[index]));
    }
    source.updatePixels();
  }

  private final color preProcess(color raw) {
    int mode = 1;
    if (mode==1)
      return noAlpha(raw);
    return raw;
  }

  public final PImage filter(PImage target) {
    PImage output = createImage(target.width, target.height, RGB);
    target.loadPixels();
    output.loadPixels();
    for (int x = 0; x < output.width; x++)
      for (int y = 0; y < output.height; y++)
        output.pixels[y*output.width+x] = this.sample(brightness(target.pixels[y*target.width+x])/255.);//setAlpha(this.sample(brightness(target.pixels[y*target.width+x])/255.), min(brightness(target.pixels[y*target.width+x])*2, 255));

    output.updatePixels();
    return output;
  }

  public final color sample(float s) {
    if (this.filter) {
      float st = s*(this.colors.length-2);

      int i0 = (int)st;
      int i1 = i0+1;
      float lp = st-i0;

      return lerpColor(this.colors[i0], this.colors[i1], lp);
    }
    return this.colors[constrain((int)(s*(this.colors.length-1)), 0, this.colors.length-1)];
  }

  final private color lerpColor(color c1, color c2, float t) {
    float lr = lerp(red(c1), red(c2), t);
    float lg = lerp(green(c1), green(c2), t);
    float lb = lerp(blue(c1), blue(c2), t);
    return color(lr, lg, lb);
  }
}
