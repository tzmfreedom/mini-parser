class Visitor {
  public Map<String, Value> variables;
  private String buffer;

  public static void main() {
    Visitor v = new Visitor();
    //v.run('a = 10 + 20 * 30 / 6\nputs a\nputs a * 5');
    //System.debug(v.getBuffer());
    //v.run('a1 = 2 * 3 + 4 * 5\nputs a1\nputs a1 * 10');
    v.run('if 2 != 2 { puts 123 } else { puts 234 }');
    System.debug(v.getBuffer());
  }

  public Visitor() {
    this.variables = new Map<String, Value>();
  }

  public void run(String str) {
    this.buffer = '';
    List<Token> tokens = new Lexer(str).parse();
    List<Node> nodes = new Parser(tokens).parse();
    for (Node node : nodes) {
      this.Visit(node);
    }
  }

  public String getBuffer() {
    return this.buffer;
  }

  public void Visit(Node node) {
    Value result = node.Accept(this);
  }

  public Value VisitInteger(IntegerNode node) {
    return new Value(node.value, node);
  }

  public Value VisitString(StringNode node) {
    return new Value(node.value, node);
  }

  public Value VisitBinaryOperator(BinaryOperatorNode node) {
    Integer left = node.left.Accept(this).getInteger();
    Integer right = node.right.Accept(this).getInteger();
    switch on node.type {
      when '+' {
        return new Value(String.valueOf(left + right), null);
      }
      when '-' {
        return new Value(String.valueOf(left - right), null);
      }
      when '*' {
        return new Value(String.valueOf(left * right), null);
      }
      when '/' {
        return new Value(String.valueOf(left / right), null);
      }
      when '==' {
        return new Value(String.valueOf(left == right), null);
      }
      when '!=' {
        return new Value(String.valueOf(left != right), null);
      }
    }
    return null;
  }

  public Value VisitAssign(AssignNode node) {
    Value v = node.value.Accept(this);
    this.variables.put(node.ident, v);
    return v;
  }

  public Value VisitIdentifier(IdentifierNode node) {
    return this.variables.get(node.value);
  }

  public Value VisitCall(CallNode node) {
    switch on node.ident {
      when 'puts' {
        buffer += node.value.Accept(this).getString() + '\n';
      }
    }
    return null;
  }

  public Value VisitBool(BoolNode node) {
    return new Value(String.valueOf(node.value), node);
  }

  public Value VisitBlock(BlockNode node) {
    Value ret;
    for (Node statement : node.statements) {
      ret = statement.Accept(this);
    }
    return ret;
  }

  public Value VisitIf(IfNode node) {
    Value v = node.condition.Accept(this);
    if (v.value == 'true') {
      node.ifBlock.Accept(this);
    } else {
      node.elseBlock.Accept(this);
    }
    return null;
  }

  public Value VisitFor(ForNode node) {
    return null;
  }

  public Value VisitWhile(WhileNode node) {
    return null;
  }
}
