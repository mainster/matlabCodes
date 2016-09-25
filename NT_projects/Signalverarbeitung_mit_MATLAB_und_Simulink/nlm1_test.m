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
f = [0, fr, fr*1.2, 1];  % Vektor der Frequenzpunkte mit zwei Bereichen
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
set(hq, 'OutputFracLength',ns)

% --------- Parameter der Eingangssequenzen
N = 2048;    % Größe der Sequenzen
q = quantizer('fixed', 'ceil', 'saturate', [16 15]);

% --------- Schaetzung der Leistungsspektraldichte des Fehlers
L = 10;  % Anzahl der Sequenzen, die gemittelt werden

v = (2*rand(1,N)-1)*0.99;
vq = quantize(q,v);
    
yp = filter(hq,vq);    % Antwort des quantisierten Filters
yp = yp.data;

yi = filter(b,1,v);
       
e = yi-yp;
e = e(nord:end);
Psd = pwelch(e);
n = length(Psd)

figure(1);    clf;
subplot(211), plot((0:n-1)/n, 10*log10(Psd));

subplot(212),
Hpsd = noisepsd(hq,20);
n = length(Hpsd.data);

plot((0:n-1)/n, 10*log10(Hpsd.data));

