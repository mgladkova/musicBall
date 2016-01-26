
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
}

// set of global variables 
ArrayList<Ball> balls = new ArrayList<Ball>();
int gameScreen = 0;
int gravity = 1;
Ball b;

void setup(){
  size(500,500);
  
  for (int i = 0; i < 23; i++){
    Ball ball = new Ball();
    ball.setX(20 + 20*i);
    ball.setY(height/5);
    ball.setColor(color(0));
    ball.setSize(20);
    balls.add(ball);
  }
  
  drawBalls();
  int i = (int)random(9);
  balls.get(i).setMoving(true);
  b = balls.get(i);
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
}

void gameScreen(){
  background(255);
  
  drawBalls();
  applyGravity();
  keepInScreen();
  if (keyPressed){
    for (int i = 0; i < balls.size(); i++){
      if (balls.get(i).getMoving()){
        balls.get(i).setMoving(false);
        println("hah");
        balls.get(i).setSpeed(0);
        balls.get(i).setY(height/5);
      }
    }
    
  }
}

void gameOverScreen(){
  background(100);
}

void drawBalls(){
  for (int i = 0; i < balls.size(); i++){
    ellipse(balls.get(i).getX(),balls.get(i).getY(), balls.get(i).getSize(), balls.get(i).getSize());
  }
}

void applyGravity(){
  if (b.getMoving()){
    b.setSpeed(b.getSpeed() + gravity);
    b.setY(b.getY() + b.getSpeed());
  }
}

void bounceBottom(int surface, Ball ball){
  ball.setY (surface - (ball.getSize()/2));
  ball.setSpeed(b.getSpeed() * -1);
  ball.setMoving(true);
  //ball.setY (height - (ball.getSize()/2));
}

/*void bounceTop(Ball ball){
  ball.setY(b.getSize()/2);
  ball.setSpeed(b.getSpeed() * -1);
}*/

void keepInScreen(){
  for (int i = 0; i < balls.size(); i++){
      if (balls.get(i).getY() + (balls.get(i).getSize()/2) > height){
           bounceBottom(height, balls.get(i));
      }
      
      /*if (balls.get(i).getMoving() && (balls.get(i).getY() - (balls.get(i).getSize()/2) < height/4)){
          balls.get(i).setMoving(false);
          println("hah");
          balls.get(i).setSpeed(0);
          balls.get(i).setY(height/5);
      }*/
         
  }
}

public void mousePressed(){
  if (gameScreen == 0){
    startGame();
  }
}

public void keyPressed(){
  if (keyCode == 8){
    gameScreen = 2;
  }
}

void startGame(){
  gameScreen = 1;
}