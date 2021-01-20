color noAlpha(color orig) {
  return color(red(orig), green(orig), blue(orig));
}

color setAlpha(color orig, float alpha) {
  float a = alpha;
  //a = brightness(orig);
  return color(red(orig), green(orig), blue(orig), a);
}

PGraphics scale(PImage img, int w, int h) {
  PGraphics temp = createGraphics(w, h);
  temp.noSmooth();
  temp.beginDraw();
  temp.imageMode(CORNERS);
  temp.image(img, 0, 0, w, h);
  temp.endDraw();
  return temp;
}

PGraphics toGraphics(PImage img) {
  PGraphics temp = createGraphics(img.width, img.height);
  temp.noSmooth();
  temp.beginDraw();
  temp.imageMode(CORNERS);
  temp.image(img, 0, 0, img.width, img.height);
  temp.endDraw();
  return temp;
}

PImage renderPoint(int r) {
  PGraphics tPoint = createGraphics(r*2, r*2);
  tPoint.smooth();
  tPoint.beginDraw();
  tPoint.stroke(255);
  tPoint.strokeWeight(r);
  tPoint.point(r, r);
  tPoint.endDraw();
  return tPoint;
}

void printNumberOfLines() {
  File folder = new File(sketchPath());
  String[] files = folder.list();
  int count = 0;
  for (int i=0; i<files.length; i++) {
    if (files[i].endsWith(".pde")) {
      count++;
    }
  }
  int off = 0;
  String[] programFiles = new String[count];
  for (int i=0; i<files.length; i++) {
    if (files[i].endsWith(".pde")) {
      programFiles[i-off] = files[i];
    } else {
      off++;
    }
  }
  int lineCount = -24;
  for (int i=0; i<programFiles.length; i++) {
    lineCount += loadStrings(programFiles[i]).length;
  }
  println("\n<< Program currently consists of [" + programFiles.length + "] Files with [" + lineCount + "] lines of Code >>");
}
