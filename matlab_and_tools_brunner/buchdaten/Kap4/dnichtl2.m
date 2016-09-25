% Programm (dnicht2.m) zur Darstellung der Ergebnisse
% der Simulation mit dem Modell nichtl_2.mdl

% yout(:,1) = ua(t) Ausgangsspannung
% yout(:,2) = id(t) Strom der Diode
% yout(:,3) = ug(t) Eingangsspannung

figure(1);     clf;
subplot(211), plot(tout, [yout(:,1), yout(:,3)]);
title('Eingangs- und Ausgangsspannung');
xlabel('Zeit in s');     grid;
La = axis;   axis([min(tout), max(tout), La(3), La(4)]);

subplot(212), plot(tout, yout(:,2));
title('Strom der Diode');
xlabel('Zeit in s');     grid;
La = axis;   axis([min(tout), max(tout), La(3), La(4)]);
