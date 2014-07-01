
/* 
 * A simple example of how to use
 * Processing as a demo platform.
 * 
 * Features:
 *  - Setup for rendering resolution-independent
 *    2D graphics
 *  - Music playback with Minim
 *  - Simple play/pause/seek-functionality
 */

// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import moonlander.library.*;

// All these you can (must) change!
// These control how big the opened window is.
// Before you release your demo, set these to 
// full HD resolution (1920x1080).
//int CANVAS_WIDTH = 1280;
//int CANVAS_HEIGHT = 720;
int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1080;

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

// Don't change this – needed for resolution independent rendering
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;

// Needed for audio
Minim minim;
AudioPlayer song;
Moonlander moonlander;

ArrayList<Ball> balls;
float ellipseSize = 0;

PFont ps2p;
PShape turtle;
ArrayList<FallingTurtle> turtles, remove;
WavyText wt;
boolean greezShowed;
/*
 * Sets up audio playing: call this last in setup()
 * so that the song doesn't start to play too early.
 *
 * By default, playback doesn't start automatically –
 * you must press spacebar to start it.
 */
void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("../common/Graffathon.mp3");
  // Uncomment this if you want the demo to start instantly
  // song.play();
}

/*
 * Processing's setup method.
 *
 * Do all your one-time setup routines in here.
 */
void setup() {
  // Set up the drawing area size and renderer (usually P2D or P3D,
  // respectively for accelerated 2D/3D graphics).
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);

  moonlander = Moonlander.initWithSoundtrack(this, "../common/Graffathon.mp3", 150, 8);

  // Drawing options that don't change, modify as you wish
  frameRate(60);
  noStroke();
  fill(255);
  smooth();

  balls = new ArrayList<Ball>();

  ps2p = loadFont("../common/PressStart2P-Regular-48.vlw");
  //Source: https://www.google.com/fonts/specimen/Press+Start+2P
  textFont(ps2p, 32);
  turtle = loadShape("../common/turtle_animal_lemmling.svg");
  //Source: http://clipartist.net/links/clipartist.net/turtle_animal_lemmling.svg
  turtles = new ArrayList<FallingTurtle>();
  remove = new ArrayList<FallingTurtle>();
  wt = new WavyText();

  setupAudio();
  moonlander.start();
}

/*
 * Your drawing code ends up in here!
 *
 */
void drawDemo(int time) {
  if (time < 39000) {
    ballsScene(time);
  } else {
    roadScene(time);
  }
}

void ballsScene(int time) {

  pushMatrix();
  resetMatrix();
  text("Univaje", map(0, -ASPECT_RATIO, ASPECT_RATIO, 0, CANVAS_WIDTH), map(0, -1, 1, 0, CANVAS_HEIGHT));
  popMatrix();

  int red = moonlander.getIntValue("red");
  int green = moonlander.getIntValue("green");
  int blue = moonlander.getIntValue("blue");

  ellipseMode(CENTER);

  fill(red, green, blue);
  balls.add(new Ball(random(-ASPECT_RATIO, ASPECT_RATIO), random(0, 1), ASPECT_RATIO, 0.1));
  for (Ball ball : balls) {
    ball.run();
  }
  if (balls.size() >= 1000) {
    balls.remove(0);
  }

  if (time > 35000) {
    ellipseSize += 0.05;
    ellipse(0, 0, ellipseSize * ASPECT_RATIO, ellipseSize);
  }
}

void roadScene(int time) {
  sky(color(0, 0, 255), color(0));
  bg();
  road();
  turtles();
  pushMatrix();
  resetMatrix();
  text("UnknownPotato", map(-ASPECT_RATIO, -ASPECT_RATIO, ASPECT_RATIO, 0, CANVAS_WIDTH), map(0.9, -1, 1, CANVAS_HEIGHT, 0));
  text("Music and sync: VoxWave", map(-ASPECT_RATIO, -ASPECT_RATIO, ASPECT_RATIO, 0, CANVAS_WIDTH), map(0, -1, 1, CANVAS_HEIGHT, 0));
  text("Code: Serdion, a544jh", map(-ASPECT_RATIO, -ASPECT_RATIO, ASPECT_RATIO, 0, CANVAS_WIDTH), map(-0.1, -1, 1, CANVAS_HEIGHT, 0));
  popMatrix();
  
  if (!greezShowed) {
    wt.displayText("UnknownPotato would like to greet these people and groups in random order: BJAKKE  LAKO  DOT  firebug  sooda  Ihan sama, joo  msqrt  Future Crew  ASD  Kewlers  Bisqwit  lft  Delma  Letixari  EKK", -0.60, -0.39);
    greezShowed = true;
  }
  wt.run();
}

