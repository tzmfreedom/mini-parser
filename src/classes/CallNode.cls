public class CallNode implements Node {
  public String ident;
  public Node value;

  public CallNode(String ident, Node value) {
    this.ident = ident;
    this.value = value;
  }

  public Value Accept(Visitor v) {
    return v.VisitCall(this);
  }
}
