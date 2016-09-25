% Programm ein_seiten_2.m zur Bildung eines komplexen Signals 
% mit einseitigem Spektrum im Basisband mit Hilfe eines
% FIR-Hilbertfilters und Filterung mit komplexen Filter
% entwickelt mit firpm
% Arbeitet mit dem Modell ein_seiten2.mdl

clear;
% -------- Spezifikationen für das Hilbert-Filter 
nord = 50;    % Ordnung (ungerade)
f = [0.05, 0.95];  m = [1, 1];
% ------- Entwicklung der Filter
b_pm = firpm(nord,f,m,'hilbert');

% -------- Spezifikationen für das komplexe Filter
% mit cfirpm entwickelt
f = [-500 190 210 290 310 500]/500;
nord2 = 100;
bc_pm = cfirpm(nord2, f, 'bandpass', [10 100 10]);

bc_r = real(bc_pm);     % für das Modell
bc_i = imag(bc_pm);

% Frequenzgänge
figure(1),   clf;
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf, 'whole');
[H_cpm, w] = freqz(bc_pm, 1, nf, 'whole');

subplot(221),
plot(w/(2*pi), abs(H_pm));
xlabel('f/fs');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Hilbertfilter (nord = ',...
        num2str(nord),')']);
La = axis; axis([La(1:3), 1.2]);

% -------- Koeffizienten des Hilbertfilters
subplot(223), stem(0:length(b_pm)-1, b_pm);
La = axis; axis([La(1), length(b_pm)-1, La(3:4)]);
title('Koeffizienten des Hilbertfilters'); grid;

subplot(222),
plot(w/(2*pi), abs(H_cpm));
xlabel('f/fs');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Amplitudengang des kompl. Filters (nord = ',...
        num2str(nord2),')']);
La = axis; axis([La(1:3), 1.2]);

% -------- Koeffizienten des komplexen-firpm-Filters
subplot(426), stem(0:length(bc_r)-1, bc_r);
title('Koeffizienten des kompl. Filters'); grid;
La = axis; axis([La(1), length(bc_i)-1, La(3:4)]);

subplot(428), stem(0:length(bc_i)-1, bc_i);
La = axis; axis([La(1), length(bc_i)-1, La(3:4)]);

% -------- Aufruf der Simulation mit 
% Bandbegrenztes Rauschen
fs = 1000;
fsig = 200;   % dummy Wert für's Modell
f1 = 100;    f2 = 400;   

sim('ein_seiten2',[0,5]);
% in yout ist das Spektrum mit 256 Punkte enthalten
nfft = 256;

figure(2),    clf;
plot((0:nfft-1)*2*fs/nfft, 10*log10(yout(1:nfft,:)));
title(['Eingangssignal: Rauschen von f1 = ',num2str(f1),...
        ' Hz bis f2 = ',num2str(f2),' Hz']);
xlabel(['f in Hz (fs = ',num2str(fs),' Hz)']);    grid;









