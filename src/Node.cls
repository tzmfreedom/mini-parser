class Node {
  public String type;
  public String value;
  public Node left;
  public Node right;

  public Token(String type, String value, Node left, Node right) {
    this.type = type;
    this.value = value;
    this.left = left;
    this.right = right;
  }

  public Integer Accept(Visitor v) {
    switch on type {
      when 'Integer' {
        return Integer.valueOf(this.value);
      }
      when '+' {
        return this.left.Accept(v) + this.right.Accept(v);
      }
      when '-' {
        return this.left.Accept(v) - this.right.Accept(v);
      }
      when '*' {
        return this.left.Accept(v) * this.right.Accept(v);
      }
      when '/' {
        return this.left.Accept(v) / this.right.Accept(v);
      }
    }
    return null;
  }
}
