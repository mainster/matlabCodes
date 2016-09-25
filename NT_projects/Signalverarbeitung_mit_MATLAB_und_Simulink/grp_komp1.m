% Programm grp_komp1.m zur Anwendung der Funktion 
% iirgrpdelay zur Phasenentzerrung eines IIR-Filters

clear       
% --------- Tiefpassfilter das entzerrt wird
fr = 0.4;       % Relative Durchlassfrequenz
nord = 6;       % Ordnung des Filters
Rp = 0.1;       % Welligkeit im Durchlassbereich dB
Rs = 40;        % DŠmpfung im Sperrbereich dB

[z,p,k] = ellip(nord, Rp, Rs, fr);
[b,a] = zp2tf(z,p,k);

nf = 1024;
[H,w] = freqz(b,a,nf); % Frequenzgang

% --------- Entzerrungsfilter
f = 0:0.001:fr;     % Durchlassbereich
g = grpdelay(b,a,f,2);  % es wird nur der Durchlassbereich 
    % entzerrt
Gd = max(g) - g;

nord_g = 8;
[be, ae, tau]=iirgrpdelay(nord_g, f, [0, fr], Gd);

nf = 1024;
[He,w] = freqz(be,ae,nf);

% -------- Entzerrte Anordnung
Ho = H.*He;
nf = 1024;

figure(1),    clf;
subplot(221), plot(w/pi, 20*log10(abs(H)));
title('Amplitudengang TP');   
xlabel('2f/fs');   grid;

subplot(223), plot(w/pi, unwrap(angle(H)));
title('Phasengang TP (ohne Kompensation)');   
xlabel('2f/fs');  grid;

subplot(222), plot(w/pi, 20*log10(abs(Ho)));
title('Amplitudengang TP mit kompensierter Phase');   
xlabel('2f/fs');  grid;

subplot(224), plot(w/pi, unwrap(angle(Ho)));
title('Phasengang TP (mit Kompensation)');   
xlabel('2f/fs');  grid;

% -------- Einheitspulsantwort des gesamten Filters
bg = conv(b,be);
ag = conv(a,ae);

h = filter(b, a, [1, zeros(1,100)]);
he = filter(be, ae, [1, zeros(1,100)]);
hg = filter(bg, ag, [1, zeros(1,100)]);

figure(2),     clf;
subplot(221), stem(0:length(h)-1, h);
title('Einheitspulsantwort des TP-Filters '); grid;
subplot(222), stem(0:length(he)-1, he);
title('und des Kompensationsfilters');     grid;

subplot(212), stem(0:length(hg)-1, hg);
title('Einheitspulsantwort des kompensierten TP-Filters')
grid;

% -------- €quivalentes FIR-Filter

[n,f0,a0,Wb]=remezord([0.4 0.46],[1 0],[0.1 0.01], 2);
h = remez(n,f0,a0,Wb);
disp(['Ordnung des FIR-Filters = ',num2str(n)]);

figure(3),   clf;
[H,w] = freqz(h,1,512);
subplot(211), plot(w/pi, 20*log10(abs(H)))
title('Amplitudengang des Aequivalenten FIR-Filters');
xlabel('2f/fs');    grid;
La = axis;   axis([La(1:2), -60, 10]);

subplot(212), plot(w/pi, unwrap(angle(H)))
title('Phasengang des Aequivalenten FIR-Filters');
xlabel('2f/fs');    grid;
