% Programm nlm1.m zur Untersuchung der nlm-Methode
% nach McClellan, Burrus, ...
% 'Computer-Based Exercises for Signal Processing using MATLAB 5'
% Prentice Hall 1998, Seite 243

clear

fr = 0.3;    % Durchlassfrequenz (relativ zur Nyquist Frequenz)
nord = 150;  % Ordnung des Filters
f = [0, fr, fr*1.2, 1];  % Vektor der Frequenzpunkte mit zwei Bereichen
m = [1 1 0 0];            % Vektor der Amplitudengangswerte

% --------- Ermittlung des nicht quantisierten Filters% Programm nlm1.m zur Untersuchung der nlm-Methode
% nach McClellan, Burrus, ...
% 'Computer-Based Exercises for Signal Processing using MATLAB 5'
% Prentice Hall 1998, Seite 243

clear

fr = 0.3;    % Durchlassfrequenz (relativ zur Nyquist Frequenz)
nord = 150;  % Ordnung des Filters
f = [0, fr, fr*1.4, 1];  % Vektor der Frequenzpunkte mit zwei Bereichen
m = [1 1 0 0];            % Vektor der Amplitudengangswerte

% --------- Ermittlung des nicht quantisierten Filters
b = firpm(nord, f, m);      % Remez Algorithmus

% --------- Entwerfen des quantiserten Filters
hq = dfilt.df2(b);   % df2, weil die Funktion block
            % diese Struktur in Simulink unterstützt
set(hq,'Arithmetic','fixed');
% -------- Aendern der Eigenschaften
set(hq, 'CoeffAutoScale',false)
nw = 16;        % Anzahl Bit für die koeffizienten des Filters
ns = 15;        % Fraction-Length
set(hq, 'NumFracLength',ns)
set(hq, 'DenFracLength',ns)
set(hq, 'ProductMode','SpecifyPrecision')
set(hq, 'OutputMode','SpecifyPrecision')
set(hq, 'OutputFracLength',ns-2)

% --------- Parameter der Eingangssequenzen
N = 512;    % Größe der Sequenzen

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
q = quantizer('fixed', 'ceil', 'saturate', [16 15]);

L = 10;  % Anzahl der Sequenzen, die gemittelt werden
sumH = zeros(1,N);

for p = 1:L   % Die Ergebnisse der L-Sequenzen werden gemittelt
    phi = 2*pi*rand(1,N/2-1);           % N/2-1 Werte
    phi = [0 phi 0 -phi(N/2-1:-1:1)];   % N symmetrische Werte, so dass
    % ifft ein reales Signal ergibt
    Vp = exp(j*phi);       % Werte einer FFT von sinusförmigen Komponenten der
    % Nullphasen phi
    vp = real(ifft(Vp));   % Die sinusförmigen Komponenten
    v = [vp, vp];          % Sequenz der Länge 2N, so dass man später das 
    % Einschwingen entfernen kann

    
    vm = 1.1*max(abs(v));
    v = v/vm;
    vq = quantize(q,v);
    
    yp = filter(hq,vq);       % Antwort des Filters
    yp = yp.data(N+1:1:2*N);  % Entfernen des Einschwinsteils
    Yp = fft(yp);
    Vp = fft(v(N+1:1:2*N));
    
    sumH = sumH + Yp./Vp;   % für die Mittelung der Übertragungsfunktion 
    % über L Realisierungen
end;
H = sumH/L;     % Geschaetzter Frequenzgang
Hi = fft(b,N);  % Idealer Frequenzgang

% ------- Schaetzung der Leistungsspektraldichte
N1 = 2048;              % Laenge der sequenz

v = (2*rand(1,N1)-1)*0.9;   % Bereich -1 bis 1 gleich 2
vq = quantize(q,v);

yp = filter(hq,vq);     % Antwort des quantisierten Filters
yp = yp.data;           % yp ist eine Struktur

yi = filter(b,1,v);     % Antwort des idealen Filters
       
e = yi-yp;          % Fehler
e = e(nord:end);    % Ohne Einschwingsvorgang

[Psd,w] = pwelch(e);    % Leistungsdichtespektrum
n = length(Psd)

q = 2*2^(1-nw);     % Quantisierungsstufe 2/(2^(nw-1))
Ne = 10*log10(mean(Psd)/(q^2/12));       % 'Noise-Figure'     
Psd_log = 10*log10(Psd);                 % in dB

figure(2);    clf;
subplot(121);
nd = 0:N/2-1;

plot(nd/N, 20*log10([abs(H(nd+1))',abs(Hi(nd+1))']));
title('Geschaetzter und idealer Amplitudengang');
xlabel('Relative Freaquenz f/fs');    grid;
ylabel('Amplitudengang in dB');
legend('geschaetzter Freqg.','idealer Freqg.');

subplot(222);
%plot((0:n-1)/n, Psd_log);
plot(w/(2*pi), Psd_log);
title('Geschaetzte Leistungsspektraldichte des Fehlers (in dB)');
xlabel('Relative Freaquenz f/fs');    grid;
ylabel('dB');
%La = axis;   axis([La(1:2), -105, 0]);

subplot(224);
%Hpsd = noisepsd(hq,L);
%plot(Hpsd)
Hpsd = noisepsd(hq,10);
n = length(Hpsd.data);

plot((0:n-1)/n, 10*log10(Hpsd.data));
title('Leistungsspektraldichte ueber noisepsd');
xlabel('Relative Freaquenz f/fs');    grid;
ylabel('dB');
%La = axis;   axis([La(1:2), -120, 0]);

disp(['Noise-Figure = ', num2str(Ne),' dB']);
    




