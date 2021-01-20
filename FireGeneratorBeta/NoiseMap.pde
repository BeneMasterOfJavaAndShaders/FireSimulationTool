final public class NoiseMap {
  PImage map;
  int yOff;
  float noisePerPixel;

  public NoiseMap(int w, int h, float increment) {
    this.map = createImage(w, h, RGB);
    this.yOff = 0;
    this.noisePerPixel = increment;

    this.advance(this.map.height);
  }

  void advance(int rows) {
    shiftUp(this.map, rows);
    this.map.loadPixels();
    for (int y=this.map.height-rows; y<this.map.height; y++) {
      for (int x = 0; x < this.map.width; x++) {
        float n = noise(x*noisePerPixel, yOff*noisePerPixel);
        int bright = round(pow(n, 3) * 255);
        this.map.pixels[y * this.map.width + x] = color(bright);
      }
      yOff++;
    }
    this.map.updatePixels();
  }

  void shiftUp(PImage img, int offY) {
    img.copy(img, 0, offY, img.width, img.height - offY, 0, 0, img.width, img.height - offY);
  }
}
