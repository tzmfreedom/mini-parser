public class BinaryOperatorNode implements Node {
  public String type;
  public Node left;
  public Node right;

  public BinaryOperatorNode(String type, Node left, Node right) {
    this.type = type;
    this.left = left;
    this.right = right;
  }

  public Value accept(Visitor v) {
    return v.VisitBinaryOperator(this);
  }
}
