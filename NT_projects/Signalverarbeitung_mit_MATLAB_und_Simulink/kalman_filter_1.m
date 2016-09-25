% Programm kalman_filter_1.m zur Initialisierung des Modells 
% kalman_filter1.mdl in dem eine Störunterdrückung
% mit Kalman-Filter simuliert wird


fs = 40000;
Ts = 1/fs;

fst = 400;    % Frequenz des Brumms
fm = 2000;    % Ton der Musik

% -------- Filter zur Simulation des Stšrungspfads
nf = 15;
hr = fir1(nf-1, 0.4);

% -------- GeschäŠtztes zu identifizierendes Filter
M = 20;
h = zeros(1,M);
QM = 1;     % Varianz des Messrauschens
QP = eye(M)*0;    % Kein Prozessrauschen

% -------- Aufruf der Simulation
sim('kalman_filter1',[0, 0.02]);

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



