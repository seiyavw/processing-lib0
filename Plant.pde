class PLPoint {
  float x, y;
  float r;
  float al;
  PLPoint (float _x, float _y, float _r, float _al) {
    x = _x;
    y = _y;
    r = _r;
    al = _al;
  }
}

class Plant {

  float ang = 0.0;
  float spd = 0.001;// change by step

  int pCount = 0;
  int step = 500;  // TODO:random
  int pMax = 5000; // TODO:random

  float r, g, b;

  PLPoint[] points;
  int[] fpoints;

  Plant() {

  }

  void update() {
    // reset values
    ang      = random(PI);
    pCount   = 0;
    points   = new PLPoint[pMax];

    // random flower point
    int fNum = (int)random(1, 5);
    int sec = fNum + 1;
    fpoints  = new int[fNum];
    int itv  = pMax/sec;
    for (int i = 0; i < fNum; i++) {
      int index = itv * (i + 1) + (int)(random(itv) - (itv / 2.0));
      fpoints[i] = index;
    }

    float randX = random(0.5, 3.0);
    float randY = random(0.5, 3.0);

    // create points
    for (int i = 0; i < pMax; i++) {
      float x = map(sin(ang) * sin(ang*randX), -1, 1, 0, width);
      float y = map(sin(ang*1.1+1.5) * sin(ang*randY), -1, 1, 0, height);
      float r = map(sin(ang*1.7) * sin(ang*2.3), -1, 1, 1, 3);
      float al = map(sin(ang*1.3) * sin(ang*4.1), -1, 1, 10, 60);
      PLPoint p = new PLPoint(x, y, r, al);
      points[i] = p;
      ang += spd;
    }
  }

  void draw() {
    noStroke();
    int incre = (pMax - pCount < step) ? pMax - pCount : step;
    pCount += incre;
    for (int i = 0; i < pCount; i++) {
      PLPoint p = points[i];
      fill(r, g, b, p.al);
      ellipse(p.x, p.y, p.r, p.r);
    }
  }
}

