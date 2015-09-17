final int SILK_NORMAL = 0;
final int SILK_EDGE   = 1;
final int SILK_OUTLINED = 2;

// class
class Line {
  float x1,y1,x2,y2;
  float sx1,sy1,sx2,sy2;
  Line(float _x1, float _y1, float _x2, float _y2) {
    x1  = _x1;
    y1  = _y1;
    x2  = _x2;
    y2  = _y2;
    sx1 = random(10);
    sy1 = random(10);
    sx2 = random(10);
    sy2 = random(10);
  }
}

class Silk {
  //int type = SILK_NORMAL;
  int type = SILK_EDGE;
  float aNoise, rNoise, xNoise, yNoise;
  float ang = -PI/2;
  float rad = 100;
  float baseRadius, cx, cy;
  float ex1, ex2, ey1, ey2;
  int lineCount = 0;

  float h, s, b, a;
  float scale = 0.5;

  float blur = 1.0;
  float centerStep  = 50;
  float outlineStep = 1.0;
  boolean noiseEnabled = false;

  Line[] lines;

  Silk (float _baseRadius, float centerX, float centerY) {

    baseRadius  = _baseRadius;
    cx           = centerX;
    cy           = centerY;

    lineCount = 0;
    rad    = 100;
    aNoise = random(10);
    rNoise = random(10);
    xNoise = random(10);
    yNoise = random(10);
  }

  void createLines(int count) {

    lineCount = 0;
    lines = new Line[count];

    float m1 = centerStep * blur;
    float m2 = m1/2.0;

    for (int i = 0; i < count; i++) {
      rNoise += 0.005;
      rad = (noise(rNoise) * baseRadius) +1;

      aNoise += 0.001;
      ang += (noise(aNoise) * 6) - 3;
      if (ang > 360) {
        ang -= 360;
      }
      if (ang < 0) {
        ang += 360;
      }

      xNoise += 0.01;
      yNoise += 0.01;

      float centerX = cx + (noise(xNoise) * m1) - m2;
      float centerY = cy + (noise(yNoise) * m1) - m2;

      float rad2     = radians(ang);
      float x1      = centerX + (rad * cos(rad2));
      float y1      = centerY + (rad * sin(rad2));

      float opprad  = rad2 + PI;
      float x2      = centerX + (rad * cos(opprad));
      float y2      = centerY + (rad * sin(opprad));

      Line l = new Line(x1,y1,x2,y2);

      lines[i] = l;
    }

    // for edge type
    ex1 = random(width);
    ex2 = random(width);
    ey1 = random(height);
    ey2 = random(height);
  }

  void next() {
    lineCount++;
    if (lineCount > lines.length - 1) {
      lineCount = 0;
    }
  }

  void _draw() {
    float sc = abs(scale);
    float m1 = outlineStep;
    float m2 = outlineStep/2.0;
    for (int i = 0; i < lineCount; i++) {

      Line l = lines[i];
      l.sx1 += 0.01;
      l.sy1 += 0.01;
      l.sx2 += 0.01;
      l.sy2 += 0.01;

      l.x1 += (noise(l.sx1) * m1 - m2);
      l.y1 += (noise(l.sy1) * m1 - m2);
      l.x2 -= (noise(l.sx2) * m1 - m2);
      l.y2 -= (noise(l.sy2) * m1 - m2);

      PVector v1 = new PVector(l.x1 - cx, l.y1 - cy);
      PVector v2 = new PVector(l.x2 - cx, l.y2 - cy);
      v1.mult(sc);
      v2.mult(sc);
      float x1 = v1.x + cx;
      float y1 = v1.y + cy;
      float x2 = v2.x + cx;
      float y2 = v2.y + cy;
      switch (type) {
        case SILK_NORMAL:
          line(x1, y1, x2, y2);
          break;
        case SILK_EDGE:
          line(x1, y1, x2, y2);
          line(x1, y1, ex1, 0);
          line(x1, y1, width, ey1);
          line(x2, y2, ex2, height);
          line(x2, y2, 0, ey2);
          break;
        case SILK_OUTLINED:
          line(x1, y1, x2, y2);
          break;
        default:
          break;
      }
    }
  }

  void randomPosition() {
    float _baseRadius = random(height * 0.65, width * 0.8);
    baseRadius = _baseRadius;
    cx = random(baseRadius/2.0, width - baseRadius/2.0);
    cy = random(baseRadius/2.0, height - baseRadius/2.0);
  }

  void setHSBA(float _h, float _s, float _b , float _a) {
    h = _h;
    s = _s;
    b = _b;
    a = _a;
  }

  void draw() {
    stroke(h, s, b, a);
    strokeWeight(1);
    _draw();
  }

  void drawNoisy() {
    stroke(h - 180, s, b, 10);
    float tx1 = random(20) - 10;
    float ty1 = random(20) - 10;
    float tx2 = random(20) - 10;
    float ty2 = random(20) - 10;
    pushMatrix();
    translate(tx1, ty1);
    _draw();
    popMatrix();
    pushMatrix();
    translate(tx2, ty2);
    _draw();
    popMatrix();
  }
}
