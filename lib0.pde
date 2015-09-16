//================================= global vars
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
int lastRipple = 0;
int lastFrameCount = 0;
int waitCount = 20;
int skipCount = 20;

// adjustment
int switchRate = 4; // switch interval
float levelRate = 0.08; // input level

// status
boolean inverted     = false;
boolean scaleDown    = false;

// init
boolean accelEnabled    = false;
boolean scaleEnabled    = false;
boolean moveEnabled     = false;
// mid
boolean particleEnabled = false;
boolean rippleEnabled   = false;
boolean windEnabled     = false;
// last
boolean colorEnabled    = false;
boolean invertEnabled   = false;
boolean slashEnabled    = false;
boolean noiseEnabled    = false;

//================================= init

void setup() {

  size(displayWidth, displayHeight, P3D);
  colorMode(HSB,360,100,100);
  //blendMode(BLEND);
  clearBackground();
  smooth();
  frameRate(FPS);

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

void clearBackground() {
  if (inverted) {
    background(0,0,80);
  } else {
    background(0,0,0);
  }
}

void draw() {

  // clear
  clearBackground();
  // mic update
  mic.update();

  // draw model updates
  //println("lv:",mic.leftLevel(),"rv:",mic.rightLevel(),"mv:",mic.mixLevel(),"av:",mic.average);

  int rate = FPS * switchRate;
  boolean flag = (frameCount % rate - (rate/4*3) > 0);
  if (invertEnabled && inverted != flag) {
    setInverted(flag);
  }

  //if (mic.beatIsKick()) {
  if (frameCount % rate == 0) {
    println("kick: ", frameCount);
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
    if (abs(mic.rightLevel()) > levelRate) {
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
  if (noiseEnabled && abs(mic.leftLevel()) > levelRate) {
    silk.drawNoisy();
  }
  silk.draw();
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
    h = random(180, 250);
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
