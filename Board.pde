public class Board { //<>//
  // display variables
  public float xSpace = 30f;
  public float ySpace = 2f;
  public float diameter = 20f;
  public float x = 0f;
  public float y = 0f;

  // game variables

  public State state = State.PLAYING;

  private Pot[] p1Pots = new Pot[7];
  private Pot[] p2Pots = new Pot[7];
  private Player turn = Player.P1;

  public Board() {
    potSetup();
  }

  private void potSetup() {
    // pockets
    p1Pots[6] = new Pot(x+7*xSpace, y, diameter, diameter*2);
    p2Pots[6] = new Pot(x, y, diameter, diameter*2);
    p1Pots[6].value = 0;
    p2Pots[6].value = 0;

    // normal pots
    for (int i = 1; i < 7; i++) {
      p1Pots[i-1] = new Pot(x+i*xSpace, y+ySpace, diameter, diameter);
      p2Pots[i-1] = new Pot(x+(7-i)*xSpace, y-ySpace, diameter, diameter);
    }
  }

  public void resetPots(float x, float y, float xSpace, float ySpace, float diameter) {
    this.x = x;
    this.y = y;
    this.xSpace = xSpace;
    this.ySpace = ySpace;
    this.diameter = diameter; 

    potSetup();
  }

  public void display() {
    for (int i = 0; i < 7; i++) {
      p1Pots[i].display();
      p2Pots[i].display();
    }
    //println(turn, state);
  }

  public boolean move(Player player, int move) {
    if (player != turn) return false;
    if (move < 0 || move > 5) return false;
    if(hasNoStones(player)) {
      turn = turn == Player.P1 ? Player.P2 : Player.P1; 
      return false;
    }
    println("MOVING", player, state);

    Pot[] currentPots = turn == Player.P1 ? p1Pots : p2Pots;
    int currentStones = currentPots[move].value;
    if (currentStones == 0) return false;

    Player currentSide = player;
    currentPots[move].value = 0;
    int currentPot = move + 1;

    while (currentStones > 0) {
      if (currentSide == player || currentPot < 6) {
        currentPots[currentPot].value++;
        currentStones--;
      }
      currentPot++;


      if (currentPot > 6) {
        currentPot = 0;
        currentSide = currentSide == Player.P1 ? Player.P2 : Player.P1; // switch sides
        currentPots = currentSide == Player.P1 ? p1Pots : p2Pots;
      }
    }

    currentPot = currentPot == 0 ? 6 : currentPot - 1;
    currentSide = currentPot == 6 ? (currentSide == Player.P1 ? Player.P2 : Player.P1) : currentSide;
    // check where the final stone lands
    if (player == currentSide && currentPot != 6) {
      Pot[] pots = player == Player.P1 ? p1Pots : p2Pots;
      Pot[] enemyPots = player == Player.P2 ? p1Pots : p2Pots;
      if (pots[currentPot].value == 1) {
        // capture
        if (enemyPots[5-currentPot].value > 0) {
          pots[6].value += enemyPots[5 - currentPot].value + 1;
          enemyPots[5 - currentPot].value = 0;
          pots[currentPot].value = 0;
        }
      }
    }
    if (currentPot != 6 || player != currentSide) { // give extra turn if lands on store
      turn = turn == Player.P1 ? Player.P2 : Player.P1;
    }
    // check if player has no stones
    Player enemy = player == Player.P1 ? Player.P2 : Player.P1;
    if (hasNoStones(enemy)) {
      if (hasNoStones(player)) {
        print("Both have no stones");
        state = calculateWin(); // update state
      } else {
        print("Only enemy has no stones");
        turn = player;
      }
    }
    println("MOVING END", player, state);
    return true;
  }


  private State calculateWin() {
    if (p1Pots[6].value > p2Pots[6].value) {
      return State.P1_WIN;
    } else if (p2Pots[6].value > p1Pots[6].value) {
      return State.P2_WIN;
    } 
    return State.DRAW;
  }

  private boolean hasNoStones(Player player) {
    Pot[] pots = player == Player.P1 ? p1Pots : p2Pots;  
    for (int i = 0; i < 6; i++) {
      if (pots[i].value > 0) return false;
    }
    return true;
  }

  public boolean clicked(float mX, float mY) {
    if (turn != Player.P1) return false;
    int index = -1;
    for (int i = 0; i < 6; i++) {
      float p1Distance = PVector.dist(new PVector(mX, mY), new PVector(p1Pots[i].x, p1Pots[i].y));
      if (p1Distance < diameter / 2) {
        index = i;
        break;
      }
    }
    if (index == -1) return false;
    boolean successful = move(Player.P1, index);
    return successful;
  }


  public State getState() {
    return state;
  }
}

public enum Player {
  P1, P2;
}

public enum State {
  PLAYING, DRAW, P1_WIN, P2_WIN;
}
