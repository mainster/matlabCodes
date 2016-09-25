% M-File  DSV132.M

%

% Bild 1.5 zu DSV Kap. 1.3.2

%

% Sinusstrom darstellen und Spektrum dazu berechnen



N=1024;				% N: Anzahl Abtastwerte



% Zeitvektor t berechnen    	Te: Endzeit,   T: Abtastintervall

Te=0.08; T=Te/N;  t=0:T:Te-T;



% 25%-angeschnittener Sinusstrom berechnen

i=sin(2*pi*50*t).*((1-square(2*pi*100*t,25))/2);



% Sinusstrom darstellen,   Zeitachse in ms geeicht

clc,clg,subplot(211),axis([0 80 -1.5 1.5]),plot(1000*t,i),grid

xlabel('t   [ms]'), ylabel('i(t)  [A]')

title('Angeschnittener Sinusstrom')



% Betrag der DFT berechnen    

% 	k: Faktor zur Eichung des Spektrums in Aeff

%	   (siehe Kap.4.7.2 Beispiel 3)

k=sqrt(2)/N; I=k*abs(fft(i));



% Spektrum im Bereich von 0 bis fe darstellen,   fa: Abtastfrequenz

fa=1/T; fe=2000;  f=0:fa/N:fe; I=I(1:length(f));

subplot(212),axis([0 fe -0.1 1]),bar(f,I),grid

xlabel('f   [Hz]'), ylabel('I(f)   [Aeff]')

title('Spektrum des angeschnittenen Sinusstroms')
