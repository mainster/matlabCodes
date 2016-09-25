% Programm G722_1.m zur Untersuchung einer 
% Zweikanalfilterbank, die der Empfehlung G.722 entspricht
% Initialisiert und ruft das Modell G7221.mdl oder G7222.mdl auf

clear

% --------- Allgemeine Parameter
fs = 16000;    % Abtastfrequenz
Ts = 1/fs;

% --------- Tiefpass QMF-Filter
L = 24;
h0 =zeros(1,L);
h0(1:L/2) = [0.366211e-3, -0.134277e-2, -0.134277e-2, 0.646973e-2, 0.146484e-2,...
        -0.190430e-1, 0.390625e-2, 0.441895e-1, -0.256348e-1, -0.982666e-1,...
        0.116089, 0.473145];
h0(L/2+1:L) = h0(L/2:-1:1);

%h0 = [3 -11 -11 53 12 -156 32 362 -210 -805 951 3876 ...
%       3876 951 -805 -210 362 32 -156 12 53 -11 -11 3]/(2^13);

% --------- Filter der Filterbank
L = 24;
h1=(-1).^(0:L-1).*h0;
g0 = h0;                   g1 = fliplr(h1);

% --------- Einheitspulsantwort des Systems
t = conv(h0, g0) + conv(h1, g1);

% --------- Frequenzgänge der Filter
nfft = 1024;
H0 = fft(h0,nfft);   H1 = fft(h1,nfft);
G0 = fft(g0,nfft);   G1 = fft(g1,nfft);

figure(1);   clf;
subplot(321), stem(0:L-1, h0);
title('Einheitspulsantwort des Tiefpassfilters H0(z)');
xlabel('n');   grid;
pos = get(gca, 'Position');
set(gca,'Position', [pos(1:3), pos(4)*0.85]);

subplot(323), stem(0:L-1, h1);
title('Einheitspulsantwort des Hochpassfilters H1(z)');
xlabel('n');   grid;
pos = get(gca, 'Position');
set(gca,'Position', [pos(1:3), pos(4)*0.85]);

subplot(325), stem(0:length(t)-1, t);
title('Einheitspulsantwort des Systems');
xlabel('n');   grid;
pos = get(gca, 'Position');
set(gca,'Position', [pos(1:3), pos(4)*0.85]);

subplot(222), plot((0:nfft-1)/nfft, [(abs(H0))', (abs(H1))']);
hold on;
plot((0:nfft-1)/nfft, abs((H0.*G0)+(H1.*G1)));
hold off;
La = axis;    axis([La(1:3), 1.2]);
title('H0, H1, |H0*G0+H1*G1|');    grid;
xlabel('f/fs');

subplot(224), plot((0:nfft-1)/nfft, [(abs(H0))', (abs(H1))']);
hold on;
plot((0:nfft-1)/nfft, abs((H0.*G0)+(H1.*G1)));
hold off;
La = axis;    axis([La(1:2), 0.99 1.01]);
title('H0, H1, |H0*G0+H1*G1| (Ausschnitt)');    grid;
xlabel('f/fs');

% --------- Einheitspulsantwort des Systems
t = conv(h0, g0) + conv(h1, g1);

% --------- Aufruf der Simulation
%sim('G7221',[0,2]);
% oder
sim('G7222', [0,2]);
