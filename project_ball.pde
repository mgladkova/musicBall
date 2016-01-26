
// a class of balls jumping in the window
class Ball{
  int ballX;
  int ballY;
  int ballColor;
  int ballSpeed;
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
  
  void setX(int x){
    ballX = x;
  }
  
  int getX(){
    return ballX;
  }
  
  void setY(int y){
    ballY = y;
  }
  
  int getY(){
    return ballY;
  }
  
  void setSize(int size){
    ballSize = size;
  }
  
  int getSize(){
    return ballSize;
  }
  
  void setSpeed(int speed){
    ballSpeed = speed;
  }
  
  int getSpeed(){
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

// set of global variables 
ArrayList<Ball> balls = new ArrayList<Ball>();

int gameScreen = 0;
int gravity = 1;

void setup(){
  size(500,500);
  
  for (int i = 0; i < 23; i++){
    Ball ball = new Ball();
    ball.setX(20 + 20*i);
    ball.setY(height/5);
    ball.setColor(color(i * 5));
    ball.setSize(20);
    balls.add(ball);
  }
  
  drawBalls();
}

void draw(){
  if (gameScreen == 0){
    initScreen();
  } else if (gameScreen == 1){
    gameScreen();
  } else if (gameScreen == 2){
    gameOverScreen();
  }
}

void initScreen(){
  background(0);
  textAlign(CENTER);
  text("Click to start", height/2, width/2);
  if (mousePressed){
    startGame();
  }
}

void gameScreen(){
  background(255);
  
  drawBalls();
  applyGravity();
  keepInScreen();
    
}

void gameOverScreen(){
  background(100);
}

void drawBalls(){
  for (int i = 0; i < balls.size(); i++){
    fill(random(255), random(255), random(255));
    ellipse(balls.get(i).getX(),balls.get(i).getY(), balls.get(i).getSize(), balls.get(i).getSize());
  }
}

void applyGravity(){
  for (int i = 0; i < balls.size(); i++) {
    if (balls.get(i).getMoving()){
      balls.get(i).setSpeed(balls.get(i).getSpeed() + gravity);
      balls.get(i).setY(balls.get(i).getY() + balls.get(i).getSpeed());
    }
  }
}

void bounceBottom(int surface, Ball ball){
  ball.setY (surface - (ball.getSize()/2));
  ball.setSpeed(ball.getSpeed() * -1);
}

void bounceTop(int surface, Ball ball){
  ball.setY(surface + ball.getSize()/2);
  ball.setSpeed(ball.getSpeed() * -1);
}

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

public void keyPressed(){
  if (keyCode == 8){
    gameScreen = 2;
  } else if (keyCode > 64 && keyCode < 88){
    movingRoutine(keyCode);
  }
}

void startGame(){
  gameScreen = 1;
}

void movingRoutine(int code){
  int keyC = code - 65;
  if (balls.get(keyC).getMoving()){
      balls.get(keyC).setMoving(false);
      balls.get(keyC).setSpeed(0);
    } else { 
      balls.get(keyC).setMoving(true);
    }
}