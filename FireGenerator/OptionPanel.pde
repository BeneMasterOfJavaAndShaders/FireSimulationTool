class OptionPanel {
  int width, height, lastWidth, lastHeight;
  int pmouseX, pmouseY, mouseX, mouseY;

  Option[] options;
  int slider;

  OptionPanel() {

    this.options = new Option[0];
  }
  void setState(int width, int height, int mouseX, int mouseY) {
    this.lastWidth = this.width;
    this.lastHeight = this.height;
    this.width = width;
    this.height = height;
    if (this.width != this.lastWidth || this.height != this.lastHeight)
      this.windowResized();
    this.pmouseX = this.mouseX;
    this.pmouseY = this.mouseY;
    this.mouseX = mouseX;
    this.mouseY = mouseY;
  }

  void addOption(Option o) {
    this.options = (Option[])append(this.options, o);
  }

  void update() {
    int yOff = 0;
    for (int i=0; i<this.options.length; i++) {
      this.options[i].updateMouse(this.mouseX, this.mouseY-(yOff-this.slider));
      yOff += this.options[i].height;
    }
    for (int i=0; i<this.options.length; i++) {
      this.options[i].update(this.width);
    }
  }
  void draw(PGraphics p) {
    int yOff = 0;
    for (int i=0; i<this.options.length; i++) {
      this.options[i].show(p, (yOff-this.slider));
      yOff += this.options[i].height;
    }
  }
  int totalOptionHeight() {
    int totalHeight = 0;
    for (int i=0; i<this.options.length; i++)
      totalHeight += this.options[i].height;
    return totalHeight;
  }
  void windowResized() {
    this.slider = constrain(this.slider, 0, this.totalOptionHeight()>this.height ? this.totalOptionHeight()-this.height : 0);
  }

  void mousePressed(PApplet p) {
    for (int i=0; i<this.options.length; i++)
      this.options[i].mousePressed(p);
  }
  void mouseReleased(PApplet p) {
    for (int i=0; i<this.options.length; i++)
      this.options[i].mouseReleased(p);
  }
  void mouseWheel(int c) {
    this.slider += c*15;
    this.slider = constrain(this.slider, 0, this.totalOptionHeight()>this.height ? this.totalOptionHeight()-this.height : 0);
  }
  //void keyPressed(PApplet p) {
  //  if (p.key<128)
  //    keys[key] = true;
  //  if (p.keyCode<128)
  //    keyCodes[keyCode] = true;
  //  for (int i=0; i<this.options.length; i++)
  //    this.options[i].keyPressed(p);
  //}
  //void keyReleased(PApplet p) {
  //  if (p.key<128)
  //    keys[key] = false;
  //  if (p.keyCode<128)
  //    keyCodes[keyCode] = false;
  //  for (int i=0; i<this.options.length; i++)
  //    this.options[i].keyReleased(p);
  //}
}
