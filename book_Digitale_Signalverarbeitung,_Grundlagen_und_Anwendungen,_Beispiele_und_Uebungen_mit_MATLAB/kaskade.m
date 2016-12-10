function [bBQ, aBQ]=kaskade(b,a,string)      % Version für MATLAB 4.0

% Aufruf: [bBQ, aBQ]=kaskade(b,a)  oder: [bBQ, aBQ]=kaskade(b,a,'z')

%

% b und a sind Vektoren, die die Filterkoeffizienten eines Digitalfilters 

% N-ter Ordnung enthalten.

% b enthaelt die Koeffizienten des Zaehlerpolynoms und a die Koeffizienten des

% Nennerpolynoms, wie sie durch die Approximationsfunktionen berechnet werden.

%

% Die Funktion bestimmt die Koeffizienten der m kaskadierten Biquads, 

% d.h. der rekursiven Filterbloecke 2.Ordnung.

% 

% Beim Aufruf der Funktion in der Form "kaskade(b,a)" werden die

% Pole und Nullstellen korrekt gepaart und in der richtigen Reihenfolge 

% geordnet (siehe Bild 6.55).

% Beim Aufruf in der Form "kaskade(b,a,'z') erfolgen Paarung und Reihenfolge

% zufaellig.

%

% Die Filterkoeffizienten der m Biquads werden in den Matrizen bBQ und aBQ

% abgespeichert. Sie bestehen aus je m Zeilen zu 3 Kolonnen, wobei jede Zeile

% je ein Biquad-Polynom enthaelt. bBQ enthaelt die Zaehler- und aBQ die

% Nennerpolynome.





N=max(length(a)-1,length(b)-1);                 % Ordnung des Digitalfilters



if rem(N,2)~=0; N=N+1; else; end                % Die Ordnung um 1 erh”hen,

                                                % falls sie ungerade ist.

m=N/2;                                          % m ist die Anzahl Biquads



% Die Koeffizientenvektoren b und a muessen die Laenge N+1 haben und sind

% deshalb wenn noetig mit Nullen zu ergaenzen.



akorr=zeros(1,N+1); akorr(1:length(a))=a; a=akorr;

bkorr=zeros(1,N+1); bkorr(1:length(b))=b; b=bkorr;





% Zur Bestimmung der Nullstellen und Pole muss aus Gruenden der

% Eindeutigkeit der erste Koeffizient der b- und a-Koeffizienten 1 sein.

% Deshalb den Faktor S=b(1)/a(1) ausklammern.



S=b(1)/a(1); a=a/a(1); b=b/b(1); 





% Die N Nullstellen und die N Pole des Digitalfilters bestimmen



nullst1=roots(b); pole1=roots(a);





% Die Vektoren nullst1 und pole1 wie folgt ordnen (siehe Bild 6.55):

% 1. Die Pole nach zunehmendem Betrag.

% 2. Die Nullstellen nach kleinstem Abstand zu den sortierten Polen

% Die geordneten Nullstellen und Pole sind in nullst2 und pole2 abzuspeichern.



pole1=cplxpair(pole1); pole2=sort(pole1);       % Mit cplxpair zur Sicherheit

nullst1=cplxpair(nullst1);                      % jeweils vorsortieren

nullst2=zeros(N,1);                             % Initialisieren



for k=N:-1:1

   [Delta, I]=sort(nullst1-pole2(k)); 

   nullst2(k)=nullst1(I(1)); 

   nullst1(I(1))=[];

end





% Die Koeffizienten der m Biquads durch m Polynom-Multiplikationen bestimmen



for k=1:m

   bBQ(k,:)=real(conv([1 -nullst2(2*k-1)],[1 -nullst2(2*k)]));

   aBQ(k,:)=real(conv([1 -pole2(2*k-1)],[1 -pole2(2*k)]));

end





% Bei Wunsch die korrekte Paarung und Reihenfolge in eine zufaellige umwandeln



if nargin == 3

   bBQz=zeros(m,3); aBQz=zeros(m,3);    % Initialisieren

   for k=m:-1:1

      n=ceil(k*rand(1,1)); l=ceil(k*rand(1,1));

      bBQz(k,:)=bBQ(n,:); aBQz(k,:)=aBQ(l,:);

      bBQ(n,:)=[]; aBQ(l,:)=[];

   end

   bBQ=bBQz; aBQ=aBQz;

else

end





% Die einzelnen Biquads muessen derart skaliert werden, dass die

% Teilamplitudengaenge kleiner als 1 bleiben (siehe dazu die 

% Formeln 6.48 und 6.49).



M=4096; bBQ(1,:)=S*bBQ(1,:);     % Die Ausklammerung von S rueckgaengig machen

[H w]=freqz(bBQ(1,:),aBQ(1,:),M);  bBQ(1,:)=bBQ(1,:)/max(abs(H));

bh=bBQ(1,:); ah=aBQ(1,:);

for k=2:1:m

   bh=conv(bh,bBQ(k,:)); ah=conv(ah,aBQ(k,:));

   [H w]=freqz(bh,ah,M); bBQ(k,:)=bBQ(k,:)/max(abs(H));

   bh=bh/max(abs(H));

end





% Die Schlussskalierung resultiert aus der Forderung, dass der Amplitudengang

% des gesuchten Kaskadenfilters gleich dem Amplitudengang des gegebenen 

% Direktstrukturfilters ist.



c=(S/prod(bBQ(1:m,1)))^(1/m); bBQ=c*bBQ;
