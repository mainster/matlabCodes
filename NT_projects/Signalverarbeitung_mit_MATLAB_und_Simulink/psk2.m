% Programm psk2.m zur Parametrierung des Modells
% psk_2.mdl, in dem eine 4PSK-Modulation und Demodulation
% simuliert wird
% Die Demodulation wird mit Polyphasenfiltern und Dezimierung 
% realisiert

% -------- Parameter 
fs = 10000;      Ts = 1/fs;
fc = 2000;    % Mittefrequenz BP

% -------- TP-Prototypfilter
nf = 256;        ftp = 0.05;
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

% -------- Zerlegung von h0 in Polyphasenfiltern
M = 10;      % Dezimierungsfaktor
h = h0;      % Einheitspulsantwort des TP-Prototyps
rn = rem(nf+1,M);   
if rn == 0
    g = zeros(M, nf/M);  % nf ein Vielfaches von M
else
    g = zeros(M, fix(nf/M)+1); % Filterlänge zu einem
    h = [h, zeros(1,M-rn)]; % Vielfach von M erweitert
end;
 
for k = 1:M
    g(k,:) = h(k:M:end); % Teilfilter des Polyphasen-
end;                     % filters
gt = g';
ng = length(g);

% ------- Aufruf der Simulation
sim('psk_2',[0,1]);

