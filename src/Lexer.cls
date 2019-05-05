class Lexer {
  public String str;
  public Integer index;

  public static void main() {
    String str = '10 + 20 * 30 / 6';
    List<Token> tokens = new Lexer(str).parse();
    System.debug(tokens);
  }

  public Lexer(String str) {
    this.str = str;
    this.index = 0;
  }

  public List<Token> parse() {
    List<Token> tokens = new List<Token>();
    String current = this.current();
    while (true){
      Token token;
      switch on current {
        when '+', '-', '*', '/' {
          token = new Token(current, current);
        }
        when else {
          if (Pattern.matches('[0-9]', current)) {
            token = this.parseInt();
          }
        }
      }
      if (token != null) {
        tokens.add(token);
      }
      if (this.index == this.str.length() - 1) {
        break;
      }
      current = this.next();
    }
    return tokens;
  }

  public Token parseInt() {
    String current = this.current();
    String value = '';
    while (Pattern.matches('[0-9]', current)) {
      value += current;
      if (this.index == this.str.length() - 1) {
        break;
      }
      current = this.next();
    }
    return new Token('Integer', value);
  }

  public String peek() {
    return this.str.charAt(this.index+1);
  }

  public String current() {
    return this.str.charAt(this.index);
  }

  public String next() {
    this.index++;
    return this.current();
  }
}
