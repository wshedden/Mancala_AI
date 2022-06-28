public class Game {  
  
  public boolean clickable = true;
  private Board board = new Board();
  private AI ai;
  
  public Game(AI ai) {
     this.ai = ai; 
  }
  
  
  public void resetBoardDimensions(float x, float y, float xSpace, float ySpace, float diameter) {
     board.resetPots(x, y, xSpace, ySpace, diameter);
  }
  
  
  public void display() {
    board.display(); 
  }
  
  private void aiMove() {
    State state = board.getState();
    while (state == State.PLAYING && board.turn == Player.P2) {
        int move = ai.getMove(board, Player.P2);
        board.move(Player.P2, move);
    }
    println(state);
  }
  
  public void clicked(float x, float y) {
     if(mouseButton != LEFT) return;
     if(board.clicked(x, y)) {
       aiMove();
     } else {
       println("CLICK ERROR");
     }
  }
}
