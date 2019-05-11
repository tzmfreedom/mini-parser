public class WhileNode implements Node {
  public Node condition;
  public Node statements;

  public WhileNode(Node condition, Node statements) {
    this.condition = condition;
    this.statements = statements;
  }

  public Value accept(Visitor v) {
    return v.VisitWhile(this);
  }
}
