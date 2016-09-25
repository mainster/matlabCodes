% Programm chirp_1.m zur Parametrierung und Aufrufen des 
% Modells chirp1.mdl, in dem ein Chirp-Signal erzeugt wird

T = 10e-3;          % 10 ms
delta_f = 2e3;
f0 = 500;

% ------- Aufruf der Simulation 
my_options = simset('OutputVariables', ' ');
[t,x,y] = sim('chirp1', [0:0.01e-3:40e-3], my_options);

% ------- Darstellung der Ergebnisse
figure(1);    clf;
subplot(211), plot(simout(:,3), simout(:,2));
title('Frequenzaenderung');
xlabel('s');  grid;

subplot(212), plot(simout(:,3), simout(:,1));
title('Chirp-Signal');
xlabel('s');  grid;