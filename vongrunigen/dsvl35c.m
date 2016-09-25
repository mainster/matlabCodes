% M-File  DSVL35c.M      Version für MATLAB 4.0

%

% Loesung zu Kap.3 Aufgabe No.5 c)

%

% Ausgangssignal y(n) mit "conv" und mit "filter" berechnen



clear, close, clc



% Ergebnisvektor y1 berechnen



x=[2 1 0 1 2]; h=[-1 1 2 -1]; y1=conv(x,h), pause





% Ausgangssignalvektor y2 berechnen



x=[x 0 0 0];a=1; b=h; y2=filter(b,a,x), pause





% Diskrete Signale darstellen



n=0:7;

clc,clg,subplot(211), axis([0 7 -3 6]), disploto(n,y1), grid

xlabel('n'), ylabel('y1(n)'), title('Faltung')

subplot(212), axis([0 7 -3 6]), disploto(n,y2), grid

xlabel('n'), ylabel('y2(n)'), title('Auswerten der Differenzengleichung')


