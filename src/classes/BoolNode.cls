public class BoolNode implements Node {
  public Boolean value;

  public BoolNode(Boolean value) {
    this.value = value;
  }

  public Value Accept(Visitor v) {
    return v.VisitBool(this);
  }
}
