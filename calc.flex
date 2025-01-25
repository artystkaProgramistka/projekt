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

/* Numbers with optional decimal, and optional SI suffix */
[0-9]+(\.[0-9]+)?[mMkG]? {
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

    return new java_cup.runtime.Symbol(sym.NUMBER, val);
}

/* "pi" and "e" as numeric constants */
"pi" { return new java_cup.runtime.Symbol(sym.NUMBER, Math.PI); }
"e"  { return new java_cup.runtime.Symbol(sym.NUMBER, Math.E);  }

/* Parentheses */
"("  { return new java_cup.runtime.Symbol(sym.LPAREN); }
")"  { return new java_cup.runtime.Symbol(sym.RPAREN); }

/* Exponentiation operator */
"**" { return new java_cup.runtime.Symbol(sym.EXP); }

/* Percent operator */
"%"  { return new java_cup.runtime.Symbol(sym.PERCENT); }

/* Multiplication and division */
"*"  { return new java_cup.runtime.Symbol(sym.MUL);   }
"/"  { return new java_cup.runtime.Symbol(sym.DIV);   }

/* Addition and subtraction */
"+"  { return new java_cup.runtime.Symbol(sym.PLUS);  }
"-"  { return new java_cup.runtime.Symbol(sym.MINUS); }

/*
   No <<EOF>> rule — our .cup grammar doesn't require EOF.
*/
