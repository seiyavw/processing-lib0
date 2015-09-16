class WDPoint {
  float x, y;
  float r;
  float al;
  WDPoint (float _x, float _y, float _r, float _al) {
    x = _x;
    y = _y;
    r = _r;
    al = _al;
  }
}

class Wind {

  float ang = 0.0;
  float spd = 0.001;// change by step

  int pCount = 0;
  int step = 500;
  int pMax = 5000;

  float h, s, b;
  float a = 50;

  WDPoint[] points;
  int[] fpoints;

  Wind() {

  }
  void setHSBA(float _h, float _s, float _b , float _a) {
    h = _h;
    s = _s;
    b = _b;
    a = _a;
  }

  void update() {
    // reset values
    ang      = random(PI);
    pCount   = 0;
    points   = new WDPoint[pMax];

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
      float al = map(sin(ang*1.3) * sin(ang*4.1), -1, 1, 20, a);
      WDPoint p = new WDPoint(x, y, r, al);
      points[i] = p;
      ang += spd;
    }
  }

  void draw() {
    noStroke();
    int incre = (pMax - pCount < step) ? pMax - pCount : step;
    pCount += incre;
    for (int i = 0; i < pCount; i++) {
      WDPoint p = points[i];
      fill(h, s, b, p.al);
      ellipse(p.x, p.y, p.r, p.r);
    }
  }
}

