public class AI {
  private int iterations;
  public AI() {
  }

  public int getMove(Board board, Player player, int iterations) { 
    this.iterations = iterations;
    return mcts(new Node(board, null), player);
  }

  private int mcts(Node node, Player player) { // COMPLETE
    while (iterations > 0) {
      Node leaf = traverse(node);
      int simulationResult = rollout(leaf, player);
      backpropagate(leaf, simulationResult);
      iterations--;
    }
    return node.bestChild().getPrevMove();
  }

  private Node traverse(Node node) {
    while (!node.isLeafNode()) { // This is wrong TODO
      node = node.bestUCT();
    }

    Node unvisited = node.pickUnvisited();
    if (unvisited == null) return node;
    return unvisited;
  }


  private int rollout(Node node, Player player) { // COMPLETE
    while (!node.isTerminal()) {
      node = rolloutPolicy(node);
    }
    return node.result(player);
  }

  private Node rolloutPolicy(Node node) { // COMPLETE
    return node.randomChild();
  }
  
  

  private void backpropagate(Node node, int result) { // COMPLETE
    if (node.isRoot()) return;
    node.updateStats(result);
    backpropagate(node.parent, result);
  }
}

public class Node {
  public int visits = 0;
  public int score = 0;
  public Node parent = null;

  private Board board;
  private ArrayList<Node> children = new ArrayList<Node>();

  public Node(Board board, Node parent) {
    this.board = board.copy();
    this.parent = parent;
  }

  public ArrayList<Integer> getMoves() { // COMPLETE
    return board.getMoves();
  }

  public boolean isLeafNode() { // COMPLETE
    return visits == 0;
  }

  public Node bestChild() { // COMPLETE
    int maxVisits = -1;
    Node maxNode = null;
    for (int i = 0; i < children.size(); i++) {
      Node child = children.get(i);
      if (child.visits > maxVisits) {
        maxVisits = child.visits;
        maxNode = child;
      }
    }
    return maxNode;
  }

  public int result(Player player) { // COMPLETE
    return board.getScoreAdvantage(player);
  }
  
  private boolean isTerminal() { // COMPLETE
     return board.state != State.PLAYING; 
  }

  private void generateChildren() { // COMPLETE
    ArrayList<Integer> moves = getMoves();
    for (int i = 0; i < moves.size(); i++) {
      Board newBoard = board.copy();
      newBoard.move(newBoard.turn, moves.get(i));
      children.add(new Node(newBoard, this));
    }
  }

  public Node bestUCT() { // COMPLETE
    float maxUCT = -1;
    Node maxNode = null;
    for (int i = 0; i < children.size(); i++) {
      Node child = children.get(i);
      float uct = child.getUCT();
      if (uct > maxUCT) {
        maxUCT = uct;
        maxNode = child;
      }
    }
    return maxNode;
  }

  public float getUCT() { // COMPLETE
    if (visits == 0) return 999999f;
    return score + 2*sqrt((log(visits) / visits));
  }

  public Node randomChild() { // COMPLETE
    return children.get((int) random(children.size()));
  }

  public int getPrevMove() { // COMPLETE
    return board.getPrevMove();
  }

  public boolean isRoot() { // COMPLETE
    return parent == null;
  }

  public void updateStats(int result) { // COMPLETE
    score += result;
    visits++;
  }  

  public Node pickUnvisited() {
    Node unvisited = null;

    return unvisited;
  }
}
