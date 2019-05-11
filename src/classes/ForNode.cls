public class ForNode implements Node {
  public Node init;
  public Node condition;
  public Node upd;
  public Node statements;

  public ForNode(Node init, Node condition, Node upd, Node statements) {
    this.init = init;
    this.condition = condition;
    this.upd = upd;
    this.statements = statements;
  }

  public Value accept(Visitor v) {
    return v.VisitFor(this);
  }
}
