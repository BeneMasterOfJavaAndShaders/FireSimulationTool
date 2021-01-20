final static int OPTION_HEIGHT = 30;
final static int TEXT_WIDTH = 150;
final static int PADDING = 8;
final static int VALUE_BOX_PADDING = 5;
final static int CHECKBOX_WIDTH = 30-PADDING*2;
final static int SLIDER_RADIUS = 7;

final static boolean DEFAULT_B_VALUE = false;
final static float DEFAULT_F_VALUE = 0;
final static float DEFAULT_F_MIN_VALUE = 0;
final static float DEFAULT_F_MAX_VALUE = 1;
final static int DEFAULT_I_VALUE = 0;
final static int DEFAULT_I_MIN_VALUE = 0;
final static int DEFAULT_I_MAX_VALUE = 10;
final static PVector DEFAULT_V_VALUE = new PVector();
final static String DEFAULT_S_VALUE = "123456789";
final static boolean DEFAULT_SLIDER_CLICKABLE = true;

class OptionWindow extends PApplet {
  int lastWidth, lastHeight;
  int windowX, windowY, lastWindowX, lastWindowY;
  int slider;
  Option[] options;

  OptionWindow() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    this.options = new Option[0];
  }
  void settings() {
    size(400, 400);
  }
  void setup() {
    this.surface.setResizable(true);
    this.surface.setLocation(displayWidth/2+25, displayHeight/2-this.height/2);//testing
  }
  void addOption(Option o) {
    this.options = (Option[])append(this.options, o);
  }
  void update() {
    this.updateWindowPos();
    if (this.width != this.lastWidth || this.height != this.lastHeight)
      this.windowResized();
    this.surface.setTitle("Sub (" + this.windowX + " | " + this.windowY + ") / (" + this.width + " * " + this.height + ")");
  }
  void draw() {
    this.update();
    background(0);
    int yOff = 0;
    for (int i=0; i<this.options.length; i++) {
      this.options[i].updateMouse(this.mouseX, this.mouseY-(yOff-this.slider));
      yOff += this.options[i].height;
    }
    for (int i=0; i<this.options.length; i++) {
      this.options[i].update(this.width);
    }
    yOff = 0;
    for (int i=0; i<this.options.length; i++) {
      //this.options[i].show(this, (yOff-this.slider));
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
  void mousePressed() {
    for (int i=0; i<this.options.length; i++)
      this.options[i].mousePressed(this);
  }
  void mouseReleased() {
    for (int i=0; i<this.options.length; i++)
      this.options[i].mouseReleased(this);
  }
  void mouseWheel(MouseEvent m) {
    int c = m.getCount();
    this.slider += c*15;
    this.slider = constrain(this.slider, 0, this.totalOptionHeight()>this.height ? this.totalOptionHeight()-this.height : 0);
  }
  void keyPressed() {
    if (this.key<128)
      keys[key] = true;
    if (this.keyCode<128)
      keyCodes[keyCode] = true;
    for (int i=0; i<this.options.length; i++)
      this.options[i].keyPressed(this);
  }
  void keyReleased() {
    if (this.key<128)
      keys[key] = false;
    if (this.keyCode<128)
      keyCodes[keyCode] = false;
    for (int i=0; i<this.options.length; i++)
      this.options[i].keyReleased(this);
  }
  void updateWindowPos() {
    final PSurface surf = getSurface();
    java.awt.Point winPos = ((processing.awt.PSurfaceAWT.SmoothCanvas)surf.getNative()).getFrame().getLocationOnScreen();
    this.lastWindowX = this.windowX;
    this.lastWindowY = this.windowY;
    this.windowX = winPos.x;
    this.windowY = winPos.y;
  }
}
