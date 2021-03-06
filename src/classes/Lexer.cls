public class Lexer {
  public String str;
  public Integer index;

  private static List<String> reserved = new List<String>{
    'if',
    'else',
    'for',
    'while',
    'true',
    'false'
  };

  public static void main() {
    String str = 'if true { puts 123 }';
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
        when '+', '-', '*', '/', '=', '\n', '(', ')', '{', '}', '!', ';', '>', '<' {
          if (current == '=' || current == '!' || current == '<' || current == '>') {
            if (this.peek() == '=') {
              String type = current + this.peek();
              token = new Token(type, type);
              this.next();
            }
          }
          if (token == null) {
            token = new Token(current, current);
          }
        }
        when '"' {
          token = this.parseString();
        }
        when else {
          if (Pattern.matches('[0-9]', current)) {
            token = this.parseInt();
          } else if (Pattern.matches('[a-zA-Z]', current)) {
            token = this.parseIdent();
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

  private Token parseIdent() {
    String value = this.current();
    if (this.index == this.str.length() - 1) {
      return new Token('Ident', value);
    }
    String current = this.peek();
    while (Pattern.matches('[a-zA-Z0-9]', current)) {
      this.next();
      value += current;
      if (this.index == this.str.length() - 1) {
        break;
      }
      current = this.peek();
    }
    if (this.reserved.contains(value)) {
      return new Token(value, value);
    }
    return new Token('Ident', value);
  }

  private Token parseInt() {
    String value = this.current();
    if (this.index == this.str.length() - 1) {
      return new Token('Integer', value);
    }
    String current = this.peek();
    while (Pattern.matches('[0-9]', current)) {
      this.next();
      value += current;
      if (this.index == this.str.length() - 1) {
        break;
      }
      current = this.peek();
    }
    return new Token('Integer', value);
  }

  private Token parseString() {
    String current = this.next();
    String value = '';
    while (current != '"') {
      value += current;
      if (this.index == this.str.length() - 1) {
        break;
      }
      current = this.next();
    }
    return new Token('String', value);
  }

  private String peek() {
    return this.str.substring(this.index+1, this.index+2);
  }

  private String current() {
    return this.str.substring(this.index, this.index+1);
  }

  private String next() {
    this.index++;
    return this.current();
  }
}
