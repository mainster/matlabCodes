% M-File  DSV122.M      Version für MATLAB 4.0

%

% Bild 1.5 zu DSV Kap. 1.2.2

%

% Sinusstrom darstellen und Spektrum dazu berechnen



clear, close, clc



N=1024;				% N: Anzahl Abtastwerte



% Zeitvektor t berechnen    	Te: Endzeit,   T: Abtastintervall

Te=0.08; T=Te/N;  t=0:T:Te-T;



% 25%-angeschnittener Sinusstrom berechnen

i=sin(2*pi*50*t).*((1-square(2*pi*100*t,25))/2);



% Sinusstrom darstellen,   Zeitachse in ms geeicht

subplot(2,1,1),plot(1000*t,i),axis([0 80 -1.5 1.5]),grid

xlabel('t   [ms]'), ylabel('i(t)  [A]')

title('Angeschnittener Sinusstrom')

set(gcf,'Units','normal','Position',[0 0 1 1])



% Betrag der DFT berechnen    

% 	k: Faktor zur Eichung des Spektrums in Aeff

%	   (siehe Kap.4.7.2 Beispiel 3)

k=sqrt(2)/N; I=k*abs(fft(i));



% Spektrum im Bereich von 0 bis fe darstellen,   fa: Abtastfrequenz

fa=1/T; fe=2000;  f=0:fa/N:fe; I=I(1:length(f));

subplot(2,1,2),bar(f,I),axis([0 fe -0.1 1]),grid

xlabel('f   [Hz]'), ylabel('|I(f)|   [Aeff]')

title('Spektrum des angeschnittenen Sinusstroms')
