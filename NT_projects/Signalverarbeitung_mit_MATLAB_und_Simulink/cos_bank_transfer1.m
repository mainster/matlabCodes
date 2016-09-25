% Programm cos_bank_transfer1.m zur Ermittlung der gesamten
% Ü†bertragungsfunktion des Filterbanksystems aus dem
% Modell cos_bank_12.mdl

% ------- Parametrierung des Modells üŸber das 
% Programm cos_bank1.m
cos_bank1;  % Hier werden Figure 1,2,3 erzeugt

% ------- Eingangssequenz
% in Form von Sinuskomponenten mit zufäŠlligen Nullphasen
nN = 2000;
phi = rand(1,nN/2-1)*2*pi;
phi = [0, phi, 0, -phi(nN/2-1:-1:1)];
X = exp(j*phi);

x = real(ifft(X));   
xi = imag(ifft(X));
xt = [x,x];

% ------- Eingangssequenz füŸr das Modell 
simin = [((0:length(xt)-1)*Ts)',xt']; 

% ------- Aufruf der Simulation
sim('cos_bank_12',[((0:length(xt)-1)*Ts)']);
y = squeeze(simout)'; 

% ------- Ermittlung der †bertragungsfunktion
%X = fft(x);             % FFT des Eingangs (zweiter Teil)
y = y(nN+1:1:2*nN);      % Ausgang ohne Einschwingsteil
Y = fft(y); % FFT des Ausgangs (zweiter Teil)

Ht = Y./X;  % Gesamte Ü†bertrgaungsfunktion

figure(4);    clf;
subplot(211), plot((0:length(Ht)-1)/length(Ht), 20*log10(abs(Ht)));
title('Gemessener Amplitudengang des Filterbanksystems (der "Distortion Function")'); 
xlabel('f/fs');    grid;
ylabel('dB');

% Gemessene Einheitspulsantwort
ht = real(ifft(Ht));
nt = 0:2*L-1;
subplot(212), stem(nt, ht(nt+1));
title('Gemessene Einheitspulsantwort des Filterbanksystems (der "Distortion Function")'); 
xlabel('n');     grid;
La = axis;     axis([La(1), max(nt), La(3:4)]);

