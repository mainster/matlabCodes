% M-File  DSVL47.M      Version für MATLAB 4.0

%

% Loesung zu Kap.4 Aufgabe No.7

%

% Die Ueberlagerung von 2 Cosinus-Schwingungen mit den

% Scheitelwerten 1 und den Frequenzen f1 und f2

% im Bereich von 250 Hz generieren und darstellen.

% Die Anzahl Abtastwerte N kann als Zweierpotenz

% frei gewaehlt werden.

% Die Abtastfrequenz fa betraegt 2000Hz.

% Das Signal, bestehend aus den beiden Cosinus-Schwingungen,

% wird Rechteck-gefenstert (also unveraendert gelassen)

% und Hanning-gefenstert.

% Anschliessend werden die dazugehoerigen Betragsspektren

% berechnet und im Nyquistbereich dargestellt.



clear, close, clc



% Die beiden Frequenzen und die Anzahl Abtastwerte eingeben



disp(' '),disp(' ')

disp('Geben Sie zwei Frequenzen im Bereich von 250Hz ein')

f1=input('Erste Frequenz f1 in Hz eingeben  ')

f2=input('Zweite Frequenz f2 in Hz eingeben  ')

disp('Die Abtastfrequenz fa betraegt 2 kHz')

disp(' '),disp(' ')

disp('Geben Sie die Anzahl Abtastpunkte N ein, wobei')

disp('N folgende Werte annehmen darf: 8, 16, 32, ... ,4096')

N=input('N=  ')





% Das Rechteck-gefensterte und das Hanning-gefensterte Signal

% generieren und darstellen



T=0.5e-3; fa=2e3; 

t=0:T:(N-1)*T; x=cos(2*pi*f1*t)+cos(2*pi*f2*t); 

xR=x'; xH=x'.*hanning(N);

subplot(2,1,1),plot(1e3*t,xR),axis([0 1e3*N*T -2.5 2.5]),grid

xlabel('t   [ms]'),ylabel('xR(n)'),title('Signal mit Rechteckfenster')

subplot(2,1,2),plot(1e3*t,xH),axis([0 1e3*N*T -2.5 2.5]),grid

xlabel('t   [ms]'),ylabel('xH(n)')

title('Signal mit Hanningfenster')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Spektrum mit Rechteckfenster



f=0:fa/N:0.5*fa; XR=(2/N)*abs(fft(xR)); XR=XR(1:N/2+1);

clf,subplot(2,1,1),displot(f,XR),axis([0 1000 -0.2 1.2]),grid

xlabel('f  [Hz]'),ylabel('(2/N)*abs(XR(k))')

title('Betragsspektrum im Nyquistbereich mit Rechteck-Fenster')





% Spektrum mit Hanning-Fenster



XH=(2/N)*abs(fft(xH)); XH=XH(1:N/2+1);

subplot(2,1,2),displot(f,XH),axis([0 1000 -0.2 1.2]),grid

xlabel('f  [Hz]'),ylabel('(2/N)*abs(XH(k))')

title('Betragsspektrum im Nyquistbereich mit Hanning-Fenster')
