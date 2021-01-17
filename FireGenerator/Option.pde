public abstract class Option {
  //general
  String name, type;
  int pmouseX, pmouseY, mouseX, mouseY, mouseButton;
  boolean mouseOver, mousePressed;
  float height;

  //interaction
  boolean used;
  int usedNum;

  public Option() {
  }

  Option(String name, String type) {
    this.name = name;
    this.type = type;

    this.height = OPTION_HEIGHT;
    if (this.type == "vector3d")
      this.height = OPTION_HEIGHT*3;
    else if (this.type == "vector2d")
      this.height = OPTION_HEIGHT*2;
  }

  public final void updateMouse(int mouseX, int mouseY) {
    this.pmouseX = this.mouseX;
    this.pmouseY = this.mouseX;
    this.mouseX = mouseX;
    this.mouseY = mouseY;
    this.mouseOver = this.mouseY>0 && this.mouseY<this.height;
  }

  abstract void update(int width);
  abstract void show(PGraphics p, int yOff);
  abstract void mousePressed(PApplet p);
  abstract void mouseReleased(PApplet p);
  abstract void mouseWheel();
  abstract void keyPressed(PApplet p);
  abstract void keyReleased(PApplet p);
}
















//class Option {
//  //general
//  String name, type;
//  int pmouseX, pmouseY, mouseX, mouseY, mouseButton;
//  boolean mouseOver, mousePressed;
//  float height;

//  //value
//  boolean bValue;
//  float fValue, fMinValue, fMaxValue;
//  int iValue, iMinValue, iMaxValue;
//  PVector vValue;
//  String sValue;
//  int sCursor;
//  boolean sliderClickable;

//  //interaction
//  boolean used;
//  int usedNum;

//  public Option() {
//  }

//  Option(String name, String type) {
//    this.name = name;
//    this.type = type;

//    this.height = OPTION_HEIGHT;
//    if (this.type == "vector3d")
//      this.height = OPTION_HEIGHT*3;
//    else if (this.type == "vector2d")
//      this.height = OPTION_HEIGHT*2;

//    this.bValue = DEFAULT_B_VALUE;
//    this.fValue = DEFAULT_F_VALUE;
//    this.fMinValue = DEFAULT_F_MIN_VALUE;
//    this.fMaxValue = DEFAULT_F_MAX_VALUE;
//    this.iValue = DEFAULT_I_VALUE;
//    this.iMinValue = DEFAULT_I_MIN_VALUE;
//    this.iMaxValue = DEFAULT_I_MAX_VALUE;
//    this.vValue = DEFAULT_V_VALUE.copy();
//    this.sValue = DEFAULT_S_VALUE;
//    this.sCursor = 0;
//    this.sliderClickable = DEFAULT_SLIDER_CLICKABLE;
//  }
//  Option setSliderRange(float min, float max) {
//    this.fMinValue = min;
//    this.fMaxValue = max;
//    return this;
//  }
//  Option setIntSliderRange(int min, int max) {
//    this.iMinValue = min;
//    this.iMaxValue = max;
//    return this;
//  }
//  Option setSliderClickable(boolean clickable) {
//    this.sliderClickable = clickable;
//    return this;
//  }
//  Option setSliderValue(float fValue) {
//    this.fValue = fValue;
//    return this;
//  }
//  Option setVector(PVector vValue) {
//    this.vValue = vValue;
//    return this;
//  }
//  public final void updateMouse(int mouseX, int mouseY) {
//    this.pmouseX = this.mouseX;
//    this.pmouseY = this.mouseX;
//    this.mouseX = mouseX;
//    this.mouseY = mouseY;
//    this.mouseOver = this.mouseY>0 && this.mouseY<this.height;
//  }
//  void update(PApplet p) {
//    switch(this.type) {
//    case "slider":
//      if (used) {
//        this.fValue = constrain(map(this.mouseX, TEXT_WIDTH+PADDING*2, p.width-PADDING*2, fMinValue, fMaxValue), fMinValue, fMaxValue);
//      }
//      break;
//    case "int_slider":
//      if (used) {
//        this.iValue = (int)(constrain(map(this.mouseX, TEXT_WIDTH+PADDING*2, p.width-PADDING*2, iMinValue, iMaxValue), iMinValue, iMaxValue)+.5);
//      }
//      break;
//    case "vector3d":
//      if (used) {
//        float fac = this.mouseButton==LEFT ? 1 : this.mouseButton==CENTER ? 10 : .1;
//        fac *= keyCodes[SHIFT] ? .1 : 1;
//        if (usedNum==0) {
//          this.vValue.x += (this.mouseX-this.pmouseX)*fac;
//        } else if (usedNum==1) {
//          this.vValue.y += (this.mouseX-this.pmouseX)*fac;
//        } else if (usedNum==2) {
//          this.vValue.z += (this.mouseX-this.pmouseX)*fac;
//        }
//      }
//      break;
//    case "vector2d":
//      if (used) {
//        float fac = this.mouseButton==LEFT ? 1 : this.mouseButton==CENTER ? 10 : .1;
//        fac *= keyCodes[SHIFT] ? .1 : 1;
//        if (usedNum==0) {
//          this.vValue.x += (this.mouseX-this.pmouseX)*fac;
//        } else if (usedNum==1) {
//          this.vValue.y += (this.mouseX-this.pmouseX)*fac;
//        }
//      }
//      break;
//    }
//  }
//  void show(PApplet p, int yOff) {
//    p.noStroke();
//    p.rectMode(CORNERS);
//    if (this.mousePressed&&this.type=="checkbox")
//      p.fill(100, 80, 80);
//    else if (this.mouseOver)
//      p.fill(80, 100, 80);
//    else
//      p.fill(80);
//    p.rect(0, yOff, p.width, yOff+this.height);

