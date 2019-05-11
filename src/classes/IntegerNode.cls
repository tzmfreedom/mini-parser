public class IntegerNode implements Node {
  public String value;

  public IntegerNode(String value) {
    this.value = value;
  }

  public Value accept(Visitor v) {
    return v.VisitInteger(this);
  }
}
