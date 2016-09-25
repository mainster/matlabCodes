% M-File  DSVL33a.M      Version für MATLAB 4.0

%

% Loesung zu Kap.3 Aufgabe No.3 a)

%

% Impulsantwort h(n) berechnen und darstellen



clear, close, clc





% Diskreter Zeitvektor n 

% und diskreter Einheitspulsvektor delta berechnen



n=-10:40; delta=[zeros(1,10) 1 zeros(1,40)];





% Diskreter Ausgangssignalvektor h berechnen



a=[1 -0.88]; b=[1 0 2.3]; h=filter(b,a,delta);





% Impulsantwort h(n) darstellen



subplot(2,1,1), disploto(n,h), axis([-10 40 -4 8]), grid

xlabel('n'), ylabel('h(n)')

title('Impulsantwort h(n)')

set(gcf,'Units','normal','Position',[0 0 1 1])
