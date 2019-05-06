public class StringNode implements Node {
  public String value;

  public StringNode(String value) {
    this.value = value;
  }

  public Value Accept(Visitor v) {
    return v.VisitString(this);
  }
}
