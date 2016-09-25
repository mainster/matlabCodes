% Programm adaptiv_4.m zur Parametrierung und Aufrufs des Modells
% adaptiv4.mdl, in dem eine BrummunterdrüŸckung mit LMS-Verfahren
% simuliert wird

clear;
% ------- Allgemeine Parameter
fs = 1000;
Ts = 1/fs;
noise = 0.2;   % Messrauschen Varianz
m_noise = sqrt(noise);   

mu = 0.01;       % Schrittweite der Anpassung
n_koeff = 32;    % Anzahl der Koeffizienten des Filters

% ------- Parameter fŸr die Eingangssequenz
% in Form einer Periode eines EKGs
xs = [0 -2 -4 -5 -4 -2 0 1 3 5 6 5 3 1,...
        randn(1,10)*0.1, -0.2 -0.3 -0.4 -0.5 -0.6 -0.7 -1,...
        -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8 1 1.2 1 0.8 0.6,...
        0.4 0.2 0 0 0 -0.2 -0.5 -0.4 -0.2 0 0 0 0];
xs = interp1(0:length(xs)-1, xs, 0:0.25:length(xs)-1,'spline');
ts = (0:length(xs)-1)/250;

% ------- Aufruf der Simulation
sim('adaptiv4',[0, 4]);

% ------- Darstellung der Ergebnisse
figure(1);    clf;
subplot(221), plot(0:length(y)-1, y(:,1));
title('Durch Brumm gestoertes EKG');
xlabel('Zeit in ms');   grid;

subplot(223), plot(0:length(y)-1, y(:,2));
title('Adaptiv entstoertes EKG');
xlabel('Zeit in ms');   grid;

subplot(222), plot(0:length(y)-1, y(:,3));
title('Gelernte Stoerung');
xlabel('Zeit in ms');   grid;

subplot(224), stem(koeff);
title('Filterkoeffizienten');
xlabel('n');   grid;

figure(2);    clf;
freqz(koeff,1);
title('Frequenzgang des angepassten Filters');

