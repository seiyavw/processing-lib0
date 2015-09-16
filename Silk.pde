enum SilkType {
  SILK_NORMAL, SILK_FOCUSED, SILK_OUTLINED
}

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

  SilkType type = SILK_NORMAL;
  float aNoise, rNoise, xNoise, yNoise;
  float ang = -PI/2;
  float rad = 100;
  float baseRadius, cx, cy;
  int lineCount = 0;

  float r, g, b;
  float scale = 0.5;

  float blur = 1.0;
  float centerStep  = 50;
  float outlineStep = 1.0;

  Line[] lines;

  Silk (float _baseRadius, float centerX, float centerY) {

    baseRadius  = _baseRadius;
    cx           = centerX;
    cy           = centerY;

    lineCount   = 0;
    rad      = 100;
    aNoise    = random(10);
    rNoise = random(10);
    xNoise      = random(10);
    yNoise      = random(10);
  }

  void createLines(int count) {

    lines = new Line[count];

    float m1 = centerStep * blur;
    float m2 = m1/2.0;

    for (int i = 0; i < count; i++) {
      rNoise += 0.005;
      rad = (noise(rNoise) * baseRadius) +1;

      aNoise += 0.001;
      ang += (noise(aNoise) * 6) - 3;
      //if (ang > 360) { ang -= 360; }
      //if (ang < 0) { ang += 360; }
      if (ang > 180) { ang -= 180; }
      if (ang < 0) { ang += 180; }

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
  }

  void next() {
    stroke(r, g, b, 50);
    strokeWeight(1);
    Line l = lines[lineCount];

    lineCount++;
    if (lineCount > lines.length - 1) {
      lineCount = 0;
    }
  }

  void back() {
    stroke(r, g, b, 50);
    strokeWeight(1);
    Line l = lines[lineCount];

    lineCount--;
    if (lineCount < 0) {
      lineCount = lines.length - 1;
    }
  }

  void draw() {
    stroke(r, g, b, 50);
    strokeWeight(1);
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
          break;
        case SILK_FOCUSED:
          ellipse(x1,y1,10,10);
          ellipse(x2,y2,10,10);
          break;
        case SILK_OUTLINED:
          break;
        default:
          break;
      }
      line(x1, y1, x2, y2);
    }
  }
}
