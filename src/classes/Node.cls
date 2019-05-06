public interface Node {
  Value Accept(Visitor v);
}
