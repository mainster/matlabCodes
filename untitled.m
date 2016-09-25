% In diesem M-File wird eine sogenannte Huetchenfunktion abschnittsweise
% definiert. Dazu verwenden wir logische Operatoren.
% Wir definieren eine abschnittsweise definierte Huetchenfunktion f mit
% Hilfe von logischen Operatoren
f = @(x) (((x - 2) .* and((x >= 2),(x <= 3))) + ((4 - x) .* and((x >= 3),(x <= 4))));
% Um zu schauen, ob wir alles richtig gemacht haben, plotten wir die
% Funktion. Dazu verwenden wir ezplot. ezplot ist ein sehr einfacher Befehl
% um Funktionen zu plotten. Wir geben in Klammern die Funktion an
% (und wenn gewuenscht die Intervallgrenzen a und b ueber die die
% Funktion geplottet werden soll).
% ezplot(funktion,[a,b])
