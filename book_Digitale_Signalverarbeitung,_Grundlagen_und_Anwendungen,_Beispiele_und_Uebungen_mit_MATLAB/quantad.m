function xQ=quantad(x,B)

% Aufruf: xQ=quantad(x,B)

%

% Loesung zu Kap.6 Aufgabe No.8 b)

%

% Die Funktion quantad simuliert den Quantisierer eines AD-Umsetzers

% mit einer Wortlaenge B und einem Aussteuerbereich von +-1.

% x ist der Eingangsvektor (Eingangssequenz)

% und xQ der quantisierte Ausgangsvektor (Ausgangssequenz).



exp2=(2*ones(1,B)).^(-B+1:0);   % Vektor berechnen, der 2er-Potenzen enthaelt

b=zeros(1,B);                   % Bit-Vektor b initialisieren

q=2^(-B+1); q2=q/2;             % Quantisierungsstufe q bestimmen

xQ=zeros(1,length(x));          % xQ initialisieren





for n=1:length(x)               % Jeden Abtastwert der Sequenz quantisieren



   if x(n) > 1-q                % Ueberpruefen, ob der Abtastwert in der 

      xQ(n)=1-q;                % Saettigung ist. Wenn ja, dann dem quanti= 

   elseif x(n) < -1             % sierten Wert xQ(n) den Saettigungswert

      xQ(n)=-1;                 % zuordnen.

   else



      xQ(n)=x(n)+q2;            % Da es sich um eine Rundungskennlinie 

                                % handelt, wird zuerst q/2 addiert.

      if xQ(n) < 0              % Wenn der Abtastwert negativ ist, dann 

         v=xQ(n)+1; b(B)=-1;    % dem MSB b(B) (Most Significant Bit) den 

      else                      % Wert 1 zuordnen und mit -1 multiplizieren.

         v=xQ(n); b(B)=0;       % In v wird der korrigierte Abtastwert

      end                       % gespeichert.



      for i=1:B-1               % Jedem Bit b(i) eine 0 oder eine 1

         b(B-i)=fix(2*v);       % zuordnen, je nachdem welchen Wert dass

         v=2*v-fix(2*v);        % v hat.

      end 





      xQ(n)=sum(b.*exp2);       % Aus dem Bit-Vektor b kann nun der quan-

                                % tisierte Abtastwert xQ(n) bestimmt werden.

   end



end
