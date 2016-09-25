% M-File DSV531.M

%  

% Bild 5.6 zu Kap.5.3.1      Version für MATLAB 4.0



clear, close, clc



% Die Signale x(n) und h(n) erzeugen und zeichnen



x(1001)=0; t=0:.1e-3:19.9e-3; x1=sin(2*pi*312.5*t); x(101:300)=x1;

h(401)=.5; h(501)=.2;h(801)=.3;h(951)=.1;h(1001)=0;

t=0:.1e-3:100e-3;

subplot(2,1,1),displot(1000*t,h),axis([0 100 -.5 1]),grid

xlabel('t   [ms]'), ylabel('h(t)')

set(gcf,'Units','normal','Position',[0 0 1 1])

title('Impulsantwort einer Multipfad-Uebertragungsstrecke')

subplot(2,1,2),plot(1000*t,x),axis([0 100 -1.5 1.5]),grid

xlabel('t   [ms]'), ylabel('x(t)')

title('Sinuszug als Eingangssignal'), pause





% Die Faltung von x(n) und h(n) berechnen und darstellen

%

tau=0:.1e-3:200e-3; y=conv(x,h);

subplot(2,1,1),displot(1000*t,h),axis([0 100 -.5 1]),grid

xlabel('t   [ms]'), ylabel('h(t)')

title('Impulsantwort der Multipfad-Uebertragungsstrecke')



subplot(2,1,2),plot(1000*tau,y),axis([0 200 -1 1]),grid

xlabel('t   [ms]'), ylabel('y(t)')

title('Faltung der Impulsantwort mit dem Sinuszug')
