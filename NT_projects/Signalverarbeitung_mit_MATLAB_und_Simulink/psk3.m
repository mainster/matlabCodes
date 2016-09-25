% Programm psk3.m zur Parametrierung des Modells
% psk_3.mdl, in dem eine 4PSK-Modulation und Demodulation
% simuliert wird.
% Die Demodulation wird mit Dezimierung üŸber Bölšcke FIR-
% Decimation realisiert

% -------- Parameter 
fs = 10000;      Ts = 1/fs;
fc = 2000;    % Mittefrequenz BP
theta = pi/3;

% -------- TP-Prototypfilter
nf = 256;        
M = 10;
ftp = 1/(2*M);
h0 = fir1(nf, 2*ftp);

figure(1),   clf;
subplot(211), stem(0:nf, h0);
title('Einheitspulsantwort des Prototyp-TP');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

nfft = 1024;
H0 = fft(h0, nfft);
subplot(212), plot((0:nfft-1)/nfft, 20*log10(abs(H0)));
title('Amplitudengang des Prototyp-TP');
xlabel('f/fs');   grid;

% ------- Aufruf der Simulation
sim('psk_3',[0,1]);