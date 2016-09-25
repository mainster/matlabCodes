% Programm psk1.m zur Parametrierung des Modells
% psk_1.mdl, in dem eine 4PSK-Modulation und Demodulation
% simuliert wird

% -------- Parameter
fs = 10000;      Ts = 1/fs;
fc = 2000;    % Mittefrequenz BP

% -------- TP-Prototypfilter 
nf = 256;        ftp = 0.05;
h0 = fir1(nf, 2*ftp);

% -------- Eigenschaften des TP-Prototyps 
figure(1),   clf;
subplot(211), stem(0:nf, h0);
title('Einheitspulsantwort des TP-Prototyps');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

nfft = 1024;
H0 = fft(h0, nfft);
subplot(212), plot((0:nfft-1)/nfft, 20*log10(abs(H0)));
title('Amplitudengang des TP-Prototyps');
xlabel('f/fs');   grid;


% -------- Aufruf der Simulation
sim('psk_1',[0,1]);
