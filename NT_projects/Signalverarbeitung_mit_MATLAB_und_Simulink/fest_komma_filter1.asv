% Programm fest_komma_filter1.m in dem die 
% Koeffizienten eines FIR-Filter quantisiert werden

% -------- Tiefpass FIR-Filter
nord = 32;       fr = 0.3;
h = fir1(nord, fr);

nb = 16;    % signed

% ------- Simulation der einfachen Quantisierung
% ohne Verschiebung

a = 2^15-1;
% hq = fix(h*a)/a;
% hq = floor(h*a)/a;
% hq = ceil(h*a)/a;
hq = round(h*a)/a;

nfft = 1024;
H = fft(h,nfft);
Hq = fft(hq,nfft);

figure(1);
plot((0:nfft-1)/nfft, 20*log10([abs(H)', abs(Hq)']));
La = axis;   axis([La(1:2), -100, La(4)]);
title('Amplitudengang des Filters ohne und mit einfacher Quantisierung');
xlabel('f/fs');     grid;

% ------- Ermittlung der Parameter der Form mit Skalierung und Verschiebung
% Vq = F*e^E*Q+B;       F, E und B
hmax = max(h);     hmin = min(h);

B = (hmax + hmin)/2;   S = (hmax-hmin)/(2^16);
Emax = fix(log2(S));   Emin = fix(log2(S)-log2(2));
F_max = S/(2^Emin);     F_min = S/(2^Emax);
F = max(F_max, F_min);   E = min(Emax, Emin);

% -------- Überprüfung der Extremwerte
% Vq = F*2^E*Q+B
Vminq = F*(2^(E))*(-2^(15))+B    % muss hmin sein
Vmaxq = F*(2^(E))*(2^(15)-1)+B   % muss ca. hmax sein

% -------- Darstellung der Codewerte
Q = fix((h-B)/S);
% Q = floor((h-B)/S);
% Q = ceil((h-B)/S);
% Q = round((h-B)/S);

figure(2);     clf;
subplot(121),
stem(0:nord, Q);
title('Codeworte (mit Verschiebung)');
xlabel('n');   grid;
La = axis;   axis([La(1), nord, La(3:4)]);
pos = get(gca,'Position');
set(gca, 'Position', [pos(1:3), pos(4)*0.8]);

%----------------------------------------------------
% -------- Quantisierung ohne Verschiebung
S1 = 2*max(h)/(2^(16));
Emax = fix(log2(S1));   Emin = fix(log2(S1)-log2(2));
F_max = S1/(2^Emin);    F_min = S1/(2^Emax);

F1 = max(F_max, F_min);     E1 = min(Emax, Emin)
V1minq = F1*(2^(E1))*(-2^(15))    % muss hmin sein
V1maxq = F1*(2^(E1))*(2^(15)-1)   % muss ca. hmax sein

% -------- Darstellung der Codewerte
% Q1 = fix(h/S1);
% Q1 = floor(h/S1);
% Q1 = ceil(h/S1);
Q1 = round(h/S1);

subplot(122),
stem(0:nord, Q1);
title('Codeworte (ohne Verschiebung)');
xlabel('n');   grid;
La = axis;   axis([La(1), nord, La(3:4)]);
pos = get(gca,'Position');
set(gca, 'Position', [pos(1:3), pos(4)*0.8]);

% -------- Vergleich der Quantisierungsstufen
dS = S1-S   % Absoluter Gewinn
dSp = 100*dS/S1    % Relativer Gewinn


