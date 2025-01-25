%%
%cup
%public
%class Lexer
%unicode
%line
%column

%%
/* Ignore whitespace */
[ \t\n\r]+ { /* ignore */ }

/* Numbers with optional decimal */
[0-9]+(\.[0-9]+)? {
  double val = Double.parseDouble(yytext());
  return new java_cup.runtime.Symbol(sym.NUMBER, val);
}

/* "pi" and "e" as numeric constants */
"pi" { return new java_cup.runtime.Symbol(sym.NUMBER, Math.PI); }
"e"  { return new java_cup.runtime.Symbol(sym.NUMBER, Math.E);  }

/* Parentheses */
"("  { return new java_cup.runtime.Symbol(sym.LPAREN); }
")"  { return new java_cup.runtime.Symbol(sym.RPAREN); }

/* Operators */
"*"  { return new java_cup.runtime.Symbol(sym.MUL);   }
"/"  { return new java_cup.runtime.Symbol(sym.DIV);   }
"+"  { return new java_cup.runtime.Symbol(sym.PLUS);  }
"-"  { return new java_cup.runtime.Symbol(sym.MINUS); }

/*
   No <<EOF>> rule — our .cup grammar doesn't require EOF.
*/
