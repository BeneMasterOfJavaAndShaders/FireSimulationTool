class OptionSlider extends Option {
  float fValue, fMinValue, fMaxValue;
  boolean sliderClickable;

  public OptionSlider(String name) {
    this.name = name;
    this.type = "slider";
    this.height = OPTION_HEIGHT;

    this.fValue = 5;
    this.fMinValue = 0;
    this.fMaxValue = 10;
  }

  OptionSlider setRange(float min, float max) {
    this.fMinValue = min;
    this.fMaxValue = max;
    return this;
  }
  OptionSlider setClickable(boolean clickable) {
    this.sliderClickable = clickable;
    return this;
  }
  OptionSlider setValue(float fValue) {
    this.fValue = fValue;
    return this;
  }
  void update(int width) {
    if (used)
      this.fValue = constrain(map(this.mouseX, TEXT_WIDTH+PADDING*2, width-PADDING*2, fMinValue, fMaxValue), fMinValue, fMaxValue);
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

    p.fill(0);
    p.textSize(12);
    p.textAlign(LEFT, CENTER);
    p.text(name/*+" ["+type+"]"*/, 5, yOff+OPTION_HEIGHT/2*0, TEXT_WIDTH, yOff+OPTION_HEIGHT/2*2);

    p.stroke(30);
    p.strokeWeight(2);
    p.line(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT/2, p.width-PADDING*2, yOff+OPTION_HEIGHT/2);
    p.noFill();
    if (used)
      p.fill(30);
    p.ellipse(getSliderX(p.width), yOff+OPTION_HEIGHT/2, SLIDER_RADIUS*2, SLIDER_RADIUS*2);
  }

  float getSliderX(int width) {
    return map(this.fValue, fMinValue, fMaxValue, TEXT_WIDTH+PADDING*2, width-PADDING*2);
  }

  void mousePressed(PApplet p) {
    this.mouseButton = p.mouseButton;
    this.mousePressed = this.mouseOver;

    if (dist(this.mouseX, this.mouseY, this.getSliderX(p.width), OPTION_HEIGHT/2)<=SLIDER_RADIUS)
      this.used = true;
    else if (this.sliderClickable && mouseY>0 && mouseY<OPTION_HEIGHT && mouseX>TEXT_WIDTH+PADDING*2-SLIDER_RADIUS && mouseX<p.width-PADDING*2+SLIDER_RADIUS)
      this.used = true;
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