//    p.stroke(50);
//    p.strokeWeight(1);
//    p.line(0, yOff, p.width, yOff);

//    if (this.type == "space")
//      return;

//    p.fill(0);
//    p.textSize(12);
//    p.textAlign(LEFT, CENTER);
//    p.text(name/*+" ["+type+"]"*/, 5, yOff+OPTION_HEIGHT/2*0, TEXT_WIDTH, yOff+OPTION_HEIGHT/2*2);

//    switch(this.type) {
//    case "none":
//      p.stroke(30);
//      p.strokeWeight(2);
//      p.line(TEXT_WIDTH+PADDING, yOff+OPTION_HEIGHT/2, p.width-PADDING, yOff+OPTION_HEIGHT/2);
//      break;
//    case "textbox":
//      p.noFill();
//      p.stroke(this.used?164:30);
//      p.textSize(12);
//      p.strokeWeight(2);
//      p.rectMode(CORNERS);
//      p.rect(TEXT_WIDTH+PADDING, yOff+PADDING/2, p.width-PADDING, yOff+OPTION_HEIGHT-PADDING/2, 3);
//      if (this.used && frameCount%60>30)
//        p.line(TEXT_WIDTH+PADDING*2+p.textWidth(this.sValue), yOff+PADDING, TEXT_WIDTH+PADDING*2+p.textWidth(this.sValue), yOff+OPTION_HEIGHT-PADDING);

