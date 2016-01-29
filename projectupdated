/**
 * MusicBall
 * by Shabbar Raza and Mariia Gladkova
 * 
 * Practical project for USC - Sound and Images in the Visual Arts, Science, and Technology - Processing Audiovisuality (Intersession)
 * Ball class defines a single ball in the coordinate plane with its x and y coordinates
 * Ball drops to the bottom of the window and envokes a sound
 * After collision the ball bounces and is not able to jump higher than its initial state because of physical parameters involved such as speed and acceleration
 * All balls can be envoked by user input from keyboard
 * Assignment starts with the first row and leftmost letter 'q', ends with 'm', and involves only keys with letters 
 * Game includes two modes: in the 1st pitch depends on the ball (leftmost assigned to the lowest frequency, rightmost - the highest)
 * In the 2nd mode pitches depend on the starting state of the ball: the lower the y-coordinate the higher the pitch
 * There is a possibility to increase acceleration and reset the states of all balls and continue playing
 **/

import ddf.minim.*;
import ddf.minim.ugens.*;
PFont f;
class Ball{
  float ballX;
  float ballY; // keeps track of the current Y
  float prevY; // keeps track of the initial y-coordinate before stop
  float ballSpeed;
  int ballSize;
  char ballKeyCode;
  boolean moving;
  
  Ball(){
    ballX = 0;
    ballY = 0;
    ballSpeed = 0;
    ballSize = 20;
    moving = false;
    ballKeyCode = 'q';
    prevY = 0;
  }
  
 
  
  void setX(float x){
    ballX = x;
  }
  
  float getX(){
    return ballX;
  }
  
  void setY(float y){
    ballY = y;
  }
  
  float getY(){
    return ballY;
  }
  
  void setSize(int size){
    ballSize = size;
  }
  
  int getSize(){
    return ballSize;
  }
  
  void setSpeed(float speed){
    ballSpeed = speed;
  }
  
  float getSpeed(){
    return ballSpeed;
  }
  
  void setMoving(boolean isIn){
    moving = isIn;
  }
  
  boolean getMoving(){
    return moving;
  }
  
  char getKey(){
    return ballKeyCode;
  }
  
  void setKey(char code){
    ballKeyCode = code;
  }
  
  float getprevY(){
    return prevY;
  }
  
  void setprevY(float curr){
    prevY = curr;
  }
}

// initialization for audio output and Instrument creation
Minim minim = new Minim(this);
AudioOutput out = minim.getLineOut();


// making an Instrument
class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    //a sine wave oscillator
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  // this is called by the sequencer when this instrument
  // should start making sound. the duration is expressed in seconds.
  void noteOn( float duration )
  {
    // start the amplitude envelope
    ampEnv.activate( duration, 0.5f, 0 );
    // attach the oscil to the output so it makes sound
    wave.patch( out );
  }
  
  // this is called by the sequencer when the instrument should
  // stop making sound
  void noteOff()
  {
    wave.unpatch( out );
  }
}

// all the balls on the screen stored in an array
ArrayList<Ball> balls = new ArrayList<Ball>();
// represents the keyboard layout from the upper-left corner to the lower-right one
char[] buttons = {'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'};

// initial screen mode
int gameScreen = 0;
// initial acceleration value
float gravity = 0.1;
// keeps track of the current playmode in case of resets
int prevScreen = 0;

ArrayList<ParticleSystem> pses = new ArrayList<ParticleSystem>();
 
void setup(){
  //3D layout for the initial and last screen modes 
  size(800,500, P3D);
  //text formatting
  f = createFont("Arial", 32);
  //initialization of the balls
  for (int i = 0; i < 26; i++){
    Ball ball = new Ball();
    ball.setSize(20);
    // in case of different size of window the position of balls is adjusted
    // formula is created according to the existing 26 balls, taking offset of 40
    int x = (width - 40)/26; 
    int border = (width - 26 * x) /2;  
    ball.setX(border + x*i);
    ball.setY(20);
    ball.setprevY(20);
    ball.setKey(buttons[i]);
    balls.add(ball);
    
    pses.add(new ParticleSystem(new PVector(border + x*i,height-15)));
  }
    
}

