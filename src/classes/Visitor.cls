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
    Value result = node.accept(this);
  }

  private Value visitInteger(IntegerNode node) {
    return new Value(node.value, node);
  }

  private Value visitString(StringNode node) {
    return new Value(node.value, node);
  }

  private Value visitBinaryOperator(BinaryOperatorNode node) {
    Value leftValue = node.left.accept(this);
    Value rightValue = node.right.accept(this);
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

  private Value visitAssign(AssignNode node) {
    Value v = node.value.accept(this);
    this.variables.put(node.ident, v);
    return v;
  }

  private Value visitIdentifier(IdentifierNode node) {
    return this.variables.get(node.value);
  }

  private Value visitCall(CallNode node) {
    switch on node.ident {
      when 'puts' {
        buffer += node.value.accept(this).getString() + '\n';
      }
    }
    return null;
  }

  private Value visitBool(BoolNode node) {
    return new Value(String.valueOf(node.value), node);
  }

  private Value visitBlock(BlockNode node) {
    Value ret;
    for (Node statement : node.statements) {
      ret = statement.accept(this);
    }
    return ret;
  }

  private Value visitIf(IfNode node) {
    Value v = node.condition.accept(this);
    if (v.value == 'true') {
      node.ifBlock.accept(this);
    } else {
      node.elseBlock.accept(this);
    }
    return null;
  }

  private Value visitFor(ForNode node) {
    node.init.accept(this);
    while (true) {
      Value result = node.condition.accept(this);
      if (result.value != 'true') {
        break;
      }
      node.statements.accept(this);
      node.upd.accept(this);
    }
    return null;
  }

  private Value visitWhile(WhileNode node) {
    while (true) {
      Value result = node.condition.accept(this);
      if (result.value != 'true') {
        break;
      }
      node.statements.accept(this);
    }
    return null;
  }
}
