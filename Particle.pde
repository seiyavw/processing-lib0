class Particles {
  Particle[] items;
  Particles(int num) {
    items = new Particle[num];
    for (int i = 0; i < num; i++) {
      Particle p = new Particle();
      items[i] = p;
    }
  }
  void setHSBA(float h, float s, float b, float a) {
    for (int i = 0; i < items.length; i++) {
      Particle p = items[i];
      p.h = h;
      p.s = s;
      p.b = b;
      p.a = a;
    }
  }
  void draw(float x, float y, float sw, float sh) {
    for (int i = 0; i < items.length; i++) {
      Particle p = items[i];
      if (frameCount % 2 == 0) {
        p.update(x, y, sw, sh);
      }
      p.draw();
    }
  }
}
class Particle {

  float px, py;
  float sc;
  float h, s, b, a;

  Particle () {
    px = random (width);
    py = random (height);
    sc = 1;
  }

  void update (float x, float y, float sw, float sh) {
    px = x + sw/2.0 - random(sw);
    py = y + sh/2.0 - random(sh);
    a = random(a - 10, a + 10);
  }

  void draw () {
    noStroke();
    fill(h, s, b, a);
    rect(px, py, sc * 2, random(10, 50));
  }
}
