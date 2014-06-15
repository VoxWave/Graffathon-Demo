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

// All these you can (must) change!
// These control how big the opened window is.
// Before you release your demo, set these to 
// full HD resolution (1920x1080).
int CANVAS_WIDTH = 1024;
int CANVAS_HEIGHT = 576;

// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;

// Don't change this – needed for resolution independent rendering
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;

// Needed for audio
Minim minim;
AudioPlayer song;

PShape turtle;
ArrayList<FallingTurtle> turtles;
WavyText wt;

/*
 * Sets up audio playing: call this last in setup()
 * so that the song doesn't start to play too early.
 *
 * By default, playback doesn't start automatically –
 * you must press spacebar to start it.
 */
void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("../common/tekno_127bpm.mp3");
  // Uncomment this if you want the demo to start instantly
  song.play();
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

  // Drawing options that don't change, modify as you wish
  frameRate(60);
  noStroke();
  fill(255);
  smooth();

  turtle = loadShape("../common/turtle_animal_lemmling.svg");
  turtles = new ArrayList<FallingTurtle>();
  wt = new WavyText();

  setupAudio();
}

/*
 * Your drawing code ends up in here!
 *
 */
void drawDemo(int time) {
  // TODO: implement some example drawing
  // and time-based sync done in code

    // Draw centered unit circle
  //ellipse(0., 0., 1.0, 1.0);

  // The following lines draw a full-screen quad.
  // Params for rect: x, y, width, height
  // rect(-ASPECT_RATIO, -1, 2*ASPECT_RATIO, 2);
  
  sky(color(0, 0, 255), color(0));
  bg();
  road();
  turtles();
  pushMatrix();
  resetMatrix();
  text("UnkownPotato",map(0,-ASPECT_RATIO,ASPECT_RATIO,0,CANVAS_WIDTH),map(0,-1,1,0,CANVAS_HEIGHT));
  popMatrix();
  if (frameCount % 60 == 0) {
    wt.displayText("unkown potato", -0.63, -0.33);
  }
  wt.run();
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
  resetMatrix();

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
  drawDemo(song.position());
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

  for (float i = 1; i >= bottom; i -= 0.1) {
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
    turtles.add(new FallingTurtle(random(-ASPECT_RATIO, ASPECT_RATIO), 0.9, random(-0.1, 0.1), random(-0.1,0), random(0, 2*PI), random(-0.1, 0.1)));
    //println("a");
  }
  
  for (FallingTurtle ft : turtles) {
    ft.run();
    //println(ft.x + "," + ft.y);
  }
  if (turtles.size() > 50) {
    turtles.remove(0);
  }
}