//      p.fill(0);
//      p.textAlign(LEFT, CENTER);
//      p.text(this.sValue, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT/2);
//      break;
//    case "checkbox":
//      p.noFill();
//      if (bValue)
//        p.fill(30);
//      p.stroke(30);
//      p.strokeWeight(2);
//      p.rectMode(CENTER);
//      p.rect(p.width-OPTION_HEIGHT/2, yOff+OPTION_HEIGHT/2, CHECKBOX_WIDTH, CHECKBOX_WIDTH, 3);
//      break;
//    case "slider":
//      p.stroke(30);
//      p.strokeWeight(2);
//      p.line(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT/2, p.width-PADDING*2, yOff+OPTION_HEIGHT/2);
//      p.noFill();
//      if (used)
//        p.fill(30);
//      p.ellipse(getSliderX(p), yOff+OPTION_HEIGHT/2, SLIDER_RADIUS*2, SLIDER_RADIUS*2);
//      break;
//    case "int_slider":
//      p.stroke(30);
//      p.strokeWeight(2);
//      p.line(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT/2, p.width-PADDING*2, yOff+OPTION_HEIGHT/2);
//      p.fill(30);
//      for (int i=iMinValue; i<iMaxValue+1; i++)
//        p.ellipse(map(i, iMinValue, iMaxValue, TEXT_WIDTH+PADDING*2, p.width-PADDING*2), yOff+OPTION_HEIGHT/2, 5, 5);
//      p.noFill();
//      if (used)
//        p.fill(30);
//      p.ellipse(getIntSliderX(p), yOff+OPTION_HEIGHT/2, SLIDER_RADIUS*2, SLIDER_RADIUS*2);
//      break;
//    case "vector3d":
//      p.noFill();
//      p.stroke(30);
//      p.strokeWeight(1);
//      p.rectMode(CORNERS);
//      p.textSize(12);
//      p.textAlign(LEFT, CENTER);
//      int x1 = TEXT_WIDTH+PADDING*2;
//      int x2 = p.width-PADDING*2;
//      boolean over = this.mouseOver && boxCol(this.mouseX, this.mouseY%OPTION_HEIGHT, x1, OPTION_HEIGHT*0+VALUE_BOX_PADDING, x2, OPTION_HEIGHT*1-VALUE_BOX_PADDING);
//      int overNum = this.mouseY / OPTION_HEIGHT;

//      color c1 = 80;
//      if (used && usedNum==0)
//        c1 = 128;
//      else if (over && overNum==0)
//        c1 = 30;
//      else if (mouseOver)
//        c1 = color(80, 100, 80);

//      color c2 = 80;
//      if (used && usedNum==1)
//        c2 = 128;
//      else if (over && overNum==1)
//        c2 = 30;
//      else if (mouseOver)
//        c2 = color(80, 100, 80);

//      color c3 = 80;
//      if (used && usedNum==2)
//        c3 = 128;
//      else if (over && overNum==2)
//        c3 = 30;
//      else if (mouseOver)
//        c3 = color(80, 100, 80);

//      p.fill(c1);
//      p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*0+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*1-VALUE_BOX_PADDING);
//      p.fill(c2);
//      p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*1+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*2-VALUE_BOX_PADDING);
//      p.fill(c3);
//      p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*2+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*3-VALUE_BOX_PADDING);

//      p.fill(0);
//      p.text(this.vValue.x, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*0.5);
//      p.text(this.vValue.y, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*1.5);
//      p.text(this.vValue.z, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*2.5);
//      break;
//    case "vector2d":
//      p.noFill();
//      p.stroke(30);
//      p.strokeWeight(1);
//      p.rectMode(CORNERS);
//      p.textSize(12);
//      p.textAlign(LEFT, CENTER);
//      x1 = TEXT_WIDTH+PADDING*2;
//      x2 = p.width-PADDING*2;
//      over = this.mouseOver && boxCol(this.mouseX, this.mouseY%OPTION_HEIGHT, x1, OPTION_HEIGHT*0+VALUE_BOX_PADDING, x2, OPTION_HEIGHT*1-VALUE_BOX_PADDING);
//      overNum = this.mouseY / OPTION_HEIGHT;

//      c1 = 80;
//      if (used && usedNum==0)
//        c1 = 128;
//      else if (over && overNum==0)
//        c1 = 30;
//      else if (mouseOver)
//        c1 = color(80, 100, 80);

//      c2 = 80;
//      if (used && usedNum==1)
//        c2 = 128;
//      else if (over && overNum==1)
//        c2 = 30;
//      else if (mouseOver)
//        c2 = color(80, 100, 80);

//      p.fill(c1);
//      p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*0+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*1-VALUE_BOX_PADDING);
//      p.fill(c2);
//      p.rect(TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*1+VALUE_BOX_PADDING, p.width-PADDING*2, yOff+OPTION_HEIGHT*2-VALUE_BOX_PADDING);

