% M-File  DSVL39.M      Version für MATLAB 4.0

%

% Loesung zu Kap.3 Aufgabe No.9

%

% Pole, Nullstellen, Frequenzgang und Impulsantwort zur

% gegebenen Uebertragungsfunktion berechnen und darstellen.

% Differenzengleichung darstellen.



clear, close, clc





% Den Vektoren b und a die Filterkoeffizienten zuweisen



b=[0.862 -1.219 0.862]; a=[1 -1.134 0.604];





% Differenzengleichung darstellen



disp(' '),disp('Differenzengleichung:'),disp(' ')

disp('y(n)=1.134y(n-1)-0.604y(n-2)+0.862x(n)-1.219x(n-1)+0.862x(n-2)')

disp(' '),disp(' ')





% Pole und Nullstellen berechnen und darstellen



pole=roots(a); nullst=roots(b);

disp('Pole und Nullstellen in Polar-Darstellung:')

poles=[abs(pole) angle(pole)*180/pi]

zeroes=[abs(nullst) angle(nullst)*180/pi]

disp(' '),disp(' '),disp('Weiter mit Tastendruck'),pause

pn_plot(pole,nullst)

xlabel('Re(z)'), ylabel('Im(z)')

title('Pol-Nullstellen-Diagramm')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Amplituden- und Phasengang berechnen und darstellen



N=512; fa=400; [H,f]=freqz(b,a,N/2);

f=0:fa/N:fa/2-fa/N;

subplot(2,1,1),semilogy(f,abs(H)),grid

xlabel('Frequenz f in Hz'), ylabel('A(f)')

title('Amplitudengang A(f)')

subplot(2,1,2),plot(f,angle(H)*180/pi),axis([0 200 -100 100])

grid, xlabel('Frequenz f in Hz'), ylabel('Phi in Grad'),

title('Phasengang Phi(f)'), pause





% Impulsantwort berechnen und darstellen



delta=[zeros(1,8) 1 zeros(1,24)];

T=1/fa; t=(-8*T:T:24*T);

h=filter(b,a,delta);

clf, subplot(2,1,1)

disploto(1000*t,h), axis([-20 60 -0.5 1]), grid

xlabel('Zeit t in Millisekunden'), ylabel('h(n)')

title('Impulsantwort h(n)')
