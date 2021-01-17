public final class OptionVector3D extends Option {
  PVector vValue;

  public OptionVector3D() {
    this.name = "TestVector";
    this.type = "vector3d";
    this.height = OPTION_HEIGHT*3;

    this.vValue = new PVector();
  }
  void update(int w) {
    if (used) {
      float fac = this.mouseButton==LEFT ? 1 : this.mouseButton==CENTER ? 10 : .1;
      fac *= keyCodes[SHIFT] ? .1 : 1;
      if (usedNum==0) {
        this.vValue.x += (this.mouseX-this.pmouseX)*fac;
      } else if (usedNum==1) {
        this.vValue.y += (this.mouseX-this.pmouseX)*fac;
      } else if (usedNum==2) {
        this.vValue.z += (this.mouseX-this.pmouseX)*fac;
      }
    }
  }
  void show(PGraphics p, int yOff) {
    p.noStroke();
    p.rectMode(CORNERS);

    if (this.mouseOver)
      p.fill(80, 100, 80);
    else
      p.fill(80);
    p.rect(0, yOff, p.width, yOff+this.height);

    p.stroke(50);
    p.strokeWeight(1);
    p.line(0, yOff, p.width, yOff);

    if (this.type == "space")
      return;

    p.fill(0);
    p.textSize(12);
    p.textAlign(LEFT, CENTER);
    p.text(name/*+" ["+type+"]"*/, 5, yOff+OPTION_HEIGHT/2*0, TEXT_WIDTH, yOff+OPTION_HEIGHT/2*2);


    p.noFill();
    p.stroke(30);
    p.strokeWeight(1);
    p.rectMode(CORNERS);
    p.textSize(12);
    p.textAlign(LEFT, CENTER);
    int x1 = TEXT_WIDTH+PADDING*2;
    int x2 = p.width-PADDING*2;
    boolean over = this.mouseOver && boxCol(this.mouseX, this.mouseY%OPTION_HEIGHT, x1, OPTION_HEIGHT*0+VALUE_BOX_PADDING, x2, OPTION_HEIGHT*1-VALUE_BOX_PADDING);
    int overNum = this.mouseY / OPTION_HEIGHT;

    color c1 = 80;
    if (used && usedNum==0)
      c1 = 128;
    else if (over && overNum==0)
      c1 = 30;
    else if (mouseOver)
      c1 = color(80, 100, 80);

    color c2 = 80;
    if (used && usedNum==1)
      c2 = 128;
    else if (over && overNum==1)
      c2 = 30;
    else if (mouseOver)
      c2 = color(80, 100, 80);

    color c3 = 80;
    if (used && usedNum==2)
      c3 = 128;
    else if (over && overNum==2)
      c3 = 30;
    else if (mouseOver)
      c3 = color(80, 100, 80);

    p.fill(c1);
    p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*0+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*1-VALUE_BOX_PADDING);
    p.fill(c2);
    p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*1+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*2-VALUE_BOX_PADDING);
    p.fill(c3);
    p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*2+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*3-VALUE_BOX_PADDING);

    p.fill(0);
    p.text(this.vValue.x, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*0.5);
    p.text(this.vValue.y, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*1.5);
    p.text(this.vValue.z, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*2.5);
  }
  void mousePressed(PApplet p) {
    this.mouseButton = p.mouseButton;
    this.mousePressed = this.mouseOver;

    int x1 = TEXT_WIDTH+PADDING*2;
    int x2 = p.width-PADDING*2;
    this.used = this.mouseOver && boxCol(this.mouseX, this.mouseY%OPTION_HEIGHT, x1, OPTION_HEIGHT*0+VALUE_BOX_PADDING, x2, OPTION_HEIGHT*1-VALUE_BOX_PADDING);
    this.usedNum = this.mouseY / OPTION_HEIGHT;
  }
  boolean boxCol(int px, int py, int x1, int y1, int x2, int y2) {
    return px>x1&&px<x2 && py>y1&&py<y2;
  }
  void mouseReleased(PApplet p) {
    this.mouseButton = p.mouseButton;
    this.mousePressed = false;
    this.used = false;
  }
  void mouseWheel() {
  }
  void keyPressed(PApplet p) {
  }
  void keyReleased(PApplet p) {
  }
}
