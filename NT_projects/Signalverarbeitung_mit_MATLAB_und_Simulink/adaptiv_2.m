% Programm adaptiv_2.m zur Parametrierung und Aufrufs des Modells
% adaptiv2.mdl, in dem eine Identifikation mit LMS-Verfahren
% simuliert wird

clear;
% ------- Allgemeine Parameter
fs = 1000;
Ts = 1/fs;
noise = 0.2;   % Messrauschen Varianz
m_noise = sqrt(noise);   

mu = 0.01;       % Schrittweite der Anpassung

% ------- FIR-Filter fŸr das unbekannte System
h = [1 2 3 4 5 6 7 8 9 10];
L = length(h);

% ------- Aufruf der Simulation
sim('adaptiv2',[0, 2.5]);

% ------- Darstellungen
hf = squeeze(hfilter);  % unnöštige Dimension
                        % entfernen
figure(1);    clf;
subplot(221), plot(0:length(e)-1, e);
title(['Fehler der Anpassung (Messrauschen = ',num2str(noise),')']);
xlabel('Schritte');    grid;
subplot(222), plot(0:length(hf)-1, hf);
title(['Identifizierte Koeffizienten (\mu = ',...
        num2str(mu),')']);
xlabel('Schritte');    grid;
