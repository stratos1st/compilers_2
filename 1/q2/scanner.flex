import java_cup.runtime.*;

%%
/* -----------------Options and Declarations Section----------------- */

/*
   The name of the class JFlex will create will be Lexer.
   Will write the code to the file Lexer.java.
*/
%class Scanner

/*
  The current line number can be accessed with the variable yyline
  and the current column number with the variable yycolumn.
*/
%line
%column

/*
   Will switch to a CUP compatibility mode to interface with a CUP
   generated parser.
*/
%cup
%unicode 

/*
  Declarations

  Code between %{ and %}, both of which must be at the beginning of a
  line, will be copied letter to letter into the lexer class source.
  Here you declare member variables and functions that are used inside
  scanner actions.
*/

%{
	StringBuffer stringBuffer = new StringBuffer();
	private Symbol symbol(int type) {
	   return new Symbol(type, yyline, yycolumn);
	}
	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

/*
  Macro Declarations

  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.
*/
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
identifiers = [A-Za-z_][A-Za-z_0-9]*
paren_brace = [)]{WhiteSpace}*[{]

%state STRING

%%
/* ------------------------Lexical Rules Section---------------------- */

<YYINITIAL> {
/* operators */
 "+"            { return symbol(sym.PLUS_DOPP); } //DUAL OPPERATOR
 {paren_brace}	{ return symbol(sym.PAREN_BRACE); }
 "}"      		{ return symbol(sym.RBRACE); }
 "("            { return symbol(sym.LPAREN); }
 ")"            { return symbol(sym.RPAREN); }
 ","      		{ return symbol(sym.SEPARATOR);	}
 "if"			{ return symbol(sym.IF_STATE); }
 "else"			{ return symbol(sym.ELSE_STATE); }
 "prefix"		{ return symbol(sym.PREF_SOPP); } //SINGLE OPPERATOR
 "reverse"		{ return symbol(sym.REVE_SOPP); } //SINGLE OPPERATOR
 \"             { stringBuffer.setLength(0); yybegin(STRING); }
 {identifiers} { return symbol(sym.IDENTIFIER, yytext()); }
 {WhiteSpace}   { /* just skip what was found, do nothing */ }
}

<STRING> {
      \"                             { yybegin(YYINITIAL);
                                       return symbol(sym.STRING_LITERAL, stringBuffer.toString()); }
      [^\n\r\"\\]+                   { stringBuffer.append( yytext() ); }
      \\t                            { stringBuffer.append('\t'); }
      \\n                            { stringBuffer.append('\n'); }

      \\r                            { stringBuffer.append('\r'); }
      \\\"                           { stringBuffer.append('\"'); }
      \\                             { stringBuffer.append('\\'); }
}

/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }
