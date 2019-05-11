public class IdentifierNode implements Node {
  public String value;

  public IdentifierNode(String value) {
    this.value = value;
  }

  public Value accept(Visitor v) {
    return v.VisitIdentifier(this);
  }
}
