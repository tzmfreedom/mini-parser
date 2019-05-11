public class IfNode implements Node {
  public Node condition;
  public Node ifBlock;
  public Node elseBlock;

  public IfNode(Node condition, Node ifBlock, Node elseBlock) {
    this.condition = condition;
    this.ifBlock = ifBlock;
    this.elseBlock = elseBlock;
  }

  public Value accept(Visitor v) {
    return v.VisitIf(this);
  }
}
