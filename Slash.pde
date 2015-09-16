
// class
class Slash {

  float r, g, b = 0.0;
  float x1,y1,x2,y2;

  void update() {
    float cx = width/2.0;
    float cy = height/2.0;
    float radius = width / 1.5;
    float a1 = random(PI * 2.0);
    x1 = cx + radius * cos(a1);
    y1 = cy + radius * sin(a1);
    float a2 = random(PI * 2.0);
    x2 = cx + radius * cos(a2);
    y2 = cy + radius * sin(a2);
  }

  void draw(boolean inverted) {
    if (inverted) {
      stroke(0, 0, 0, 10);
    } else {
      stroke(222, 222, 222, 30);
    }
    strokeWeight(4);
    line(x1, y1, x2, y2);
  }
}

