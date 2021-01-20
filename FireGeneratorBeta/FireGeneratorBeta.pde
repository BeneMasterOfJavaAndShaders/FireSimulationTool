FireSimulation simulation;

final static int pixelSize = 3;
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
  frameRate(-1);

  point = renderPoint(5);

  //simulation = new FireSimulation(16*4*16, 16*4*16, 4, sqrt(pixelSize*4)/20);
  simulation = new FireSimulation(4*4*16, 4*4*16, 4, sqrt(pixelSize*4)/20);

  PImage extMask = loadImage(dataPath("masks/Mask0.png"));
  staticFire = createImage(simulation.simWidth, simulation.simHeight, ARGB);
  staticFire.copy(extMask, 0, 0, extMask.width, extMask.height, simulation.margin, simulation.margin, extMask.width, extMask.height);
  staticFire.loadPixels();
  for (int i=0; i<simulation.margin; i++)
    for (int x=0; x<simulation.simWidth; x++)
      staticFire.pixels[(simulation.simHeight-1-i) * simulation.simWidth + x] = color(255);
  staticFire.updatePixels();

  surface.setSize((int)(simulation.targetWidth * pixelSize), (int)(simulation.targetHeight * pixelSize));
  surface.setLocation(displayWidth/2-this.width-5, displayHeight/2-this.height/2);

  dw = new DebugView(simulation, max((int)pixelSize, 1));
  w = new EditorWindow(simulation);
  //w = new OptionWindow();
}

void draw() {
  surface.setTitle("Fire Fps: "+(int)frameRate);

  simulation.addFireMask(staticFire, -simulation.margin, -simulation.margin);
  if (mousePressed) {
    simulation.addFireMask(point, (int)(mouseX/pixelSize) - point.width/2, (int)(mouseY/pixelSize) - point.height/2);
    for (float l=0; l<1; l+=.05)
      simulation.addFireMask(point, (int)(lerp(mouseX, pmouseX, l)/pixelSize) - point.width/2, (int)(lerp(mouseY, pmouseY, l)/pixelSize) - point.height/2);
  }

  simulation.update();


  //background(0);
  //background(0, 128, 0);

  image(simulation.getFrame(), 0, 0, width, height);
  //image(simulation.fire, 0, 0, width, height);
}
