boolean[] keys = new boolean[128], keyCodes = new boolean[128];

void keyPressed() {
  if (this.key<128)
    keys[key] = true;
  if (this.keyCode<128)
    keyCodes[keyCode] = true;

  if (key == 'l')
    selectInput("Select a palette file:", "paletteSelected");
}

void keyReleased() {
  if (this.key<128)
    keys[key] = false;
  if (this.keyCode<128)
    keyCodes[keyCode] = false;
}

void paletteSelected(File selection) {
  println("User selected " + selection.getAbsolutePath());
  String file = selection.getAbsolutePath();
  simulation.colors.set(loadImage(file));
}
