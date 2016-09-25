% Programm quantis_filter1.m in dem ein quantisiertes 
% FIR-TP-Filter entwickelt und untersucht wird
% Arbeitet mit dem Simulink-Modell quantis_filter_1.mdl

% --------- Spezifikationen
fs = 1000;   % Abtastfrequenz
fr = 0.3;    % Durchlassfrequenz (relativ zur Nyquist Frequenz)
nord = 150;  % Ordnung des Filters
f = [0, fr, fr*1.15, 1];  % Vektor der Frequenzpunkte mit zwei Bereichen
m = [1 1 0 0];            % Vektor der Amplitudengangswerte
% --------- Ermittlung des nicht quantisierten Filters
b = firpm(nord, f, m);      % Remez Algorithmus
% --------- Entwerfen des quantiserten Filters
hq = dfilt.df2(b);   % df2, weil die Funktion block
            % diese Struktur in Simulink unterstŸtzt
%hq.Arithmetic ='fixed';    % Festkomma-Format
set(hq,'Arithmetic','fixed');
% -------- Eigenschaften von hq
hq
%pause
% -------- Aendern der Eigenschaften
hq.CoeffAutoScale = false;
hq.NumFracLength = 15;
hq.DenFracLength = 15;
% -------- Eigenschaften von hq
hq
%pause
% -------- Aendern der Eigenschaften
hq.ProductMode = 'SpecifyPrecision';
% -------- Eigenschaften von hq
hq
%pause
% -------- Quantisierte Koeffizienten
hqq = hq.Numerator;
% -------- Analyse der Pol- und Nullstellen-Verteilung
zplane(hq);
% ------- Analyse des Frequenzgangs mit Freqz
freqz(hq);
% ------- Analyse des Frequenzgangs mit Freqz
impz(hq);
% ------- Frequenzgang-Messung mit sinusföšrmigen Signalen 
% und Monte-Carlo-Verfahren
Hqpsd = noisepsd(hq);
plot(Hqpsd)
figure;
% ------- Implementierung einer Filterung
frs = (fr/2)*0.7;             % Signalfrequenz (relativ zu fs)
amp1 = 0.95;
n = 0:fix(100/frs);
x = amp1*sin(2*pi*frs*n);     % Ideales Eingangssignal 
q = quantizer('fixed', 'ceil', 'saturate', [16 15]);
% Quantizierer
xq = quantize(q,x);         % Quantisiertes Eingangssignal
yq = filter(hq,xq);         % Quantisierter Ausgang
y = filter(b,1,x);          % Idealer Ausgang

nt = fix(10/frs);
nd = n(end-nt):n(end);     % Index füŸr die Darstellung

subplot(221), stairs(nd,[xq(nd)', x(nd)']); 
title('    Quantis.- und Idealer Eingang');
La = axis;   axis([min(nd), max(nd), La(3:4)]);
subplot(223), stairs(nd, x(nd)-xq(nd));
title('Differenz (x - xq)');  grid on;
La = axis;   axis([min(nd), max(nd), La(3:4)]);

%subplot(222), stairs(nd,[double(yq(nd))', y(nd)']);
subplot(222), stairs(nd,[yq.data(nd)', y(nd)']);
% stairs (und stem) ist keine Methode füŸr quantisierte Objekte 
% somit wird yq in double umgewandelt 
title('    Quantis.- und Idealer Ausgang');
La = axis;   axis([min(nd), max(nd), La(3:4)]);
subplot(224), stairs(nd, y(nd)-double(yq(nd)));
% subplot(224), stairs(nd, y(nd)-yq.data(nd));
title('Differenz (y - yq)');  grid on;
La = axis;   axis([min(nd), max(nd), La(3:4)]);
% -------- Erzeugung eines Simulink-Blocks
% Das Modell quantis_filter_1.mdl muss gešffnet sein
set(hq, 'RoundMode', 'round');
block(hq, 'Destination','Current',...
    'Blockname', 'Quant-Filter', ...
    'OverwriteBlock','on');
% -------- Aufruf der Simulation
sim('quantis_filter_1',[0, 1]);



