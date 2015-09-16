class Ripples {
  Ripple[] items;
  int rippleCount = 0;
  Ripples(int num) {
    items = new Ripple[num];
    for (int i = 0; i < num; i++) {
      Ripple rip = new Ripple();
      items[i] = rip;
    }

  }
  void update() {
    if (rippleCount > items.length - 1) {
      rippleCount = 0;
    }
    Ripple rip = items[rippleCount];
    rip.update(random(width), random(height), random(height/3.0, height));
    rippleCount++;
  }
  void draw(boolean inverted) {
    for (int i = 0; i < items.length; i++) {
      Ripple rip = items[i];
      rip.draw(inverted);
    }
  }

}
class Ripple {
  float x, y, sz, goal;
  float spd = 5.0;
  float friction = 0.985;
  float a;
  boolean enabled = false;
  void update(float _x, float _y, float _goal) {
    x   = _x;
    y   = _y;
    goal = _goal;
    sz = goal * 0.1;
    spd = goal * 0.01;
    a = 0.0;
    enabled = true;
  }

  void draw(boolean inverted) {
    if (!enabled || sz > goal) {
      enabled = false;
      return;
    }
    float in  = goal * 0.1 + 5.0;
    float out = in + goal * 0.1;
    float maxAlpha = (inverted) ? 10 : 35;
    if (sz < in) {
      a = map(sz, 5.0, in, 0, maxAlpha);
    } else if (sz > out) {
      a = map(sz, out, goal, maxAlpha, 0);
    }
    float v = spd * friction;
    sz += v;
    noFill();
    if (inverted) {
      stroke(0, 0, 0, a);
    } else {
      stroke(0, 0, 100, a);
    }
    strokeWeight(1);
    ellipse(x, y, sz, sz);
    float r1 = sz + pow(v,2.1);
    strokeWeight(2);
    ellipse(x, y, r1, r1);
    float r2 = sz + pow(v,2.5);
    strokeWeight(3);
    ellipse(x, y, r2, r2);
  }
}

