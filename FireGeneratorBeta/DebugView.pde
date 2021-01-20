public final class DebugView extends PApplet {
  FireSimulation sim;

  PVector off;
  boolean dragged;
  float scale;

  public DebugView(FireSimulation sim, int pixelSize) {
    this.sim = sim;
    this.scale = pixelSize;
    this.off = new PVector(0, 0);
    this.dragged = false;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  void settings() {
    this.noSmooth();
  }

  void setup() {
    this.surface.setSize(800, 700);
    this.surface.setLocation(displayWidth/2+5, displayHeight/2-this.height/2);
    background(0);
    frameRate(60);
    //noLoop();
  }

  void draw() {
    if (this.dragged)
      this.off.add(mouseX-pmouseX, mouseY-pmouseY);

    background(60);

    float xOff = 0;
    this.drawImg(this.sim.fire, xOff);
    xOff += (this.sim.simWidth+5)*this.scale;
    this.drawImg(this.sim.noiseMap.map, xOff);
    xOff += (this.sim.simWidth+5)*this.scale;
    this.drawImg(staticFire, xOff);

    strokeWeight(1);
    for (int x=max(0, (int)off.x); x<min(width, off.x+128*scale); x++) {
      float t = (x-off.x)/128f/scale;
      stroke(sim.colors.sample(t));
      line(x, off.y-5*scale, x, off.y-10*scale);
    }
  }

  void drawImg(PImage img, float offX) {
    if (img==null)
      return; 
    imageMode(CORNER); 
    image(img, this.off.x+offX, this.off.y, this.sim.simWidth*this.scale, this.sim.simHeight*this.scale); 

    noFill(); 
    stroke(255, 0, 0); 
    strokeWeight(2); 
    rectMode(CORNER); 
    rect(this.off.x+offX, this.off.y, sim.simWidth*scale, sim.simHeight*scale); 
    float mg = this.sim.margin * this.scale; 
    rect(this.off.x+offX+mg, this.off.y+mg, this.sim.simWidth*this.scale-mg*2, this.sim.simHeight*this.scale-mg*2);
  }

  void mousePressed() {
    this.dragged = true;
  }

  void mouseReleased() {
    this.dragged = false;
  }

  void mouseWheel(MouseEvent m) {
    int count = m.getCount(); 
    float s = count==1 ? 1.1 : 1/1.1; 
    this.scale *= s; 
    this.off.set(mouseX+(this.off.x-mouseX)*s, mouseY+(this.off.y-mouseY)*s);
  }
}
