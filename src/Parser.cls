class Parser {
  public List<Token> tokens;
  public Integer index;

  public static void main() {
    String str = '10 + 20 * 30 / 6';
    List<Token> tokens = new Lexer(str).parse();
    List<Node> nodes = new Parser(tokens).parse();
    System.debug(nodes);
  }

  public Parser(List<Token> tokens) {
    this.tokens = tokens;
    this.index = 0;
  }

  public List<Node> parse() {
    return new List<Node>{ this.add() };
  }

  public Node add() {
    Node exp = this.mul();
    Token op = consume('+');
    if (op != null) {
      return new Node('+', '+', exp, this.add());
    }
    op = consume('-');
    if (op != null) {
      return new Node('-', '-', exp, this.add());
    }
    return exp;
  }

  public Node mul() {
    Node exp = this.term();
    Token op = consume('*');
    if (op != null) {
      return new Node('*', '*', exp, this.mul());
    }
    op = consume('/');
    if (op != null) {
      return new Node('/', '/', exp, this.mul());
    }
    return exp;
  }

  public Node term() {
    Token exp = this.consume('Integer');
    return new Node('Integer', exp.value, null, null);
  }

  public Token consume(String type) {
    Token currentToken = this.current();
    if (currentToken == null) {
      return null;
    }
    if (currentToken.type == type) {
      this.index++;
      return currentToken;
    }
    return null;
  }

  public Token peek() {
    return this.tokens[this.index+1];
  }

  public Token current() {
    if (this.tokens.size() == this.index) {
      return null;
    }
    return this.tokens[this.index];
  }
}
