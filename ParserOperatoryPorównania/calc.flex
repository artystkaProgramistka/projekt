%%
%cup
%public
%class Lexer
%implements java_cup.runtime.Scanner
%unicode
%line
%column

/* Definicje */
digit       = [0-9]
letter      = [a-zA-Z]
identifier  = {letter}({letter}|{digit})*

%%

/* Reguły */

/* Ignoruj białe znaki */
[ \t\n\r]+ { /* ignoruj */ }

/* Liczby z opcjonalnym miejscem dziesiętnym i sufiksami SI */
{digit}+(\.{digit}+)?[mMkG]? {
    String text = yytext();
    double val;

    /* Sprawdź sufiks SI */
    if (text.endsWith("m")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 0.001;
    } else if (text.endsWith("k")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 1000;
    } else if (text.endsWith("M")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 1_000_000;
    } else if (text.endsWith("G")) {
        val = Double.parseDouble(text.substring(0, text.length() - 1)) * 1_000_000_000;
    } else {
        /* Bez sufiksu */
        val = Double.parseDouble(text);
    }

    return new java_cup.runtime.Symbol(sym.NUMBER, val);
}

/* "pi" i "e" jako stałe liczbowe */
"pi" { return new java_cup.runtime.Symbol(sym.NUMBER, Math.PI); }
"e"  { return new java_cup.runtime.Symbol(sym.NUMBER, Math.E);  }

/* Nawiasy */
"("  { return new java_cup.runtime.Symbol(sym.LPAREN); }
")"  { return new java_cup.runtime.Symbol(sym.RPAREN); }

/* Operator potęgowania */
"**" { return new java_cup.runtime.Symbol(sym.EXP); }

/* Operator procenta */
"%"  { return new java_cup.runtime.Symbol(sym.PERCENT); }

/* Mnożenie i dzielenie */
"*"  { return new java_cup.runtime.Symbol(sym.MUL);   }
"/"  { return new java_cup.runtime.Symbol(sym.DIV);   }

/* Dodawanie i odejmowanie */
"+"  { return new java_cup.runtime.Symbol(sym.PLUS);  }
"-"  { return new java_cup.runtime.Symbol(sym.MINUS); }

/* Funkcja avg */
"avg" { return new java_cup.runtime.Symbol(sym.avg); }

/* Przecinek dla oddzielania argumentów w avg() */
","  { return new java_cup.runtime.Symbol(sym.COMMA); }

/* Conditional keywords */
"if"   { return new java_cup.runtime.Symbol(sym.IF_TOK); }
"else" { return new java_cup.runtime.Symbol(sym.ELSE_TOK); }

/* Logical operators */
"<"   { return new java_cup.runtime.Symbol(sym.LT); }
">"   { return new java_cup.runtime.Symbol(sym.GT); }
"="   { return new java_cup.runtime.Symbol(sym.EQ); }

/* Obsługa nieznanych znaków */
. { 
    System.err.println("Nieznany znak: " + yytext()); 
}

