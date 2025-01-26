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
hex_digit   = [0-9A-Fa-f]
letter      = [a-zA-Z]

/* Definicja trybów */
%x HEX

%%

/* Reguły w trybie DEFAULT */

<DEFAULT> {

    /* Ignoruj białe znaki */
    [ \t\n\r]+ { /* ignoruj */ }

    /* Początek trybu HEX */
    "{" { push_mode(HEX); return new java_cup.runtime.Symbol(sym.LBRACE); }

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

    /* Nawiasy okrągłe */
    "("  { return new java_cup.runtime.Symbol(sym.LPAREN); }
    ")"  { return new java_cup.runtime.Symbol(sym.RPAREN); }

    /* Operator potęgowania */
    "**" { return new java_cup.runtime.Symbol(sym.EXP); }

    /* Operator procenta */
    "%"  { return new java_cup.runtime.Symbol(sym.PERCENT); }

    /* Mnożenie i dzielenie */
    "*"  { return new java_cup.runtime.Symbol(sym.MUL); }
    "/"  { return new java_cup.runtime.Symbol(sym.DIV); }

    /* Dodawanie i odejmowanie */
    "+"  { return new java_cup.runtime.Symbol(sym.PLUS); }
    "-"  { return new java_cup.runtime.Symbol(sym.MINUS); }

    /* Funkcja avg */
    "avg" { return new java_cup.runtime.Symbol(sym.avg); }

    /* Przecinek dla oddzielania argumentów w avg() */
    ","  { return new java_cup.runtime.Symbol(sym.COMMA); }

    /* Obsługa nieznanych znaków */
    . { 
        System.err.println("Nieznany znak: " + yytext()); 
    }
}

/* Reguły w trybie HEX */

<HEX> {

    /* Liczby szesnastkowe z opcjonalnym miejscem dziesiętnym i sufiksami SI */
    {hex_digit}+(\.{hex_digit}+)?[mMkG]? {
        String text = yytext();
        double val;

        /* Zamiana na duże litery dla spójności */
        text = text.toUpperCase();

        /* Usunięcie sufiksów SI */
        String numberPart = text;
        if (text.endsWith("M") || text.endsWith("G") || text.endsWith("K") || text.endsWith("m") || text.endsWith("k")) {
            numberPart = text.substring(0, text.length() - 1);
        }

        /* Zamiana na wartość dziesiętną */
        try {
            if (text.contains(".")) {
                /* Obsługa liczb zmiennoprzecinkowych w szesnastkowym */
                String[] parts = numberPart.split("\\.");
                long intPart = Long.parseLong(parts[0], 16);
                double fracPart = 0.0;
                for (int i = 0; i < parts[1].length(); i++) {
                    fracPart += Character.digit(parts[1].charAt(i), 16) / Math.pow(16, i + 1);
                }
                val = intPart + fracPart;
            } else {
                val = Long.parseLong(numberPart, 16);
            }

            /* Zastosowanie sufiksów SI */
            if (text.endsWith("m")) {
                val *= 0.001;
            } else if (text.endsWith("k")) {
                val *= 1000;
            } else if (text.endsWith("M")) {
                val *= 1_000_000;
            } else if (text.endsWith("G")) {
                val *= 1_000_000_000;
            }
        } catch (NumberFormatException e) {
            System.err.println("Błąd parsowania liczby szesnastkowej: " + yytext());
            val = 0.0;
        }

        return new java_cup.runtime.Symbol(sym.NUMBER, val);
    }

    /* Zamknięcie trybu HEX */
    "}"  { pop_mode(); return new java_cup.runtime.Symbol(sym.RBRACE); }

    /* Obsługa nieznanych znaków w HEX */
    . { 
        System.err.println("Nieznany znak w HEX: " + yytext()); 
    }
}

