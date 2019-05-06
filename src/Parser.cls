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
    List<Node> statements = new List<Node>();
    while (true){
      Node stmt = this.statement();
      if (stmt == null) {
        break;
      }
      this.consume('\n');
      statements.add(stmt);
    }
    return statements;
  }

  public Node statement() {
    Integer index = this.index;
    Node n = this.call();
    if (n != null) {
      return n;
    }
    this.index = index;

    n = this.assign();
    return n;
  }

  public Node call() {
    Token ident = this.consume('Ident');
    if (ident == null) {
      return null;
    }
    Node exp = this.add();
    if (exp == null) {
      return null;
    }
    return new CallNode(ident.value, exp);
  }

  public Node assign() {
    Token ident = this.consume('Ident');
    if (ident == null) {
      return null;
    }
    Token op = this.consume('=');
    if (op == null) {
      return null;
    }
    Node exp = this.add();
    return new AssignNode(ident.value, exp);
  }

  public Node add() {
    Node exp = this.mul();
    Token op = consume('+');
    if (op != null) {
      return new BinaryOperatorNode('+', exp, this.add());
    }
    op = consume('-');
    if (op != null) {
      return new BinaryOperatorNode('-', exp, this.add());
    }
    return exp;
  }

  public Node mul() {
    Node exp = this.term();
    Token op = consume('*');
    if (op != null) {
      return new BinaryOperatorNode('*', exp, this.mul());
    }
    op = consume('/');
    if (op != null) {
      return new BinaryOperatorNode('/', exp, this.mul());
    }
    return exp;
  }

  public Node term() {
    Token exp = this.consume('Integer');
    if (exp != null) {
      return new IntegerNode(exp.value);
    }
    exp = this.consume('Ident');
    if (exp != null) {
      return new IdentifierNode(exp.value);
    }
    return null;
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
