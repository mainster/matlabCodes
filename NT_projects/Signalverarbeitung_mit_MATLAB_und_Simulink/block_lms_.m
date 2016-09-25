% Programm block_lms_.m zur Initialisierung des Modells 
% block_lms.mdl in dem eine Störunterdrückung 
% mit Block_LMS-Filter simuliert wird

% -------- Lesen einer realen Stšrung
[stoerung,fs,nbits]=wavread('140.wav');
fs
Ts = 1/fs;

% -------- Filter zur Simulation der Musik
nf = 64;    % Filter LäŠnge
hmusik = fir1(nf-1, 0.4);

% -------- Filter zur Simulation des Stšrungspfads
nf = 16;
%hr = fir1(nf-1, 0.2);
hr = 0.8.^(0:nf-1);

% -------- GeschŠtztes zu identifizierendes Filter
M = 16;        % Filter LäŠnge
h = zeros(1,M);
QM = 0.01;     % Varianz des Messrauschens
QP = eye(M)*0;    % Kein Prozessrauschen

% -------- Aufruf der Simulation
sim('block_lms',[0, 0.2]);

% -------- Darstellungen
figure(1);     clf;
subplot(321), plot(yout.time, yout.signals.values(:,3));
title('Gestoertes Signal d[k]');
xlabel('Zeit in s');    grid;
pos = get(gca, 'Position');   
set(gca, 'Position',[pos(1), pos(2)*1.05,pos(3),pos(4)*0.9]);

subplot(323), plot(yout.time, yout.signals.values(:,1));
title('Ideales Signal n[k]');
xlabel('Zeit in s');    grid;
pos = get(gca, 'Position');   
set(gca, 'Position',[pos(1), pos(2)*1.05,pos(3),pos(4)*0.9]);


subplot(325), plot(yout.time, yout.signals.values(:,2));
title('Entstoertes Signal d[k]-y[k]');
xlabel('Zeit in s');    grid;
pos = get(gca, 'Position');   
set(gca, 'Position',[pos(1), pos(2)*1.05,pos(3),pos(4)*0.9]);


subplot(222), plot(yout.time, ...
    yout.signals.values(:,1)-yout.signals.values(:,2));
title('Ideales - Entstoertes Signal n[k]-e[k]');
xlabel('Zeit in s');    grid;

koeffizienten = squeeze(koeff.signals.values(:,:,end));
subplot(224), plot(0:length(koeffizienten)-1, koeffizienten(:,1), '*',...
    0:length(koeffizienten)-1, koeffizienten(:,2));
title('Ideales (hr) und gelerntes Filter (h)');
grid;
hold on
plot(0:length(koeffizienten)-1, koeffizienten(:,1));
hold off
% -------- Leistungsspektraldichte der Stöšrung
figure(2);
nfft = 1024
[my_psd,f] = pwelch(stoerung(1:5:end,1), hamming(nfft), nfft/4, nfft, fs/5);
subplot(211), plot(f, 10*log10(my_psd));
title('Leistungsspektraldichte der Stoerung');
xlabel('Hz');    grid;

