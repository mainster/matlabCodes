% Programm (dintegr1.m) zur Darstellung der Ergebnisse
% der Simulation einer Demodulation von antipodalen Binärdaten
% mit Korrelator über das Modell integr_1.mdl

figure(1);     clf;
subplot(311), stairs(tout, yout(:,1));
title('Daten ohne Rauschen');
La = axis;     axis([La(1), La(2), -1.5, 1.5]);
grid;
subplot(312), plot(tout, yout(:,3));
title('Daten mit Rauschen');     grid;

subplot(313), stairs(tout, yout(:,4))
hold on, plot(tout, yout(:,2)*3);
title('Takt und Ausgang des Integrators ');
xlabel('Zeit in s');             grid;
hold off;
