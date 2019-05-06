class IdentifierNode implements Node {
  public String value;

  public IdentifierNode(String value) {
    this.value = value;
  }

  public Value Accept(Visitor v) {
    return v.VisitIdentifier(this);
  }
}