void road() {
  float spacing = 0.03;
  float width = 0.10;
  float height = 0.03;
  float ypos = -0.5;
  float t = 0.0017 * millis();
  float offset = (2 * (width + spacing) / PI) * atan(1 / tan(t * PI))  + 2 * (width + spacing);

  pushMatrix();
  translate(-ASPECT_RATIO - offset, 0);
  //println(offset);

  fill(255);
  for (int i=1; i < 31; i++) {
    rect(width * i + spacing * i, ypos, width, height);
  }
  popMatrix();
}

void sky(color c1, color c2) {
  float bottom = 0;

  for (float i = 1; i >= bottom; i -= 0.01) {
    stroke(lerpColor(c1, c2, norm(i, 1, bottom)));
    line(-ASPECT_RATIO, i, ASPECT_RATIO, i);
    //println(i);
  }
}

void bg() {
  noStroke();
  fill(86, 173, 35);
  rect(-ASPECT_RATIO, 0, 2*ASPECT_RATIO, -1);
  fill(151);
  rect(-ASPECT_RATIO, -0.33, 2*ASPECT_RATIO, -0.3);
}

void turtles() {
  if (millis() % 10 == 0 ) {
    turtles.add(new FallingTurtle(random(-ASPECT_RATIO, ASPECT_RATIO), 0.9, random(-0.1, 0.1), random(-0.1, 0), random(0, 2*PI), random(-0.1, 0.1)));
    //println("a");
  }

  for (FallingTurtle ft : turtles) {
    ft.run();
    //println(ft.x + "," + ft.y);
    if (ft.remove) {
      remove.add(ft);
    }
  }
  turtles.removeAll(remove);
  remove.clear();
}



/*
 * Draws coordinate axes (for reference).
 * You can remove this method if you don't 
 * need to see the axes.
 */
void drawAxes() {
  // Drawing options for axes
  stroke(255);
  strokeWeight(0.004);
  fill(255);

  // X-axis
  line(-ASPECT_RATIO, 0, ASPECT_RATIO, 0); 
  pushMatrix();
  resetMatrix();
  text(String.format("%.3f", -ASPECT_RATIO), 12, CANVAS_HEIGHT/2);
  text(String.format("%.3f", ASPECT_RATIO), CANVAS_WIDTH-42, CANVAS_HEIGHT/2);
  popMatrix();

  // Y-axis
  line(0, -1, 0, 1);
  pushMatrix();
  resetMatrix();
  text("1", CANVAS_WIDTH/2+12, 12);
  text("-1", CANVAS_WIDTH/2+12, CANVAS_HEIGHT - 12);
  popMatrix();
}

/*
 * Processing's drawing method – all
 * rendering should be done here!
 */
void draw() {
  // Reset all transformations.
  clear();
  resetMatrix();
  moonlander.update();

  // The following lines map coordinates so that we can
  // draw in a resolution independent coordinate system. 
  //
  // After this line coordinate axes are as follows:
  //   x: -ASPECT_RATIO ... ASPECT_RATION
  //   y: -1 ... 1  
  // Negative x is at left, y at bottom, origo at the center of 
  // the screen.
  // This is the coordinate system you're probably used to
  // already!
  translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);
  scale(CANVAS_WIDTH/2.0/ASPECT_RATIO, -CANVAS_HEIGHT/2.0);

  // Clear the screen after previous frame.
  // If you comment this line, you always draw on top the last frame,
  // which can lead to something interesting.
  clear();

  // Draw coordinate axes for reference.
  //drawAxes();
  // Draw demo at the current song position.
  drawDemo(millis());
}

void keyPressed() {
  if (key == CODED) {
    // Left/right arrow keys: seek song
    if (keyCode == LEFT) {
      song.skip(-SONG_SKIP_MILLISECONDS);
    } else if (keyCode == RIGHT) {
      song.skip(SONG_SKIP_MILLISECONDS);
    }
  }
  // Space bar: play/payse
  else if (key == ' ') {
    if (song.isPlaying())
      song.pause();
    else
      song.play();
  }
  // Enter: spit out the current position
  // (for syncing)
  else if (key == ENTER) {
    print(song.position() + ", ");
  }
}

