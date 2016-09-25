% Programm dezim_1_.m zum Aufruf der Simulation mit dem Modell
% dezim_1.mdl, um die Spektren der dezimierten 
% Signale darzustellen

clear

fs = 6000;
fs_prim = 2000;

% ------- Aufruf der Simulation
sim('dezim_1',[0, 1]);    % Ergebnisse in der Struktur y

n = length(y.signals.values);
yn = zeros(n,4);

yn(:,1) = y.signals.values(:,1);    % dezimiertes Signal, noch mit fs abgetastet
yd = yn(1:3:end,1);  % und mit fs_prim abgetastet

yn(:,2) = y.signals.values(:,2);    % Ausgangssignals des Filters
yn(:,3) = y.signals.values(:,3);    % Verspätetes gestörtes Signal
yn(:,4) = y.signals.values(:,4);    % Verspätetes ungestörtes Signal

t = y.time;                        % Diskrete Schrittweite (1/fs)

% -------- Spektrum der Signale
[Ps1, f]  = pwelch(yn(:,3),hamming(256), 64, 256, fs);
[Ps2, f]  = pwelch(yn(:,2),hamming(256), 64, 256, fs);
[Ps3, f_] = pwelch(yd,hamming(256), 64, 256, fs_prim);

figure(1);    clf;
subplot(121), plot(f, 10*log10([Ps1, Ps2]));
title('Spektrum am Eingang und Ausgang des Filters');
xlabel('f   (fs = 6000 Hz)');    grid;


subplot(122), plot(f_, 10*log10(Ps3));
title('Spektrum nach der Dezimierung');
xlabel('f   (fs''= 2000 Hz)');    grid;

figure(2);    clf;
nd = fix(n/100);
nd = n-nd:n;

subplot(211), stairs(t(nd), [yn(nd,4), yn(nd,1)]);
title('Ungestoertes und dezimiertes Signal');
xlabel('Zeit in s');   grid;   
La = axis;   axis([t(min(nd)), t(n), -1.2, 1.2]);

subplot(212), stairs(t(nd), [yn(nd,3), yn(nd,1)]);
title('Gestoertes und dezimiertes Signal');
xlabel('Zeit in s');   grid;   
La = axis;   axis([t(min(nd)), t(n), La(3:4)]);

