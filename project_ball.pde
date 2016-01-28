import ddf.minim.*;
import ddf.minim.ugens.*;
PFont f;

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
  float currY;
  int ballColor;
  float ballSpeed;
  int ballSize;
  char ballKeyCode;
  boolean moving;
  
  Ball(){
    ballX = 0;
    ballY = 0;
    ballColor = color(0);
    ballSpeed = 0;
    ballSize = 20;
    moving = false;
    ballKeyCode = 'q';
    currY = 0;
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
  
  char getKey(){
    return ballKeyCode;
  }
  
  void setKey(char code){
    ballKeyCode = code;
  }
  
  float getCurrY(){
    return currY;
  }
  
  void setCurrY(float curr){
    currY = curr;
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
char[] buttons = {'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'};

// initial screen mode
int gameScreen = 0;
float gravity = 0.08;
// assign by default mode 1
boolean mode1 = true;
int prevScreen = 1;
void setup(){
  size(800,500, P3D);
  f = createFont("Arial", 32);
  for (int i = 0; i < 26; i++){
    Ball ball = new Ball();
    ball.setX(20 + 30*i);
    ball.setY(20);
    ball.setCurrY(20);
    ball.setColor(color(i * 5));
    ball.setSize(20);
    ball.setKey(buttons[i]);
    balls.add(ball);
  }
}

void draw(){
  if (gameScreen == 0){
    initScreen();
  } else if (gameScreen == 1 || gameScreen == 4){
    gameScreen();
  } else if (gameScreen == 2){
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
  text("Press 1 or 2 to start and 3 to come later!", width*0.4, height*0.55); 
  pushMatrix();
  translate(300, height*0.45, -200);
  rotateY(1.25);
  rotateX(-0.4);
  stroke(0);
  noFill();
  sphere(280);
  popMatrix();
}
void gameScreen(){
  background(0);
  textFont(f,10);
  fill(255);
  text("Balls' accelaration " + gravity, width*0.8, height*0.05);
  text("Press BACKSPACE to reset", width*0.8, height*0.1);
  text("Press 3 to exit the game", width*0.8, height*0.15);
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
  //frame.setVisible(false);
}

// returns the balls to their initial states 
void gameReloadScreen(){
  background(0);
  for (int i = 0; i < balls.size(); i++){
    balls.get(i).setY(height/5);
    balls.get(i).setSpeed(0);
    balls.get(i).setMoving(false);
  }
  gameScreen = prevScreen;
}

// draws all the balls in the current positions
void drawBalls(){
  
  for (int i = 0; i < balls.size(); i++){
    if (balls.get(i).getMoving()){
      float c = map(balls.get(i).getY(),balls.get(i).getCurrY(), height -15, 255,0);
      fill(c);
    }
    ellipse(balls.get(i).getX(),balls.get(i).getY(), balls.get(i).getSize(), balls.get(i).getSize());
    noFill();
    // drawing a string whenever the ball hangs
    if (balls.get(i).getY() != 135){
      stroke(255);
      line(balls.get(i).getX(), 135, balls.get(i).getX(),balls.get(i).getY() - 10);
    }
  }
  
  drawBars();
}

void drawBars(){
  for (int i = 0; i < balls.size(); i++){
    rect(balls.get(i).getX() - 15, height - 15, 30, 15);
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
  ball.setY (surface - (ball.getSize()/2));
  ball.setSpeed(ball.getSpeed() * -1);
  // plays a note for each hit of the bottom mapping every ball to the range [440,4000] Hz
  if (gameScreen == 1)
    out.playNote(0.0, 0.3, new SineInstrument(map(balls.indexOf(ball), 0, balls.size() - 1, 60, 1000)));
  else if (gameScreen == 4)
    out.playNote(0.0, 0.3, new SineInstrument(map(ball.getCurrY(), height/5, height, 1000, 60)));
  fill(255,0,0);
  rect(ball.getX() - 15, height - 15, 30, 15);
  noFill();
}

// whenever the top threshold is reached makes the ball move down
void bounceTop(int surface, Ball ball){
  ball.setY(surface + ball.getSize()/2);
  ball.setSpeed(ball.getSpeed() * -1);
}

// assures that the ball doesn't go beyond the screen/specified top
void keepInScreen(){
  for (int i = 0; i < balls.size(); i++){
      if (balls.get(i).getY() + (balls.get(i).getSize()/2) > (height - 15)){
           bounceBottom((height - 15), balls.get(i));
      }
      
      if (balls.get(i).getY() - (balls.get(i).getSize()/2) < height/4){
          bounceTop(height/4,balls.get(i));
      }
         
  }
}

// makes a certain ball move/freeze 
public void keyPressed(){
  if (keyCode == 8){
    prevScreen = gameScreen;
    gameScreen = 2;
  } else if (key == '1'){
    gameScreen = 1;
    //mode1 = true;
  } else if (key == '2'){
    gameScreen = 4;
    //mode1 = false;
  } else if (key == '3'){
    gameScreen = 3;
  }else if (key >= 'a' && key <= 'z'){
    movingRoutine(key);
  } else if (keyCode == 38){
    if (gravity > 1){
       gravity = 0.5;
    } else 
       gravity += 0.1;
  } else if (keyCode == 40){
    if (gravity < 0){
      gravity = 0;
    } else { 
      gravity -= 0.1;
    }
  }
}

// makes the ball freeze if it was previously moving and vice versa
void movingRoutine(char code){
  int keyC = -1;
  for (int i = 0; i < balls.size(); i++){
    if (balls.get(i).getKey() == code){
      keyC = i;
      break;
    }
  }
  
  try{
    if (balls.get(keyC).getMoving()){
        balls.get(keyC).setMoving(false);
        balls.get(keyC).setSpeed(0);
      } else {
        balls.get(keyC).setCurrY(balls.get(keyC).getY());
        balls.get(keyC).setMoving(true);
      }
  } catch (Exception e){
    println("Error occured");
  } 
}