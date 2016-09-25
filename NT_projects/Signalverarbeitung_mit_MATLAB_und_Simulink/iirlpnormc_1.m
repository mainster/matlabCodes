% Programm iirlpnormc_1.m zur Entwicklung von 
% IIR-Filtern mit der Funktion iirlpnormc

clear;

% --------- Filter Spezifikation
fp = [20.5, 22, 23.5]*1.e3;  % Durchlassbereich mit Stützpunkt
fp1 = [20.5, 23.5]*1.e3;     % Durchlassbereich

fs1 = [0, 19]*1.e3;          % Sperrbereich 1
fs2 = [25, 50]*1.e3;         % Sperrbereich 2

Rp = 0.25;  % dB Welligkeit im Durchlassbereich 
Rs = 45;    % dB Dämpfung in den Sperrbereichen

fs = 100*1.e3;  % Abtastfrequenz
Ts = 1/fs;      % Abtastperiode

% --------- Berechnung des Filters
nz = 3; nn = 10;   % Ordnung Zähler und Nenner
f = [fs1, fp, fs2]*2/fs;  % Vektor Frequenzen 
m = [0 0 1 1 1 0 0];      % Vektor Amplitudengänge
edges = [fs1, fp1, fs2]*2/fs;  % Vektor der Grenzen der Bereichen
Wb = [1 5 5 8 5 5 1];     % Vektor der Bewertung

[b,a]=iirlpnormc(nz,nn,f,edges, m, Wb,0.95);

% --------- Frequenzgang
nf = 1024;
[H,w] = freqz(b,a,nf);

figure(2),    clf;
subplot(121), plot(w/pi, 20*log10(abs(H)/max(abs(H))));
title('Amplitudengang des Bandpassfilters');
xlabel('2f/fs');    grid;
La = axis;   axis([La(1:2), -100, 10]);
ylabel('dB');

nd1 = fix(0.375*nf);   nd2 = fix(0.5*nf);
subplot(222), plot(w(nd1:nd2)/pi, 20*log10(abs(H(nd1:nd2))/max(abs(H))));
title('Amplitudengang (Ausschnitt)');
xlabel('2f/fs');    grid;
La = axis;   axis([La(1:2), -1, 0.5]);
ylabel('dB');


subplot(224), zplane(roots(b), roots(a));
title('Null-Polstellen Verteilung');
grid;
