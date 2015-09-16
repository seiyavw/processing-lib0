//================================= global vars

Silk silk;
Plant plant;

Particle[] particles;
Slash[] slashes;
Microphone mic;
Ripple[] ripples;

int switchInterval = 4000;
int lastInvert;
int invertInterval = 1500;

int lastFrameCount = 0;
int waitCount = 20;
int skipCount = 20;
int beatCount = 0;
int rippleCount = 0;

final int SILK_COUNT      = 3;
final int SILK_LINE_COUNT = 700;
final int PARTICLE_COUNT  = 20;
final int SLASH_COUNT     = 10;
final int RIPPLE_COUNT    = 10;

float cx, cy, cz;

// status
boolean inverted = true;
boolean scaleDown = false;

// mode

//================================= init

void setup() {

  size(displayWidth, displayHeight, P3D);
  //blendMode(BLEND);
  background(0);
  smooth();
  frameRate(30);

  // values
  lastFrameCount = frameCount;
  lastInvert = millis();

  // microphone
  mic = new Microphone();

  //  silk
  //float r = width;
  float r = width * 0.8;
  cx = width/2.0;
  cy = height/2.0;
  cz = (height/2.0) / tan(PI*60.0 / 360.0) / 2.0;
  silk = new Silk(r, cx, cy);
  silk.createLines(SILK_LINE_COUNT);

  // plant
  plant = new Plant();
  plant.update();

  // particles
  particles = new Particle[PARTICLE_COUNT];
  for (int i = 0; i < PARTICLE_COUNT; i++) {
    Particle p = new Particle();
    particles[i] = p;
  }
  changeColor();


  // ripples
  ripples = new Ripple[RIPPLE_COUNT];
  for (int i = 0; i < RIPPLE_COUNT; i++) {
    Ripple rip = new Ripple();
    ripples[i] = rip;
  }

  // slash
  slashes = new Slash[SLASH_COUNT];
  for (int i = 0; i < SLASH_COUNT; i++) {
    Slash s = new Slash();
    slashes[i] = s;
  }
}

void clearBackground() {
  if (inverted) {
    background(222);
  } else {
    background(0);
  }
}

void draw() {

  clearBackground();
  mic.update();

  //println("lv:",mic.leftLevel(),"rv:",mic.rightLevel(),"mv:",mic.mixLevel(),"av:",mic.average);

  if (mic.beatIsKick()) {
    println("kick: ", frameCount);

    beatCount++;

    boolean flag = (beatCount %3 == 0);
    setInverted(flag);

    // ripple
    if (rippleCount > RIPPLE_COUNT - 1) {
      rippleCount = 0;
    }
    Ripple rip = ripples[rippleCount];
    rip.update(random(width), random(height), random(height/3.0, height));
    rippleCount++;

    // change
    scaleDown = mic.average < 0.0;
    switchDrawing();
  }

  if (mic.beatIsSnare()) {
    println("snare: ", frameCount);
  }
  if (mic.beatIsOnset()) {
    println("onset: ", frameCount);
  }

  if (mic.beatIsHat()) {
    println("hat: ", frameCount);
  }

  if (frameCount - lastFrameCount < waitCount) {
    for (int i = 0; i < skipCount; i ++) {
      silk.next();
    }
  } else {
    silk.next();
  }

  //if (scaleDown) {
  //  silk.scale -= 0.001;
  //else {
  //  silk.scale += 0.001;
  //}
  //silk.scale = 0.5 + abs(mic.mixLevel() * 0.1);

  // draw components
  //drawParticles();
  drawRipples();
  plant.draw();
  silk.draw();
}

void changeColor() {
  //float r = random(255);
  //float g = random(255);
  //float b = random(255);
  float r = (inverted) ? 0 : 220;
  float g = (inverted) ? 0 : 220;
  float b = (inverted) ? 0 : 220;
  silk.r = r;
  silk.g = g;
  silk.b = b;
  plant.r = r;
  plant.g = g;
  plant.b = b;

  for (int i = 0; i < particles.length; i++) {
    Particle p = particles[i];
    p.r = r;
    p.g = g;
    p.b = b;
  }
}

void switchDrawing() {

  //waitCount = (int)random(10, 20);
  waitCount = 5;
  skipCount = (int)random(20, 40);
  lastFrameCount = frameCount;

  // clear and reset color
  clearBackground();
  changeColor();

  // plant
  plant.update();

  // silk
  silk.scale = 0.5;
  silk.blur = 5.0 + abs(mic.average) * 5.0;
  silk.createLines(SILK_LINE_COUNT);
}

void drawParticles() {

  float x  = random(width);
  float y  = random(height);
  float sw = random(width/2.0, width);
  float sh = random(height/2.0, height);
  for (int i = 0; i < particles.length; i++) {
    Particle p = particles[i];
    if (frameCount % 2 == 0) {
      p.update(x, y, sw, sh);
    }
    p.draw();
  }
}

void setInverted(boolean _inverted) {
  inverted = _inverted;
  changeColor();
}

void drawRipples() {
  for (int i = 0; i < ripples.length; i++) {
    Ripple rip = ripples[i];
    rip.draw(inverted);
  }
}

void drawSlashes() {

  for (int i = 0; i < slashes.length; i++) {
    Slash s = slashes[i];
    s.update();
    s.draw(inverted);
  }
}

//=================================
void mouseMoved() {
}

void keyPressed() {
  if(key == 'c') {
  }
}

void mousePressed() {
  switchDrawing();
}
