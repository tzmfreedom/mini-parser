public class Parser {
  public List<Token> tokens;
  public Integer index;

  public static void main() {
    String str = 'while 1 == 1 { puts 123 }';
    // String str = 'if 1 == 1 { puts 123 }';
    // String str = '10 + 20 * 30 / 6';
    List<Token> tokens = new Lexer(str).parse();
    System.debug(tokens);
    List<Node> nodes = new Parser(tokens).parse();
    System.debug(nodes);
  }

  public Parser(List<Token> tokens) {
    this.tokens = tokens;
    this.index = 0;
  }

  public List<Node> parse() {
    return this.statements();
  }

  public List<Node> statements() {
    List<Node> statements = new List<Node>();
    while (true){
      Node stmt = this.statement();
      if (stmt == null) {
        break;
      }
      statements.add(stmt);
      this.consume('\n');
    }
    return statements;
  }

  public Node statement() {
    if (this.current('if') != null) {
      return this.ifStatement();
    }
    if (this.current('while') != null) {
      return this.whileStatement();
    }
    if (this.current('for') != null) {
      return this.forStatement();
    }
    if (this.peek('=') != null) {
      return this.assign();
    }
    return this.call();
  }

  public Node block() {
    if (consume('{') == null) {
      return null;
    }
    List<Node> statements = this.statements();
    if (consume('}') == null) {
      return null;
    }
    return new BlockNode(statements);
  }

  public Node whileStatement() {
    this.consume('while');
    Node condition = this.boolExpression();
    Node statements = this.block();
    return new WhileNode(condition, statements);
  }

  public Node forStatement() {
    this.consume('for');
    Node init = this.assign();
    if (init == null) {
      return null;
    }
    this.consume(';');
    Node condition = this.boolExpression();
    if (condition == null) {
      return null;
    }
    this.consume(';');
    Node upd = this.assign();
    if (upd == null) {
      return null;
    }
    Node statements = this.block();
    if (statements == null) {
      return null;
    }
    return new ForNode(init, condition, upd, statements);
  }

  public Node ifStatement() {
    this.consume('if');
    Node condition = this.boolExpression();
    Node ifBlock = this.block();
    Node elseBlock;
    if (this.current('else') != null) {
      this.consume('else');
      elseBlock = this.block();
    }
    return new IfNode(condition, ifBlock, elseBlock);
  }

  public Node boolExpression() {
    if (this.consume('true') != null) {
      return new BoolNode(true);
    }
    if (this.consume('false') != null) {
      return new BoolNode(false);
    }
    if (this.peek('==') != null) {
      return this.createBoolExpression('==');
    }
    if (this.peek('!=') != null) {
      return this.createBoolExpression('!=');
    }
    if (this.peek('<') != null) {
      return this.createBoolExpression('<');
    }
    if (this.peek('>') != null) {
      return this.createBoolExpression('>');
    }
    if (this.peek('<=') != null) {
      return this.createBoolExpression('<=');
    }
    if (this.peek('>=') != null) {
      return this.createBoolExpression('>=');
    }
    return null;
  }

  public Node createBoolExpression(String type) {
    Node left = this.term();
    if (left == null) {
      return null;
    }
    this.consume(type);
    Node right = this.term();
    if (right == null) {
      return null;
    }
    return new BinaryOperatorNode(type, left, right);
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
    exp = this.consume('String');
    if (exp != null) {
      return new StringNode(exp.value);
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
    if (this.tokens.size() <= this.index+1) {
      return null;
    }
    return this.tokens[this.index+1];
  }

  public Token peek(String type) {
    Token token = this.peek();
    if (token != null && token.Type == type) {
      return token;
    }
    return null;
  }

  public Token current() {
    if (this.tokens.size() == this.index) {
      return null;
    }
    return this.tokens[this.index];
  }

  public Token current(String type) {
    Token token = this.current();
    if (token != null && token.Type == type) {
      return token;
    }
    return null;
  }
}
