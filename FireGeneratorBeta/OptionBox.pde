class OptionCheckBox extends Option {
  boolean bValue;

  public OptionCheckBox() {
    this.name = "TestCheckBox";
    this.type = "checkbox";
    this.height = OPTION_HEIGHT;

    this.bValue = false;
  }
  void update(int w) {
  }
  void show(PGraphics p, int yOff) {
    p.noStroke();
    p.rectMode(CORNERS);
    if (this.mousePressed)
      p.fill(100, 80, 80);
    else if (this.mouseOver)
      p.fill(80, 100, 80);
    else
      p.fill(80);
    p.rect(0, yOff, p.width, yOff+this.height);

    p.stroke(50);
    p.strokeWeight(1);
    p.line(0, yOff, p.width, yOff);

    p.fill(0);
    p.textSize(12);
    p.textAlign(LEFT, CENTER);
    p.text(name/*+" ["+type+"]"*/, 5, yOff+OPTION_HEIGHT/2*0, TEXT_WIDTH, yOff+OPTION_HEIGHT/2*2);

    p.noFill();
    if (bValue)
      p.fill(30);
    p.stroke(30);
    p.strokeWeight(2);
    p.rectMode(CENTER);
    p.rect(p.width-OPTION_HEIGHT/2, yOff+OPTION_HEIGHT/2, CHECKBOX_WIDTH, CHECKBOX_WIDTH, 3);
  }
  boolean boxCol(int px, int py, int x1, int y1, int x2, int y2) {
    return px>x1&&px<x2 && py>y1&&py<y2;
  }

  void mousePressed(PApplet p) {
    this.mouseButton = p.mouseButton;
    this.mousePressed = this.mouseOver;
    this.bValue = this.mousePressed ? !this.bValue : this.bValue;
  }
  void mouseReleased(PApplet p) {
    this.mouseButton = p.mouseButton;
    this.mousePressed = false;
  }
  void mouseWheel() {
  }
  void keyPressed(PApplet p) {
  }
  void keyReleased(PApplet p) {
  }
}
