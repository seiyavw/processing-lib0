//============ global vars ==============
Silk silk;
Wind wind;
Particles particles;
Slashes slashes;
Ripples ripples;

Microphone mic;

final int FPS               = 30;
final int SILK_LINE_COUNT   = 700;
final int PARTICLE_COUNT    = 20;
final int SLASH_COUNT       = 20;
final int RIPPLE_COUNT      = 10;

// timing and counter
int lastRipple     = 0;
int lastFrameCount = 0;
int waitCount      = 20;
int skipCount      = 20;
int switchRate     = 1; // switch interval
float levelRate    = 0.08; // input level
float levelRateRight    = 0.05; // input level

// status
boolean inverted     = false;
boolean scaleDown    = false;

// init
boolean scaleEnabled    = true; //s
boolean moveEnabled     = true; //m
boolean accelEnabled    = true; //a
// mid
boolean particleEnabled = true; //p
boolean rippleEnabled   = true; //r
boolean windEnabled     = true; //w
// last
boolean colorEnabled    = true; //c
boolean invertEnabled   = true; //i
boolean slashEnabled    = true; //x
boolean noiseEnabled    = true; //z

//============ init ==============

void setup() {
  // initial codes here
  size(displayWidth, displayHeight, P3D);
  colorMode(HSB,360,100,100);
  smooth();
  frameRate(FPS);

  clearBackground();

  // values
  lastFrameCount = frameCount;

  // microphone
  mic = new Microphone();

  //  silk
  float r  = width * 0.7;
  float cx = width/2.0;
  float cy = height/2.0;
  silk = new Silk(r, cx, cy);
  silk.createLines(SILK_LINE_COUNT);

  // wind
  wind = new Wind();
  wind.update();

  // particles
  particles = new Particles(PARTICLE_COUNT);

  // slash
  slashes = new Slashes(SLASH_COUNT);

  // ripples
  ripples = new Ripples(RIPPLE_COUNT);

  // switch
  switchDrawing();

}

void draw() {
  // update and drawing
  clearBackground();
  // mic update
  mic.update();
  micLog();

  // draw model updates

  int rate = FPS * switchRate;
  boolean flag = (frameCount % rate - (rate/4*3) > 0);
  if (invertEnabled && inverted != flag) {
    setInverted(flag);
  }

  if (frameCount % rate == 0) {
    scaleDown = mic.average < 0.0;
    switchDrawing();
  }

  if (rippleEnabled) {
    if(millis() > lastRipple + 2000) {
      lastRipple = millis();
      ripples.update();
    }
  }

  if (frameCount - lastFrameCount < waitCount) {
    for (int i = 0; i < skipCount; i ++) {
      silk.next();
    }
  } else {
    silk.next();
  }

  if (scaleEnabled) {
    if (scaleDown) {
      silk.scale -= 0.001;
    } else {
      silk.scale += 0.001;
    }
  }

  // draw components
  if (slashEnabled) {
    if (abs(mic.rightLevel()) > levelRateRight) {
      drawSlashes();
    }
  }

  // particles
  if (particleEnabled) {
    drawParticles();
  }
  // ripples
  if (rippleEnabled) {
    drawRipples();
  }
  // wind
  if (windEnabled) {
    wind.draw();
  }

  //silk
  if (noiseEnabled && mic.leftLevel() > levelRate) {
    silk.drawNoisy();
  }
  silk.draw();

}

void micLog() {
  println("lv:",mic.leftLevel(),"rv:",mic.rightLevel());
}

void clearBackground() {
  if (inverted) {
    background(0,0,80);
  } else {
    background(0,0,0);
  }
}

void changeColor() {
  float h = 0;
  float s = 0;
  float b = 100;
  float a = 60;
  if (inverted) {
    b = 0;
    a = 40;
  }
  wind.setHSBA(h,s,b,a);
  particles.setHSBA(h,s,b,30);

  if (colorEnabled && !inverted) {
    h = random(0, 360);
    s = 50;
    b = 80;
  }
  silk.setHSBA(h,s,b,50);
}

void switchDrawing() {

  waitCount = 5;
  skipCount = (accelEnabled) ? 50 : 1;
  lastFrameCount = frameCount;

  // clear and reset color
  clearBackground();
  changeColor();

  // wind
  wind.update();

  // silk
  silk.scale = 0.5;
  silk.blur = 5.0 + abs(mic.average) * 5.0;

  // slash
  if (slashEnabled) {
    slashes.update();
  }

  // random size and pos
  if (moveEnabled) {
    silk.randomPosition();
  }

  // create new lines
  silk.createLines(SILK_LINE_COUNT);
}

void drawParticles() {

  float x  = random(width);
  float y  = random(height);
  float sw = random(width/2.0, width);
  float sh = random(height/2.0, height);
  particles.draw(x,y,sw,sh);
}

void setInverted(boolean _inverted) {
  inverted = _inverted;
  changeColor();
}

void drawRipples() {
  ripples.draw(inverted);
}

void drawSlashes() {
  slashes.draw(inverted);
}

//=================================
void mouseMoved() {
}

void keyPressed() {

  switch (key) {
    case 'a':
      accelEnabled = !accelEnabled;
      break;
    case 'm':
      moveEnabled = !moveEnabled;
      break;
    case 's':
      scaleEnabled = !scaleEnabled;
      break;
    case 'i':
      invertEnabled = !invertEnabled;
      break;
    case 'r':
      rippleEnabled = !rippleEnabled;
      break;
    case 'c':
      colorEnabled = !colorEnabled;
      break;
    case 'w':
      windEnabled = !windEnabled;
      break;
    case 'p':
      particleEnabled = !particleEnabled;
      break;
    case 'x':
      slashEnabled = !slashEnabled;
      break;
    case 'z':
      noiseEnabled = !noiseEnabled;
      break;
    case 'n':
      silk.type = SILK_NORMAL;
      break;
    case 'e':
      silk.type = SILK_EDGE;
      break;
    case CODED:
      if (keyCode == LEFT) {
        switchRate++;
      } else if (keyCode == RIGHT) {
        if (switchRate > 1) {
          switchRate--;
        }
      }
      break;
    default:
      break;
  }
}

void mousePressed() {
  switchDrawing();
}