void draw(){
  if (gameScreen == 0){
    initScreen();
  } else if (gameScreen == 1 || gameScreen == 2){ // gameScreens in both playmodes
    gameScreen();
  } else if (gameScreen == 4){ // reseting the current state of the balls, mode choice is kept
    gameReloadScreen();
  } else if (gameScreen == 3){
    byeScreen();
  }
}

void initScreen(){
  background(255);
  textFont(f,40);
  fill(0);
  text("Welcome to the MusicBall game!", width*0.1, height*0.3); 
  textFont(f,20);
  text("Press 1 to play PitchBall, 2 to play PitchHeight and 3 to come later!", width*0.1, height*0.95); 
  // puts the sphere on the separate layer
  pushMatrix();
  translate(300, height*0.45, -200);
  rotateY(1.25);
  rotateX(-0.4);
  stroke(0);
  noFill();
  sphere(280);
  popMatrix();
}

// game-mode screens with guidance
void gameScreen(){
  background(0);
  textFont(f,30);
  fill(255);
  if (gameScreen == 1){
     text("PitchBall", width*0.05, height*0.1);
     textFont(f,13);
     text("Press the key on your keyboard to move/stop a ball", width*0.05, height*0.15);
     text("Each ball has its own pitch: left - low and right - high", width*0.05, height*0.2);
     
  } else if (gameScreen == 2){
     text("PitchHeight", width*0.05, height*0.1);
     textFont(f,13);
     text("Press the key on your keyboard to move/stop a ball", width*0.05, height*0.15);
     text("The higher the ball starts its move the lower the pitch", width*0.05, height*0.2);
  }
  
  text("Balls' accelaration " + gravity, width*0.7, height*0.05);
  text("Press arrow keys to speed UP/DOWN", width*0.7, height*0.1);
  text("Press BACKSPACE to reset", width*0.7, height*0.15);
  text("Press 3 to exit the game", width*0.7, height*0.2);
  noFill();
  
  drawBalls();
  applyGravity();
  keepInScreen();
}


void byeScreen(){
  background(0);
  textFont(f,40);
  fill(255);
  text("See you later!", width*0.1, height*0.4); 
  pushMatrix();
  translate(600, height*0.65, -200);
  noFill();
  stroke(255);
  rotateY(1.25);
  rotateX(-0.4);
  sphere(180);
  popMatrix();
  // doesn't let user return to the game, forces to close the window
  if (keyPressed || mousePressed){
    super.stop();
  }
}

// resets the states of all the balls
void gameReloadScreen(){
  background(0);
  for (int i = 0; i < balls.size(); i++){
    balls.get(i).setY(height/5);
    balls.get(i).setSpeed(0);
    balls.get(i).setMoving(false);
  }
  gravity = 0.1;
  // the game mode is kept
  if (prevScreen != 0)
    gameScreen = prevScreen;
}

// draws all the balls in their positions
void drawBalls(){
  for (int i = 0; i < balls.size(); i++){
    stroke(255);
    if (balls.get(i).getMoving()){
      // adapts the color of the moving ball in grid scale (the initial y-coordinate is considered)
      // 15 is the height of the bottom bars
      float c = map(balls.get(i).getY(),balls.get(i).getprevY(), height - 15, 255,0);
      fill(c);
    }
    ellipse(balls.get(i).getX(),balls.get(i).getY(), balls.get(i).getSize(), balls.get(i).getSize());
    noFill();
    // drawing a string whenever the ball hangs
    // the formula is calculated according to initial position of center of a ball
    if (balls.get(i).getY() > (height - 100)/4 + 35){
      stroke(255);
      line(balls.get(i).getX(), (height - 100)/4 + 35, balls.get(i).getX(),balls.get(i).getY() - 10);
    }
  }
  drawBars();
}

//draws the bars on the bottom of the window
void drawBars(){
  for (int i = 0; i < balls.size(); i++){
    // formula is created by taking an offset of 40 and # of balls - 26
    rect(balls.get(i).getX() - 15, height - 15, (width - 40)/26, 15);
  }
}

// applying the gravitational force on the balls updates the velocity and y-coordinate
void applyGravity(){
  for (int i = 0; i < balls.size(); i++) {
    if (balls.get(i).getMoving()){
      // adjust the speed and y-coordinate of each ball
      balls.get(i).setSpeed(balls.get(i).getSpeed() + gravity);
      balls.get(i).setY(balls.get(i).getY() + balls.get(i).getSpeed());
    }
  }
}

