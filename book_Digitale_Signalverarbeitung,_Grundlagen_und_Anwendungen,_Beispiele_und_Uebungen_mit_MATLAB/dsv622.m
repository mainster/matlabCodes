% M-File DSV622.M      Version für MATLAB 4.0

%

% Bilder 6.12 bis 6.20

%

% Koeffizienten eines TP-FIR-Filters einlesen, printen

% und sie als Impulsantwort darstellen.

% Aus diesen Koeffizienten die Pole und Nullstellen berechnen

% und das PN-Diagramm darstellen.

% Amplitudengang, Phasengang und Gruppenlaufzeit berechnen und darstellen.

% Symmetrischen Rechteckpuls generieren und filtern.

% Betragsspektrum des Rechteckpulses berechnen und darstellen.

% Betrags- und Phasenspektrum des gefilterten Rechteckpulses 

% berechnen und darstellen.

%

% Abtastfrequenz=10kHz ==> Achseneinheiten in kHz und ms



clear, close, clc



% Koeffizienten eines TP-FIR-Filters einlesen und darstellen.

% (Die Koeffizienten wurden mit dem DSV-Programm DFDP [43] berechnet

% und in ein File mit der Extension flt abgespeichert. 

% Anschliessend wurden sie mit der MATLAB-Funktion DFDP2MAT geladen 

% und mit dem Befehl "save dsv622 b" zu einem MAT-File konvertiert.)



load dsv622, b, pause





% Impulsantwort darstellen



bext=[zeros(1,10) b zeros(1,9)]; t=-1:.1:3;

subplot(2,1,1), disploto(t,bext), axis([-1 3 -.1 .4]), grid

xlabel('t   [ms]'), ylabel('h(n)')

title('Impulsantwort des nichtrekursiven Digitalfilters')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Pole und Nullstellen berechnen und darstellen



p=0+j*0; z=roots(b);

clf, pn_plot(p,z)

xlabel('Re(z)'), ylabel('Im(z)')

title('Pol- Nullstellen-Diagramm des nichtrekursiven Digitalfilters'), pause





% Amplitudengang berechnen und darstellen



[H,w]=freqz(b,1,512); f=w*5/pi;

subplot(2,1,1), semilogy(f,abs(H)), axis([0 5 1e-4 1e1]), grid

xlabel('f   [kHz]'), ylabel('A(f)')

title('Amplitudengang des nichtrekursiven Digitalfilters')





% Phasengang berechnen und darstellen



subplot(2,1,2), plot(f,unwrap(angle(H))*180/pi), axis([0 5 -1200 200]), grid

xlabel('f   [kHz]'), ylabel('Phi(f)   [Grad]')

title('Phasengang des nichtrekursiven Digitalfilters'), pause

clf, subplot(2,1,1), plot(f,unwrap(angle(H))*180/pi)

axis([0 5 -1200 200]), grid

xlabel('f   [kHz]'), ylabel('Phi(f)   [Grad]')

title('Phasengang des nichtrekursiven Digitalfilters')





% Gruppenlaufzeit berechnen und darstellen



subplot(2,1,2), plot(f,0.1*grpdelay(b,1,512)), axis([0 5 -0.5 1.5]), grid

xlabel('f   [kHz]'), ylabel('taug(f)   [ms]')

title('Gruppenlaufzeit des nichtrekursiven Digitalfilters'), pause





% Doppel-Rechteckpuls generieren und filtern



x=[zeros(1,10) ones(1,10) -ones(1,10) zeros(1,21)]; t=-1:.1:4;

clf, subplot(2,1,1), disploto(t,x), axis([-1 4 -1.5 1.5]), grid

xlabel('t   [ms]'), ylabel('x(n)')

title('Zeitdiskreter Doppel-Rechteckpuls als Eingangssignal')

y=filter(b,1,x);

subplot(2,1,2), disploto(t,y), axis([-1 4 -1.5 1.5]), grid

xlabel('t   [ms]'), ylabel('y(n)')

title('Gefilterter, zeitdiskreter Doppel-Rechteckpuls'), pause





% Betragsspektrum des Doppel-Rechteckpulses berechnen und darstellen



Y=fft(x(11:30),1024); Betrag=abs(Y(1:513)); f=0:5/512:5;

clf, subplot(2,1,1), plot(f,Betrag), axis([0 5 -2 17]), grid

xlabel('f   [kHz]'), ylabel('|X(f)|')

title('Betragsspektrum des zeitdiskreten Doppel-Rechteckpulses')





% Phasenspektrum des Doppel-Rechteckpulses berechnen und darstellen



Phase=(180/pi)*unwrap(angle(Y(1:513)));

subplot(2,1,2), plot(f,Phase), grid

xlabel('f   [kHz]'), ylabel('arg[X(f)]')

title('Phasenspektrum des zeitdiskreten Doppel-Rechteckpulses'), pause





% Betragsspektrum des gefilterten Doppel-Rechteckpulses berechnen und darstellen



y=filter(b,1,[x(11:30) zeros(1,50)]);

Y=fft(y,1024);,Betrag=abs(Y(1:513));

clf, subplot(2,1,1), plot(f,Betrag), axis([0 5 -2 17]), grid

xlabel('f   [kHz]'), ylabel('|Y(f)|')

title('Betragsspektrum des gefilterten, zeitdiskreten Doppel-Rechteckpulses')





% Phasenspektrum des gefilterten Rechteckpulses berechnen und darstellen



Phase=(180/pi)*unwrap(angle(Y(1:513)));

subplot(2,1,2), plot(f,Phase), axis([0 5 -3000 1000]), grid

xlabel('f   [kHz]'), ylabel('arg[Y(f)]   [Grad]')

title('Phasenspektrum des gefilterten, zeitdiskreten Doppel-Rechteckpulses')


