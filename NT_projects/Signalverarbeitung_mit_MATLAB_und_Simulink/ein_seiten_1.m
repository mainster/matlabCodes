% Programm ein_seiten_1.m zur Bildung eines komplexen Signals 
% mit einseitigem Spektrum im Basisband mit Hilfe eines
% FIR-Hilbertfilters 
% Arbeitet mit dem Modell ein_seiten1.mdl

clear;
% -------- Spezifikationen für das Hilbert-Filter 
nord = 50;    % Ordnung (ungerade)
f = [0.05, 0.95];  m = [1, 1];
% ------- Entwicklung der Filter
b_pm=firpm(nord,f,m,'hilbert');

% Frequenzgänge
figure(1),   clf;
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf);

subplot(211),
plot(w/(2*pi), abs(H_pm));
xlabel('f/fs');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Hilbert-Filter (nord = ',...
        num2str(nord),')']);

% -------- Koeffizienten des firpm-Filters
subplot(212), stem(0:length(b_pm)-1, b_pm);
La = axis; axis([La(1), length(b_pm)-1, La(3:4)]);
title('Koeffizienten des Filters'); grid;

% -------- Aufruf der Simulation mit 
% sinusförmigen Eingangssignal
ki = 2;
fs = 1000;
fsig = 200;
f1 = 100;    f2 = 400;   % dummy Werte für's Modell

sim('ein_seiten1',[0,5]);  % Aufruf der Simulation
% in yout ist das Spektrum mit 256 Punkte enthalten
nfft = 256;

figure(2),    clf;
plot((0:nfft-1)*2*fs/nfft, 10*log10(yout(1:nfft,:)));
title(['Eingangssignal: Sinus f = ',num2str(fsig), ' Hz']);
xlabel(['f in Hz (fs = ',num2str(fs),' Hz)']);    grid;

% Bandbegrenztes Rauschen
ki = 1;
fs = 1000;
fsig = 200;   % dummy Wert für's Modell
f1 = 100;    f2 = 400;   

sim('ein_seiten1',[0,5]);
% in yout ist das Spektrum mit 256 Punkte enthalten
nfft = 256;

figure(3),    clf;
plot((0:nfft-1)*2*fs/nfft, 10*log10(yout(1:nfft,:)));
title(['Eingangssignal: Rauschen von f1 = ',num2str(f1),...
        ' Hz bis f2 = ',num2str(f2),' Hz']);
xlabel(['f in Hz (fs = ',num2str(fs),' Hz)']);    grid;









