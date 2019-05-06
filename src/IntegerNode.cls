class IntegerNode implements Node {
  public String value;

  public IntegerNode(String value) {
    this.value = value;
  }

  public Value Accept(Visitor v) {
    return v.VisitInteger(this);
  }
}
