class Ball {
  // GLOBAL VARIABLES
  float x;
  float y;
  float speedX = random(-0.01, 0.01);
  float speedY = 0.002;
  float aspectratio;
  float size;

  Ball(float _x, float _y, float _aspectratio, float _size) {
    x = _x;
    y = _y;
    aspectratio = _aspectratio;
    size = _size;
  } 

  void run() {
    display();
    move();
    bounce();
    gravity();
  }

  void display() {
    ellipse(x, y, size, size);
  }

  void move() {
    x += speedX;
    y += speedY;
  }

  void bounce() {
    if (x + size/2 >= aspectratio || x - size / 2 <= -aspectratio) {
      speedX = -speedX;
    }

    if (y - size / 2 <= -1) {
      speedY = Math.abs(speedY); 
      println(speedY);
    }
  }

  void gravity() {
    speedY -= 0.001;
  }

}