//      p.fill(0);
//      p.text(this.vValue.x, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*0.5);
//      p.text(this.vValue.y, TEXT_WIDTH+PADDING*2, yOff+OPTION_HEIGHT*1.5);
//      break;
//    }
//  }
//  boolean boxCol(int px, int py, int x1, int y1, int x2, int y2) {
//    return px>x1&&px<x2 && py>y1&&py<y2;
//  }
//  float getSliderX(PApplet p) {
//    return map(this.fValue, fMinValue, fMaxValue, TEXT_WIDTH+PADDING*2, p.width-PADDING*2);
//  }
//  float getIntSliderX(PApplet p) {
//    return map(this.iValue, iMinValue, iMaxValue, TEXT_WIDTH+PADDING*2, p.width-PADDING*2);
//  }
//  void mousePressed(PApplet p) {
//    this.mouseButton = p.mouseButton;
//    this.mousePressed = this.mouseOver;
//    switch(this.type) {
//    case "checkbox":
//      this.bValue = this.mousePressed?!this.bValue:this.bValue;
//      break;
//    case "slider":
//      if (dist(this.mouseX, this.mouseY, this.getSliderX(p), OPTION_HEIGHT/2)<=SLIDER_RADIUS)
//        this.used = true;
//      else if (this.sliderClickable && mouseY>0 && mouseY<OPTION_HEIGHT && mouseX>TEXT_WIDTH+PADDING*2-SLIDER_RADIUS && mouseX<p.width-PADDING*2+SLIDER_RADIUS)
//        this.used = true;
//      break;
//    case "int_slider":
//      if (dist(this.mouseX, this.mouseY, this.getIntSliderX(p), OPTION_HEIGHT/2)<=SLIDER_RADIUS)
//        this.used = true;
//      else if (this.sliderClickable && mouseY>0 && mouseY<OPTION_HEIGHT && mouseX>TEXT_WIDTH+PADDING*2-SLIDER_RADIUS && mouseX<p.width-PADDING*2+SLIDER_RADIUS)
//        this.used = true;
//      break;
//    case "textbox":
//      this.used = this.mousePressed?!this.used:false;
//      break;
//    case "vector3d":
//      int x1 = TEXT_WIDTH+PADDING*2;
//      int x2 = p.width-PADDING*2;
//      this.used = this.mouseOver && boxCol(this.mouseX, this.mouseY%OPTION_HEIGHT, x1, OPTION_HEIGHT*0+VALUE_BOX_PADDING, x2, OPTION_HEIGHT*1-VALUE_BOX_PADDING);
//      this.usedNum = this.mouseY / OPTION_HEIGHT;
//      break;
//    case "vector2d":
//      x1 = TEXT_WIDTH+PADDING*2;
//      x2 = p.width-PADDING*2;
//      this.used = this.mouseOver && boxCol(this.mouseX, this.mouseY%OPTION_HEIGHT, x1, OPTION_HEIGHT*0+VALUE_BOX_PADDING, x2, OPTION_HEIGHT*1-VALUE_BOX_PADDING);
//      this.usedNum = this.mouseY / OPTION_HEIGHT;
//      break;
//    }
//  }
//  void mouseReleased(PApplet p) {
//    this.mouseButton = p.mouseButton;
//    this.mousePressed = false;
//    switch(this.type) {
//    case "slider":
//      this.used = false;
//      break;
//    case "int_slider":
//      this.used = false;
//      break;
//    case "vector3d":
//      this.used = false;
//      break;
//    case "vector2d":
//      this.used = false;
//      break;
//    }
//  }
//  void mouseWheel() {
//  }
//  void keyPressed(PApplet p) {
//    switch(p.keyCode) {
//    case SHIFT:
//    case ALT:
//      return;
//    }
//    switch(this.type) {
//    case "textbox":
//      switch(p.key) {
//      case BACKSPACE:
//        if (this.used && this.sValue.length()>0)
//          this.sValue = this.sValue.substring(0, this.sValue.length()-1);
//        break;
//      case ENTER:
//        this.used = false;
//        break;
//      default:
//        if (this.used)
//          this.sValue += p.key;
//        break;
//      }
//      break;
//    }
//  }
//  void keyReleased(PApplet p) {
//  }
//}
