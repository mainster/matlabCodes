function yrausch=rauschbq(b,a,B,N)      % Version für MATLAB 4.0

% Aufruf: yrausch=rauschbq(b,a,B,N)

%

% Loesung zu Kap.6 Aufgabe No.10 c)

%

% Diese Funktion simuliert das Rauschen, das durch das Abschneiden von

% Multiplikationsergebnissen auf B Stellen am Ausgang eines Digitalfilters

% entsteht. Das digitale Filter ist ein Biquad (rekursives Digitalfilter

% 2.Ordnung) in transponierter Direktstruktur 2.

%

% b und a - beides Vektoren der Laenge 3 - enthalten die Zaehlerpolynom-

% und Nennerpolynom-Koeffizienten des Digitalfilters 2.Ordnung.

% B ist die Wortlaenge des quantisierten Multiplikationsergebnisses und

% N ist die Laenge der generierten Rauschsequenz yrausch.





% Gleichverteiltes Rauschen im Bereich 0 ... -q erzeugen

% und entsprechend dem Ergebnis von Aufgabe 10 b) filtern.



q=2^(-B+1);

e1=-q*rand(1,N); e2=-q*rand(1,N); e3=-q*rand(1,N); 

yrausch=filter([0 0 1],a,e1)+filter([0 1 0],a,e2)+filter([1 0 0],a,e3);
