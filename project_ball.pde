import ddf.minim.*;
import ddf.minim.ugens.*;

/**
 * Ball class defines a single ball in the coordinate plane with its x and y coordinates
 * Ball drops to the bottom and envokes a sound, after collision the ball jumps 
 * All balls are assigned to user input from keyboard: first ball is connected to letter 'a', second - to 'b' and so on until letter 'z'
 * Balls can be stopped at any time of their movement, however due to conservation of energy after reenvoking, a ball won't jump higher than its original position (matter resistance is neglected)
 **/
// a class of balls jumping in the window
class Ball{
  float ballX;
  float ballY;
  int ballColor;
  float ballSpeed;
  int ballSize;
  int ballKeyCode;
  boolean moving;
  
  Ball(){
    ballX = 0;
    ballY = 0;
    ballColor = color(0);
    ballSpeed = 0;
    ballSize = 20;
    moving = false;
    ballKeyCode = 49;
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
  
  void setColor(int bcolor){
    ballColor = bcolor;
  }
  
  int getColor(){
    return ballColor;
  }
  
  void setMoving(boolean isIn){
    moving = isIn;
  }
  
  boolean getMoving(){
    return moving;
  }
  
  int getKey(){
    return ballKeyCode;
  }
  
  void setKey(int code){
    ballKeyCode = code;
  }
}

Minim minim = new Minim(this);
AudioOutput out = minim.getLineOut();


// to make an Instrument we must define a class
// that implements the Instrument interface.
class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // make a sine wave oscillator
    // the amplitude is zero because 
    // we are going to patch a Line to it anyway
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
String[] pitches = {"C3","D3","E3","F3","G3","A3","B3","C4","D4","E4","F4","G4","A4","B4","C5","D5","E5","F5","G5","A5","B5"};

// initial screen mode
int gameScreen = 0;
float gravity = 0.3;

void setup(){
  size(800,500, P3D);
  for (int i = 0; i < 26; i++){
    Ball ball = new Ball();
    ball.setX(20 + 30*i);
    ball.setY(20);
    ball.setColor(color(i * 5));
    ball.setSize(20);
    ball.setKey(49 + i);
    balls.add(ball);
  }
  
  drawBalls();
}

void draw(){
  if (gameScreen == 0){
    gameScreen();
  } else if (gameScreen == 1){
    gameReloadScreen();
  }
}

void gameScreen(){
  background(255);
  
  drawBalls();
  applyGravity();
  keepInScreen();
    
}

// returns the balls to their initial states 
void gameReloadScreen(){
  background(255);
  for (int i = 0; i < balls.size(); i++){
    balls.get(i).setY(height/5);
    balls.get(i).setSpeed(0);
    balls.get(i).setMoving(false);
  }
  gameScreen = 0;
}

// draws all the balls in the current positions
void drawBalls(){
  for (int i = 0; i < balls.size(); i++){
    ellipse(balls.get(i).getX(),balls.get(i).getY(), balls.get(i).getSize(), balls.get(i).getSize());
    //noFill();
    if (balls.get(i).getY() != 135)
      line(balls.get(i).getX(), 135, balls.get(i).getX(),balls.get(i).getY() - 10);
    
    /*if (i == 0){
      translate(40,20,0);
    } else {
      translate(40,0,0);
    }
     
    noFill();
    stroke(0);
    sphere(balls.get(i).getSize());*/
  }
  
  drawBars();
}

void drawBars(){
  for (int i = 0; i < balls.size(); i++){
    rect(balls.get(i).getX() - 15, height - 10, 30, 10);
  }
}

// applying the gravitational force on the balls updates the velocity and y-coordinate
void applyGravity(){
  for (int i = 0; i < balls.size(); i++) {
    if (balls.get(i).getMoving()){
      balls.get(i).setSpeed(balls.get(i).getSpeed() + gravity);
      balls.get(i).setY(balls.get(i).getY() + balls.get(i).getSpeed());
    }
  }
}

// whenever the bottom is reached makes the ball move up 
void bounceBottom(int surface, Ball ball){
  colorOn = true;
  ball.setY (surface - (ball.getSize()/2));
  ball.setSpeed(ball.getSpeed() * -1);
  out.playNote(0.0, 0.3, new SineInstrument( Frequency.ofPitch( pitches[(int)map(ball.getKey() - 49, 0, balls.size(), 0, pitches.length - 1)]).asHz() ) );
}

// whenever the top threshold is reached makes the ball move down
void bounceTop(int surface, Ball ball){
  ball.setY(surface + ball.getSize()/2);
  ball.setSpeed(ball.getSpeed() * -1);
}

// assures that the ball doesn't go beyond the screen/specified top
void keepInScreen(){
  for (int i = 0; i < balls.size(); i++){
      if (balls.get(i).getY() + (balls.get(i).getSize()/2) > height){
           bounceBottom(height, balls.get(i));
      }
      
      if (balls.get(i).getY() - (balls.get(i).getSize()/2) < height/4){
          bounceTop(height/4,balls.get(i));
      }
         
  }
}

// makes a certain ball move/freeze 
public void keyPressed(){
  if (keyCode == 8){
    gameScreen = 1;
  } else if (keyCode > 64 && keyCode < 91){
    movingRoutine(keyCode);
  }
}

// makes the ball freeze if it was previously moving and vice versa
void movingRoutine(int code){
  int keyC = code - 65; // to range the code of the key to 0 - 25
  if (balls.get(keyC).getMoving()){
      balls.get(keyC).setMoving(false);
      balls.get(keyC).setSpeed(0);
    } else { 
      balls.get(keyC).setMoving(true);
    }
}