% Programm null_erw2.m zur Ermittlung des Frequenzgang
% eines FIR-Filters über die FFT durch Erweiterung 
% der Sequenz der Koeffizienten mit Nullwerten

% ------- Koeffizienten des FIR-Filters
nf = 6;       % Ordnung des Filters = Anzahl-Koeffizienten - 1
h = ones(1,nf+1)/(nf+1);       % Mittelwertfilter über nf+1 Werte
N = 64;                % Gesamte Länge mit Nullwerte

% ------- Impulsantwort des Filters (die Koeffizienten)
figure(1);     clf;
subplot(211), stem(0:nf, h);
title('Impulsantwort (Koeffizienten)');
subplot(212), stem(0:N-1, [h, zeros(1,N-nf-1)]);
title('Mit Nullwerten erweiterte Sequenz der Koeffizienten');

% ------- Frequenzgang mit und ohne Erweiterung mit Nullstellen
H1 = fft(h);
n1 = length(H1);

N = 256;
H2 = fft(h, N);

betrag_1 = abs(H1);    winkel_1 = angle(H1);
betrag_2 = abs(H2);    winkel_2 = angle(H2);

figure(2);     clf;
subplot(221), plot((0:n1-1)/n1, betrag_1);
title('Frequenzgang ohne Nullwerte');
ylabel('Betrag');   grid;
subplot(223), plot((0:n1-1)/n1, winkel_1);
ylabel('Winkel in rad');   
xlabel('f/fs');     grid;

subplot(222), plot((0:N-1)/N, betrag_2);
title('Frequenzgang mit Nullwerte');   grid;
subplot(224), plot((0:N-1)/N, winkel_2);
xlabel('f/fs');     grid;
