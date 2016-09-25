% Programm analog_bp3.m zur Untersuchung 
% von Bandpassfiltern mit Hilfe des Modells analog_bp_3.mdl
clear;
% -------- Spezifizierung
f1 = 30000;   f2 = 30500;
nord = 6;     Typ = 2;

f1s = 30100;  % Dummy Werte füŸr's Modell
f2s = 30400;
frausch = 200;
% -------- Berechnung des BP-Filters
[b,a] = analog_bp11(f1, f2, nord, Typ); % Hier wird Figure 1 erzeugt
% -------- Aufruf der Simulation füŸr 
% die Ermittlung der Sprungantwort
k1 = 1;
k2 = 0;   k3 = 0;    k4 = 0;

sim('analog_bp_3',[0:2e-6:20e-3]);
figure(2);    clf;
subplot(221), plot(tout, yout(:,1));
title('Sprungantwort');
grid;

% -------- Aufruf der Simulation füŸr 
% die Ermittlung des Einschwingens bei sinusföšrmigen Signal
k1 = 0;    k3 = 0;    k4 = 0;
k2 = 1;      f1s = 30250;

sim('analog_bp_3',[0:2e-6:20e-3]);
subplot(222), plot(tout, yout(:,1));
title(['Einschwingsvorgang (fs = ',num2str(f1s),' Hz)']);
grid;

% -------- Aufruf der Simulation füŸr 
% die Ermittlung der Antwort auf modulierte Signale im
% Durchlassbereich
k1 = 0;    k2 = 0;     k3 = 0;
k4 = 1;    f2s = 30250;     frausch = 250;

sim('analog_bp_3',[0:2e-6:200e-3]);
subplot(212), plot(tout, yout);
title(['Antwort auf AM-Signal (frausch = ',num2str(frausch),' Hz)']);

% -------- Aufruf der Simulation füŸr 
% die Ermittlung der Antwort auf zwei sinusfšrmige Signale im
% Durchlassbereich
k1 = 0;
k2 = 1;      f1s = 30100;
k3 = 1;      f2s = 30400;
k4 = 0;

sim('analog_bp_3',[0:2e-6:30e-3]);
figure(3), plot(tout, yout(:,1));
title(['Zwei Sinus-Signale (fs1, fs2 = ',num2str([f1s,f2s]),' Hz)']);
grid;
