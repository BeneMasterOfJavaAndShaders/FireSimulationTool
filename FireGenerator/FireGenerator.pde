import com.jogamp.opengl.*;

FireSimulation simulation;

final static int pixelSize = 5;
PImage staticFire;
PImage point;

DebugView dw;
EditorWindow w;
//OptionWindow w;

void settings() {
  noSmooth();
}

void setup() {
  this.printNumberOfLines();
  frameRate(60);

  point = renderPoint(5);

  simulation = new FireSimulation(128, 128, 4, sqrt(pixelSize)/20);

  PImage extMask = loadImage(dataPath("masks/Mask0.png"));
  staticFire = createImage(simulation.simWidth, simulation.simHeight, ARGB);
  staticFire.copy(extMask, 0, 0, extMask.width, extMask.height, simulation.margin, simulation.margin, extMask.width, extMask.height);
  staticFire.loadPixels();
  for (int i=0; i<simulation.margin; i++)
    for (int x=0; x<simulation.simWidth; x++)
      staticFire.pixels[(simulation.simHeight-1-i) * simulation.simWidth + x] = color(255);
  staticFire.updatePixels();

  surface.setSize(simulation.targetWidth * 5, simulation.targetHeight * 5);
  surface.setLocation(displayWidth/2-this.width-5, displayHeight/2-this.height/2);

  dw = new DebugView(simulation, pixelSize);
  //w = new EditorWindow(simulation);
  //w = new OptionWindow();
}

void draw() {
  surface.setTitle("Fire Fps: "+(int)frameRate);



  simulation.addFireMask(staticFire, -simulation.margin, -simulation.margin);
  if (mousePressed) {
    simulation.addFireMask(point, mouseX/pixelSize - point.width/2, mouseY/pixelSize - point.height/2);
    for (float l=0; l<1; l+=.05)
      simulation.addFireMask(point, (int)lerp(mouseX, pmouseX, l)/pixelSize - point.width/2, (int)lerp(mouseY, pmouseY, l)/pixelSize - point.height/2);
  }

  simulation.update();


  background(0);
  //background(0, 128, 0);

  image(simulation.getFrame(), 0, 0, width, height);
  //image(simulation.fire, 0, 0, width, height);
}
