% Programm audio_test1.m in dem eine Zerlegung und Rekonstruktion des
% Hochpassanteils einer Zweikanal-Filterbank untersucht wird
% Initialisiert und ruft auf auch das Modell audio_test_1.mdl


% -------- Signal aus zwei Komponenten
fs = 10000;     Ts = 1/fs;
f1 = 250;       f2 = 4500;
a1 = 2;         a2 = 3;
tfinal = 3;
t = 0:Ts:tfinal;     
x = a1*sin(2*pi*f1*t) + a2*cos(2*pi*f2*t+pi/3);

% ------- Filter der Zerlegung
L = 64;         % Anzahl Koeffizienten
[htp, han, gsy] = unicmfb(2,L,1/32,1,4*L,0,0);

h0 = han(:,1);    h1 = han(:,2);
g0 = gsy(:,1);    g1 = gsy(:,2);

h0t = h0';     h1t = h1';    g0t = g0';     g1t = g1';

% ------- Frequenzgänge der Filter
nfft = 1024;
H0 = fft(h0, nfft);     H1 = fft(h1, nfft);
G0 = fft(g0, nfft);     G1 = fft(g1, nfft);

P = abs(H0.*G0 + H1.*G1);

figure(1);   clf;
subplot(221), plot((0:nfft-1)/nfft, [abs(H0), abs(H1)]);
hold on;  plot((0:nfft-1)/nfft, P);
hold off;
title('Amplitudengaenge H0, H1 und H0G0 + H1G1');
xlabel('f/fs');   grid;

subplot(222), stem(0:L-1, h0);
title('Einheitspulsantwort h0');   grid;
La = axis;   axis([La(1), L-1, La(3:4)]);

subplot(224), stem(0:L-1, h1);
title('Einheitspulsantwort h1');   grid;
La = axis;   axis([La(1), L-1, La(3:4)]);

tsys = conv(h1,g1)+conv(h0,g0);

subplot(223), stem(0:length(tsys)-1, tsys);
title('ts = h1*g1+h0*g0');   grid;
La = axis;   axis([La(1), length(tsys)-1, La(3:4)]);


% -------- Signale des Hochpasspfades
r1 = filter(h1,1,x);      % Mit Analysefilter gefiltertes Signal
y1 = downsample(r1,2);    % Dezimiertes Signal
t1 = upsample(y1,2);      % Expandiertes Signal
v1 = filter(g1,1,t1);     % Mit Synthesefilter gefiltertes Signal

figure(2);    clf;
nd = 3000:3050;

subplot(5,2,1), stem(nd*Ts, x(nd));
ylabel('x');  grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);

subplot(5,2,2), plot(nd*Ts, x(nd));
ylabel('x');  grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);
%---------------------------------------------------
subplot(5,2,3), stem(nd*Ts, r1(nd));
ylabel('r1 = x*h0');  grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);

subplot(5,2,4), plot(nd*Ts, r1(nd));
ylabel('r1 = x*h0');  grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);
%---------------------------------------------------
subplot(5,2,5), stem(nd*2*Ts, y1(nd));
ylabel('y1 (r1 dezim.)');   grid;
La = axis;   axis([La(1), max(nd*2*Ts), La(3:4)]);

subplot(5,2,6), plot(nd*2*Ts, y1(nd));
ylabel('y1 (r1 dezim.)');   grid;
La = axis;   axis([La(1), max(nd*2*Ts), La(3:4)]);
%---------------------------------------------------
subplot(5,2,7), stem(nd*Ts, t1(nd));
ylabel('t1 (y1 expand.)');   grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);

subplot(5,2,8), plot(nd*Ts, t1(nd));
ylabel('t1 (y1 expand.)');   grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);
%---------------------------------------------------
subplot(5,2,9), stem(nd*Ts, v1(nd));
ylabel('v1 = t1*g1');   grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);

subplot(5,2,10), plot(nd*Ts, v1(nd));
ylabel('v1 = t1*g1');   grid;
La = axis;   axis([La(1), max(nd*Ts), La(3:4)]);

% -------- Spektren
[X,fx]  = pwelch(x, hamming(256), 64, 256, fs);
[R1,fr] = pwelch(r1, hamming(256), 64, 256, fs);
[Y1,fy] = pwelch(y1, hamming(256), 64, 256, fs/2);
[T1,ft] = pwelch(t1, hamming(256), 64, 256, fs);
[V1,fxr] = pwelch(v1, hamming(256), 64, 256, fs);

figure(3),   clf;
subplot(321), plot(fx,X);
ylabel('X');  grid;
pos = get(gca,'Position');
set(gca, 'Position', [pos(1)*2.7, pos(2:4)]);
title('Leistungsspektrum des Eingangssignals');
subplot(323), plot(fr,R1);
ylabel('R1');  grid;

subplot(324), plot(fy,Y1);
ylabel('Y1');  grid;

subplot(325), plot(ft,T1);
ylabel('T1');  grid;

subplot(326), plot(fxr,V1);
ylabel('Xr');  grid;

% --------- Bildung von wav-Dateien

wavwrite(x,  fs, 'xwav.wav');       wavwrite(r1, fs, 'r1wav.wav');
wavwrite(y1, fs/2, 'y1wav.wav');    wavwrite(t1, fs, 't1wav.wav');
wavwrite(v1, fs, 'v1wav.wav');      

% --------- Aufruf der Simulation
sim('audio_test_1',[0, 1]);
