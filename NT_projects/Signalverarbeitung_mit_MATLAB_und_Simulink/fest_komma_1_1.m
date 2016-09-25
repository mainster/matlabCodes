% Programm fest_komma_1_1.m zur Darstellung der 
% Ergebnisse der Simulation mit dem
% Simulink-Modell fest_komma1_1.mdl

% Die Initialisierung des Modells muss per Hand
% im Modell durchgeführt werden

% ------- Aufruf des Modells
sim('fest_komma1_1', [0 10]);

% in y sind die Signale
% y(:,1) = quantisiertes Signal
% y(:,2) = kontinuierliches Signal
% y(:,3) = Fehler der Quantisierung

% ------- Darstellung der Ergebnisse
figure(1);   clf;
subplot(211), plot(t, y(:,1:2));
title('Signal und Quantisiertes-Signal');
xlabel('Zeit in s');    grid;

subplot(212), plot(t, y(:,3));
title('Fehler der Quantisierung');
xlabel('Zeit in s');    grid;
