public class Visitor {
  public Map<String, Value> variables;
  private String buffer;

  public static void main() {
    Visitor v = new Visitor();
    //v.run('a = 10 + 20 * 30 / 6\nputs a\nputs a * 5');
    //System.debug(v.getBuffer());
    //v.run('a1 = 2 * 3 + 4 * 5\nputs a1\nputs a1 * 10');
//    v.run('i = 5\nwhile i != 10 { puts i\ni = i + 1\n }');
//    v.run('for i = 0; i < 5; i = i + 1 { puts i }');
    v.run('a = "hoge"\nputs a + "fuga"');
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
    Value leftValue = node.left.Accept(this);
    Value rightValue = node.right.Accept(this);
    if (leftValue.original instanceof StringNode || rightValue.original instanceof StringNode) {
      switch on node.type {
        when '+' {
          return new Value(leftValue.getString() + rightValue.getString(), null);
        }
      }
    } else {
      Integer left = leftValue.getInteger();
      Integer right = rightValue.getInteger();
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
        when '<=' {
          return new Value(String.valueOf(left <= right), null);
        }
        when '>=' {
          return new Value(String.valueOf(left >= right), null);
        }
        when '<' {
          return new Value(String.valueOf(left < right), null);
        }
        when '>' {
          return new Value(String.valueOf(left > right), null);
        }
        when '==' {
          return new Value(String.valueOf(left == right), null);
        }
        when '!=' {
          return new Value(String.valueOf(left != right), null);
        }
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
    node.init.Accept(this);
    while (true) {
      Value result = node.condition.Accept(this);
      if (result.value != 'true') {
        break;
      }
      node.statements.Accept(this);
      node.upd.Accept(this);
    }
    return null;
  }

  public Value VisitWhile(WhileNode node) {
    while (true) {
      Value result = node.condition.Accept(this);
      if (result.value != 'true') {
        break;
      }
      node.statements.Accept(this);
    }
    return null;
  }
}
