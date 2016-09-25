function cQ=quantcoe(c,B)

% Aufruf: cQ=quantcoe(c,B)

%

% Loesung zu Kap.6 Aufgabe No.10 a)

%

% Die Funktion quantcoe quantisiert die Filterkoeffizienten, die im Vektor c

% gespeichert sind, auf B-1 Bit-Stellen hinter dem Komma. 

% Beispiel fuer B=3:

% Genauer Koeffizient: c=1.351 ;   Quantisierter Koeffizient: cQ=1.25



B=B-1;                          % Wegen fehlendem Vorzeichenbit ist die

                                % Bit-Anzahl B-1 

exp2=(2*ones(1,B)).^(-B:-1);    % Vektor berechnen, der 2er-Potenzen enthaelt

b=zeros(1,B);                   % Bit-Vektor b initialisieren

q=2^(-B);  q2=q/2;              % Quantisierungsstufe q bestimmen



for n=1:length(c)               % Jeden Koeffizienten des 

                                % Koeffizienten-Vektors quantisieren



   cQ(n)=abs(c(n));             % Quantisierung fuer den Betrag durchfuehren 

                                % und am Schluss, wenn noetig, mit -1 multipl.



   if cQ(n) >= 1                % Die ganze Zahl vor dem Komma abspalten

      v=cQ(n)-fix(cQ(n))+q2;    % und in cQ(n) speichern. Am Schluss wird die

   else                         % ganze Zahl vor dem Komma wieder zum

      v=cQ(n)+q2;               % quantisierten Bruch addiert.

   end                          % Der Bruch, d.h. die Zahl nach

   cQ(n)=fix(cQ(n));            % nach dem Komma, wird in v gespeichert.

                                % q/2 wird wegen der Rundung addiert.

 

   for i=1:B                    % Entsprechend v jedem Bit b(i) eine 0 oder

      b(B+1-i)=fix(2*v);        % eine 1 zuordnen.

      v=2*v-fix(2*v);

   end



   cQ(n)=sum(b.*exp2)+cQ(n);    % Aus dem Bit-Vektor den quantisierten Bruch

                                % berechnen und dazu die ganze Zahl vor dem 

                                % Komma wieder addieren.



   if c(n) < 0                  % Den Koeffizienten wieder negativ machen,

      cQ(n)=-cQ(n);             % falls er negativ war.

   else

   end

end
