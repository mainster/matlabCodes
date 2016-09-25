% M-File  DSVL32c.M      Version für MATLAB 4.0

%

% Loesung zu Kap.3 Aufgabe No.2 c)

%

% Differenzengleichung auswerten



clear, close, clc





% Diskreter Zeitvektor n 

% und diskreter Eingangssignalvektor x berechnen



n=0:50; u=[zeros(1,10) ones(1,41)];

x=sin((2*pi/8)*(n-10)).*u;





% Diskreter Ausgangssignalvektor y berechnen



a=[1 -0.88]; b=[1 0 2.3]; y=filter(b,a,x);





% Ausgangssignalvektor y darstellen und 

% die ersten 14 Abtastwerte drucken



subplot(2,1,1), disploto(n,y), axis([0 50 -4 8]), grid

xlabel('n'), ylabel('y(n)')

title('Differenzengleichung auswerten')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause

set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])

y14A=y(1:14)