// whenever the bottom is reached makes the ball bounce
void bounceBottom(int surface, Ball ball){
  ball.setY (surface - (ball.getSize()/2));
  // changes the velocity vector to the opposite direction
  ball.setSpeed(ball.getSpeed() * -1);
  // plays a note for each hit of the bottom mapping every ball to the range [250,2000] Hz
  if (gameScreen == 1){
    // if the game mode is 1
    out.playNote(0.0, 0.3, new SineInstrument(map(balls.indexOf(ball), 0, balls.size() - 1, 250, 2000)));
  } else if (gameScreen == 2){
    // if the game mode is 2
    out.playNote(0.0, 0.3, new SineInstrument(map(ball.getprevY(), height/5, height, 1000, 60)));
  }
  
  // makes a red blink of the rectangle when is hit
  fill(255,0,0);
  rect(ball.getX() - 15, height - 15, (width-40)/26, 15);
  noFill();
 
}

// whenever the top threshold is reached makes the ball move down
void bounceTop(int surface, Ball ball){
  // adjusting y-coordinate and speed of the ball
  ball.setY(surface + ball.getSize()/2);
  ball.setSpeed(ball.getSpeed() * -1);
}

// assures that the ball doesn't go beyond the screen/specified top
void keepInScreen(){
  for (int i = 0; i < balls.size(); i++){
    
      //partcls();

      // bounces whenever a brick is reached (15 height of the brick)
      if (balls.get(i).getY() + (balls.get(i).getSize()/2) > (height - 15)){
        
           pses.get(i).addParticles();
           pses.get(i).run();
           
           bounceBottom((height - 15), balls.get(i));
      }
      
      // falls down when the top is reached
      if (balls.get(i).getY() - (balls.get(i).getSize()/2) < height/4){
          bounceTop(height/4,balls.get(i));
      }
      
      //deals with the life of particles where they still exist
      if((pses.get(i)).particles.size() != 0){
          pses.get(i).run();
      }
      
      
         
  }
}

// makes a certain ball move/freeze 
public void keyPressed(){
  if (keyCode == 8){ // reset mode
    prevScreen = gameScreen;
    gameScreen = 4;
  } else if (key == '1'){ // game mode 1
    gameScreen = 1;
    // in case of changing modes while one is on, automatically reload the screen
    gameReloadScreen();  
    //mode1 = true;
  } else if (key == '2'){ // game mode 2
    gameScreen = 2;
    // in case of changing modes while two is on, automatically reload the screen
    gameReloadScreen();
    //mode1 = false;
  } else if (key == '3'){ // quit mode
    gameScreen = 3;
  }else if (key >= 'a' && key <= 'z'){ // keyboard input
    movingRoutine(key);
  } else if (keyCode == 38){ // UP for acceleration
    if (gravity >= 0.5){
       gravity = 0.1;
    } else 
       gravity += 0.1;
  } else if (keyCode == 40){ // DOWN for deceleration
    if (gravity <= 0){
      gravity = 0.1;
    } else { 
      gravity -= 0.1;
    }
  }
}

// makes the ball freeze if it was previously moving and vice versa
void movingRoutine(char code){
  int keyC = -1;
  // finds the ball which key was received
  for (int i = 0; i < balls.size(); i++){
    if (balls.get(i).getKey() == code){
      keyC = i;
      break;
    }
  }
  
  try{
    // ball was moving -> freeze
    if (balls.get(keyC).getMoving()){
        balls.get(keyC).setMoving(false);
        balls.get(keyC).setSpeed(0);
      } else {
        // ball was not moving -> envoke
        balls.get(keyC).setprevY(balls.get(keyC).getY());
        balls.get(keyC).setMoving(true);
      }
  } catch (IndexOutOfBoundsException e){ // in case of index out of bounds
    println("Error occured");
    exit();
  } 
}


 // A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
    

}

  void addParticles() {
        for (int i = 20; i >= 0; i--) {   
         particles.add(new Particle(origin));
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}



// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-0.5,0.5),random(-2.5,0));
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255,lifespan);
    fill(255,lifespan);
    ellipse(location.x,location.y,2,2);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
