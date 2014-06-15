class Letter {
  char c;
  float x, y, ymin, ymax;

  Letter(char c, float ymin, float ymax) {
    x = ASPECT_RATIO;
    y = 0;
    this.c = c;
    this.ymin = ymin;
    this.ymax = ymax;
  }

  void display() {
    pushMatrix();
    resetMatrix();
    text(c, map(x, -ASPECT_RATIO, ASPECT_RATIO, 0, CANVAS_WIDTH), map(y, -1, 1, 0, CANVAS_HEIGHT));
    popMatrix();
  }

  void run() {
    x -= 0.01;
    y = -map(sin(x*10), -1, 1, ymin, ymax);
    //println(x + "," + y + " ymin: " + ymin);
    display();
  }
}

class WavyText {
  ArrayList<Letter> letters, emitted;
  boolean remove;

  WavyText() {
    letters = new ArrayList<Letter>();
    emitted = new ArrayList<Letter>();
    remove = false;
  }

  void displayText(String text, float ymin, float ymax) {
    for (int i = 0; i < text.length(); i++) {
      letters.add(new Letter(text.charAt(i), ymin, ymax));
      println("adding letter");
    }
  }
  
  void emitNext(){
    if (!letters.isEmpty()){
    emitted.add(letters.remove(0));
    }
  }

  void run() {
    if (frameCount % 3 == 0) {
      emitNext();
    }
    
    for (Letter l : emitted) {
      l.run();
      if (l.x < -ASPECT_RATIO) {
        remove = true;
      }
    }
    if (remove) {
      emitted.remove(0);
      remove = false;
    }
  }
}

