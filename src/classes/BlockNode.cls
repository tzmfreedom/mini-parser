public class BlockNode implements Node {
  public List<Node> statements;

  public BlockNode(List<Node> statements) {
    this.statements = statements;
  }

  public Value accept(Visitor v) {
    return v.VisitBlock(this);
  }
}
