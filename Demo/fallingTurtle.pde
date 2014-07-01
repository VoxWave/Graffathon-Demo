class FallingTurtle {
  float x,y,vx,vy,rot,vrot;
  boolean remove;
  
  FallingTurtle (float x, float y, float vx, float vy, float rot, float vrot) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.rot = rot;
    this.vrot = vrot;
    remove = false;
  }
  
  void display() {
    pushMatrix();
    rotate(rot);
    shape(turtle, x, y, 0.6, 0.6);
    popMatrix();
  }
  
  void run() {
    display();
    x += vx;
    y += vy;
    rot += vrot;
    if (y < -1) {
      remove = true;
    }
  }
}
