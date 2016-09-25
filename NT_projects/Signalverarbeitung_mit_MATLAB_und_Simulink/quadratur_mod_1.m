% Programm quadratur_mod_1.m zur Bildung eines komplexen Signals 
% mit einseitigem Spektrum im Basisband mit Hilfe eines
% FIR-Filters und Simulation  der Quadratur-Modulation
% und Demodulation.
% Arbeitet mit dem Modell quadratur_mod1.mdl

clear;

% -------- Allgemeine Spezifikationen
fs = 1000;
f1 = 100;      % Untere Grenze des bandbegrenzten Rauschens
f2 = 200;      % Obere Grenze des bandbegrenzten Rauschens

f0 = 2000;     % Trägerfrequenz
fs0 = 16000;   % Abtastfrequenz für den Träger

% -------- Spezifikationen für das komplexe-Filter 
% im Basisband
nord = 100;    % Ordnung (ungerade)

f = [-500 50 100 200 250 500]/500;
m = [0 1 0];
% ------- Entwicklung des Filters
bc_pm = cfirpm(nord,f,'bandpass');

bc_r = real(bc_pm);     % Realteil für das Modell
bc_i = imag(bc_pm);     % Imagteil für das Modell

% Frequenzgänge
figure(1),   clf;
nf = 1024;
[H_cpm, w] = freqz(bc_pm, 1, nf, 'whole');

subplot(121), plot(w/(2*pi), abs(H_cpm));
xlabel('f/fs');    grid;
title(['Komplexes-Filter (nord = ',...
        num2str(nord),')']);
La = axis; axis([La(1:3), 1.2]);

% -------- Koeffizienten des cfirpm-Filters (Realteil)
subplot(222), stem(0:length(bc_r)-1, bc_r);
La = axis; axis([La(1), length(bc_r)-1, La(3:4)]);
title('Koeffizienten des kompl. Filters (Realteil)'); grid;

% -------- Koeffizienten des cfirpm-Filters (Imaginaerteil
subplot(224), stem(0:length(bc_i)-1, bc_i);
La = axis; axis([La(1), length(bc_i)-1, La(3:4)]);
title('Koeffizienten des kompl. Filters (Imaginaerteil)'); grid;


% -------- Frequenzgaenge der reellwertigen Filter des 
% komplexen Filters

figure(2),    clf;
nf = 1024;
Hcr = fft(bc_r,nf);      Hci = fft(bc_i,nf);
H_cpm = fft(bc_pm,nf);

subplot(221),
plot((0:nf-1)/nf, 20*log(abs(Hcr)));
hold on
plot((0:nf-1)/nf, 20*log(abs(Hci)));
hold off
xlabel('f/fs');    grid;
title('Reellwertige Filter des komplexen Filters');

subplot(223),
plot((0:nf-1)/nf, unwrap(angle(Hcr)));
hold on
plot((0:nf-1)/nf, unwrap(angle(Hci)));
hold off
xlabel('f/fs');    grid;

subplot(222),
plot((0:nf-1)/nf, 20*log(abs(H_cpm)));
xlabel('f/fs');    grid;
title('Komplexes Filter');

subplot(224),
plot((0:nf-1)/nf, unwrap(angle(H_cpm)));
xlabel('f/fs');    grid;

% -------- Bandpassfilter im Bandpassbereich
% um die Trägerfrequenz
f1 = f0-1.5*f2;
f2 = f0+1.5*f2;
nord_bp = 128;
h_bp = fir1(nord_bp, [f1, f2]*2/fs0); % Im Modell Discrete Filter3-Block

% --------- Aufruf der Simulation
% Bandbegrenztes Rauschen
f1 = 100;    f2 = 200;   

sim('quadratur_mod1',[0,0.5]);
% in yout ist das Emphangssignal und das
% Eingangssignal

figure(3);    clf;
dn = 3000;      % Darstellungsindex
nd = length(yout)-dn:length(yout);

plot(tout(nd), yout(nd,:));
title(['Eingangs- und Ausgangssignal: Rauschen im Bereich f1 = ',...
    num2str(f1),'; f2 = ',num2str(f2),' Hz']);
xlabel('Zeit in s');    grid;
La = axis; axis([tout(min(nd)), tout(max(nd)),...
    min(min(yout)), max(max(yout))]);






