class Slashes {
  Slash[] items;
  Slashes(int num) {
    items = new Slash[num];
    for (int i = 0; i < num; i++) {
      Slash s = new Slash();
      s.update();
      items[i] = s;
    }
  }
  void update() {
    for (int i = 0; i < items.length; i++) {
      Slash s = items[i];
      s.update();
    }
  }

  void draw(boolean inverted) {
    for (int i = 0; i < items.length; i++) {
      Slash s = items[i];
      s.update();
      s.draw(inverted);
    }
  }
}

// class
class Slash {

  float h, s, b = 0.0;
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
      stroke(0, 0, 80, 25);
    }
    strokeWeight(10);
    line(x1, y1, x2, y2);
  }
}

