import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) {
        try {
            Lexer lexer = new Lexer(new InputStreamReader(System.in));
            parser p = new parser(lexer);
            
            /* Parsujemy wyrażenie i uzyskujemy wynik */
            Double result = (Double) p.parse().value;
            
            /* Wynik pojawia się w nowej linii */
            System.out.println();
            System.out.printf("%.2f\n", result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

