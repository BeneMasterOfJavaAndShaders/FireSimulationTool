public final class EditorWindow extends PApplet {
  FireSimulation sim;
  OptionPanel op;

  public EditorWindow(FireSimulation sim) {
    this.sim = sim;
    this.op = new OptionPanel();
    this.op.addOption(new OptionSlider("noiseSize").setRange(0, this.sim.noiseMap.noisePerPixel*2).setValue(this.sim.noiseMap.noisePerPixel));
    this.op.addOption(new OptionSlider("noiseSpeed").setRange(0, 10).setValue(this.sim.noiseMapSpeed));
    this.op.addOption(new OptionSlider("coolDown").setRange(0, 2).setValue(this.sim.coolDown));
    this.op.addOption(new OptionSlider("flameSteps").setRange(0, 10).setValue(this.sim.flameSteps));

    //this.op.addOption(new OptionCheckBox());
    //this.op.addOption(new OptionVector3D());
    //this.op.addOption(new OptionSlider(""));
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  void addOption(Option o) {
    this.op.addOption(o);
  }

  void settings() {
    //this.noSmooth();
  }

  void setup() {
    this.surface.setSize(800, 700);
    this.surface.setLocation(displayWidth/2+5, displayHeight/2-this.height/2);
    this.surface.setResizable(true);
    frameRate(60);
  }

  void draw() {
    background(60);
    this.op.setState(this.width, this.height/2, this.mouseX, this.mouseY);
    this.op.update();

    this.sim.noiseMap.noisePerPixel = ((OptionSlider)this.op.options[0]).fValue;
    ((OptionSlider)this.op.options[1]).fValue = (int)((OptionSlider)this.op.options[1]).fValue;
    this.sim.noiseMapSpeed = (int)((OptionSlider)this.op.options[1]).fValue;
    this.sim.coolDown = ((OptionSlider)this.op.options[2]).fValue;
    ((OptionSlider)this.op.options[3]).fValue = (int)((OptionSlider)this.op.options[3]).fValue;
    this.sim.flameSteps = (int)((OptionSlider)this.op.options[3]).fValue;

    PGraphics panel = createGraphics(op.width, op.height);
    panel.beginDraw();
    this.op.draw(panel);
    panel.endDraw();
    this.image(panel, 0, 0);
  }

  void mousePressed() {
    op.mousePressed(this);
  }

  void mouseReleased() {
    op.mouseReleased(this);
  }

  void mouseWheel(MouseEvent m) {
    int count = m.getCount(); 
    float s = count==1 ? 1.1 : 1/1.1;
    op.mouseWheel(count);
  }
}
