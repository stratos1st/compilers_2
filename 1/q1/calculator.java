import java.io.InputStream;
import java.io.IOException;
import java.lang.Math;

public class calculator {
  private int lookaheadToken;
  private InputStream in;

  public calculator(InputStream in) throws IOException {
    this.in = in;
    lookaheadToken = in.read();
  }

  private void consume(int symbol) throws IOException, ParseError {
    if (lookaheadToken != symbol)
      throw new ParseError();
    lookaheadToken = in.read();
  }

  private int evalDigit(int digit){
    return digit - '0';
  }

  public int eval() throws IOException, ParseError {
    int rv =expr();
    if (lookaheadToken!='\n' && lookaheadToken!=-1)
      throw new ParseError();
    return rv;
  }

  private int expr() throws IOException, ParseError {
    if(lookaheadToken!='(' && (lookaheadToken<'0' || lookaheadToken>'9'))
      throw new ParseError();
    return exprtail(term());
  }

  private int exprtail(int number) throws IOException, ParseError {
    if(lookaheadToken == ')' || lookaheadToken == '\n' || lookaheadToken == -1)
      return number;
    else if(lookaheadToken!='+' && lookaheadToken!='-')
      throw new ParseError();
    boolean plus=false;
    if(lookaheadToken=='+')
      plus=true;
    consume(lookaheadToken);
    return plus ? exprtail(number+term()) : exprtail(number-term());
  }

  private int term() throws IOException, ParseError {
    if(lookaheadToken!='(' && (lookaheadToken<'0' || lookaheadToken>'9'))
      throw new ParseError();
    return termtail(factor());
  }

  private int termtail(int number) throws IOException, ParseError {
    if(lookaheadToken=='+' || lookaheadToken=='-' ||
        lookaheadToken=='\n' || lookaheadToken==-1 ||
        lookaheadToken==')')
      return number;
    else if(lookaheadToken!='*')
      throw new ParseError();
    // if(lookaheadToken=='*')
    consume(lookaheadToken);
    if(lookaheadToken!='*')
      throw new ParseError();
    consume(lookaheadToken);
    return (int) termtail( (int) Math.pow((int) number,(int) factor()));
  }

  private int factor() throws IOException, ParseError {
    if(lookaheadToken!='(' && (lookaheadToken<'0' || lookaheadToken>'9'))
      throw new ParseError();
    if(lookaheadToken!='(')
      return num(0);
    else{
      consume('(');
      int number=expr();
      consume(')');
      return number;
    }
  }

  private int num(int number) throws IOException, ParseError {
    if(lookaheadToken=='*' || lookaheadToken==')' ||
        lookaheadToken=='+' || lookaheadToken=='-' ||
        lookaheadToken=='\n' || lookaheadToken==-1)
      return number;
    else if(lookaheadToken<'0' || lookaheadToken>'9')
      throw new ParseError();
    int ans=number*10+evalDigit(lookaheadToken);
    consume(lookaheadToken);
    return num(ans);
  }

  public static void main(String[] args) {
    try {
      calculator evaluate = new calculator(System.in);
      System.out.println(evaluate.eval());
    }
    catch (IOException e) {
      System.err.println(e.getMessage());
    }
    catch(ParseError err){
      err.printStackTrace(System.err);
      // System.err.println(err.getMessage());
    }
  }

}

// eval     = expr
// expr     = term exprtail
// exprtail = + term exprtail
//          | - term exprtail
//          | e
// term     = factor termtail
// termtail = * factor termtail
//          | / factor termtail
//          | e
// factor   = num
//          | (expr)
// num      = 0...9 num
//          | e
