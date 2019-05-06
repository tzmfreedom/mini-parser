class ForNode implements Node {
  public Node init;
  public Node condition;
  public Node update;
  public Node statements;

  public ForNode(Node init, Node condition, Node update, Node statements) {
    this.init = init;
    this.condition = condition;
    this.update = update;
    this.statements = statements;
  }

  public Value Accept(Visitor v) {
    return v.VisitFor(this);
  }
}
