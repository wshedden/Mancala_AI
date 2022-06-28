Game game;
AI ai;

void setup(){
  size(600, 400);
  ai = new AI();
  game = new Game(ai);
  game.resetBoardDimensions(80, height/2, 60, 40, 50);
}

void draw() {
  background(255);
  game.display();
}

public void mousePressed() {
   game.clicked(mouseX, mouseY); 
}
