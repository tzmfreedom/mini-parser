class Visitor {
  public static void main() {
    Visitor v = new Visitor();
    v.run('10 + 20 * 30 / 6');
    v.run('2 * 3 + 4 * 5');
  }

  public void run(String str) {
    List<Token> tokens = new Lexer(str).parse();
    List<Node> nodes = new Parser(tokens).parse();
    for (Node node : nodes) {
      this.Visit(nodes[0]);
    }
  }

  public void Visit(Node node) {
    Integer result = node.Accept(this);
    System.debug(result);
  }
}
