public class AssignNode implements Node {
  public String ident;
  public Node value;

  public AssignNode(String ident, Node value) {
    this.ident = ident;
    this.value = value;
  }

  public Value accept(Visitor v) {
    return v.VisitAssign(this);
  }
}
