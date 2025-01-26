%%
%cup
%public
%class Lexer
%implements java_cup.runtime.Scanner
%unicode
%line
%column

/* Definitions */
digit       = [0-9]
letter      = [a-zA-Z]
identifier  = {letter}({letter}|{digit})*

%%

/* Rules */

/* Ignore whitespace */
[ \t\n\r]+ { /* ignore */ }

/* Numbers with optional decimal, and optional SI suffix */
{digit}+(\.{digit}+)?[mMkG]? {
    String text = yytext();
    double val;

    /* Check for SI suffix */
    if (text.endsWith("m")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 0.001;
    } else if (text.endsWith("k")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 1000;
    } else if (text.endsWith("M")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 1_000_000;
    } else if (text.endsWith("G")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 1_000_000_000;
    } else {
        /* No suffix */
        val = Double.parseDouble(text);
    }

    return new Symbol(sym.NUMBER, val);
}

/* "pi" and "e" as numeric constants */
"pi" { return new Symbol(sym.NUMBER, Math.PI); }
"e"  { return new Symbol(sym.NUMBER, Math.E);  }

/* Parentheses */
"("  { return new Symbol(sym.LPAREN); }
")"  { return new Symbol(sym.RPAREN); }

/* Exponentiation operator */
"**" { return new Symbol(sym.EXP); }

/* Percent operator */
"%"  { return new Symbol(sym.PERCENT); }

/* Multiplication and division */
"*"  { return new Symbol(sym.MUL); }
"/"  { return new Symbol(sym.DIV); }

/* Addition and subtraction */
"+"  { return new Symbol(sym.PLUS); }
"-"  { return new Symbol(sym.MINUS); }

/* avg function */
"avg" { return new Symbol(sym.avg); }

/* Comma for separating arguments in avg() */
","  { return new Symbol(sym.COMMA); }

/* Conditional keywords */
"if"   { return new Symbol(sym.IF_TOK); }
"else" { return new Symbol(sym.ELSE_TOK); }

/* Logical operators */
"<="  { return new Symbol(sym.LE); }
">="  { return new Symbol(sym.GE); }
"=="  { return new Symbol(sym.EQ); }
"!="  { return new Symbol(sym.NE); }
"<"   { return new Symbol(sym.LT); }
">"   { return new Symbol(sym.GT); }

/* Handle unrecognized characters */
. {
    System.err.println("Unrecognized character: " + yytext());
}
