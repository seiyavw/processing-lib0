class Particle {

  float px, py;
  float sc;
  float r, g, b, a;

  Particle () {
    px = random (width);
    py = random (height);
    sc = 1;
  }

  void update (float x, float y, float sw, float sh) {
    px = x + sw/2.0 - random(sw);
    py = y + sh/2.0 - random(sh);
    a = random(20, 40);
  }

  void draw () {
    noStroke();
    fill(r, g, b, a);
    //ellipseMode (CENTER);
    //ellipse (px, py, 8 * sc, 8 * sc);
    rect(px, py, sc * 2, random(10, 50));
  }
}
