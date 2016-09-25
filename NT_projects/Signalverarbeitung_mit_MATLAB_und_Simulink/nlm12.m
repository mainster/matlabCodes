% Programm nlm1.m zur Untersuchung der nlm-Methode
% nach McClellan, Burrus, ...
% 'Computer-Based Exercises for Signal Processing using MATLAB 5'
% Prentice Hall 1998, Seite 243

% ------- Entwicklung des quantisierten TP-Filters
fr = 0.4;      % Relative Frequenz (zur Nyquist Frequenz)
nord = 170;     % Ordnung des Filters
f = [0, 0.4, 0.5, 1];    % Vektor der Frequenzpunkte 
m = [1 1 0 0];           % Vektor der Amplitudengangswerte
b = gremez(nord, f, m);  % Nicht quantisiertes Filter

nw = 16;    ne = 15;     % Wortlänge und Lage des Stellenwertpunktes
struktur = 'fir';        % FIR-Direkte-Form
rundung = 'convergent';  % Verfahren zur Rundung der Zahlen 
Hq = qfilt(struktur,{b},'Format',{[nw,ne],rundung})

% --------- Parameter der Eingangssequenzen
N = 256;    % Größe der Sequenzen

% --------- Eine Sequenz für die Darstellung als Beispiel
phi = 2*pi*rand(1,N/2-1);           % N/2-1 Werte
phi = [0 phi 0 -phi(N/2-1:-1:1)];   % N symmetrische Werte, so dass ihre
% inverese FFT ein reales Signal ergibt
Vp = exp(j*phi);       % Werte einer FFT von sinusförmigen Komponenten der
% Nullphasen phi und Amplitude gleich 1
vp = real(ifft(Vp));   % Die sinusförmigen Komponenten
v = [vp vp];           % Sequenz der Länge 2N, so dass man später das 
% Einschwingen entfernen kann

figure(1);   clf;
subplot(211), stem(0:N-1, phi);
title('Zufallsphasen der harmonischen Eingangskomponenten')
xlabel('t/Ts');     grid;
La = axis;     axis([La(1), N-1, La(3:4)]);

subplot(212), stem(vp);
title('Die harmonischen Eingangskomponenten mit Zufallsphasen')
xlabel('t/Ts');     grid;
La = axis;     axis([La(1), N-1, La(3:4)]);

% --------- 'Noise-Loading Method'
L = 30;  % Anzahl der Sequenzen, die gemittelt werden
sumH = zeros(1,N);
sumY2 = sumH;

for p = 1:L   % Die Ergebnisse der L-Sequenzen werden gemittelt
    phi = 2*pi*rand(1,N/2-1);           % N/2-1 Werte
    phi = [0 phi 0 -phi(N/2-1:-1:1)];   % N symmetrische Werte, so dass
    % ifft ein reales Signal ergibt
    Vp = exp(j*phi);       % Werte einer FFT von sinusförmigen Komponenten der
    % Nullphasen phi
    vp = real(ifft(Vp));   % Die sinusförmigen Komponenten
    v = [vp vp];           % Sequenz der Länge 2N, so dass man später das 
    % Einschwingen entfernen kann
    yp = filter(Hq, v);  % Antwort des Filters
    yp = yp(N+1:1:2*N);  % Entfernen des Einschwinsteils
    Yp = fft(yp);
    sumH = sumH +Yp./Vp;   % Mittelung der Übertragungsfunktion über L 
    % Realisierungen
    sumY2 = sumY2 + real(Yp.*conj(Yp)); 
end;

H = sumH/L;
Psd_ = ((sumY2/L)-real(H.*conj(H)))/N;    % Mittlere quadratischer Fehler
q = 2^(1-nw);                             % Quantisierungsstufe
Ne = 10*log10(mean(Psd_)/(q^2/12));       % 'Noise-Figure'     
Psd_log = 10*log10(Psd_);                 % in dB

figure(2);    clf;
subplot(211);
p = plotyy((0:N-1)/N, abs(H),(0:N-1)/N, Psd_);
title('Geschaetzter Amplitudengang und Mittlere Leistung des Fehlers (linear)');
xlabel('Relative Freaquenz f/fs');    grid;
ylabel('Amplitudengang');

hy = get(p(2), 'Ylabel');
set(hy, 'String','Mittlere quadratische Fehler');

subplot(212);
p = plotyy((0:N-1)/N, 20*log10(abs(H)), (0:N-1)/N, Psd_log);
title('Geschaetzte Amplitudengang und Mittlere Leistung des Fehlers (in dB)');
xlabel('Relative Freaquenz f/fs');    grid;
ylabel('Amplitudengang (dB)');

hy = get(p(2), 'Ylabel');
set(hy, 'String','Mittlere quadratische Fehler (dB)');

disp(['Noise-Figure = ', num2str(Ne),' dB']);
    