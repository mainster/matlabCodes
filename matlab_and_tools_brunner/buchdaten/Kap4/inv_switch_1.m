% Programm inv_switch_1.m zur Simulation eines 
% Inverting-Switcher mit dem Modell inv_switch1.mdl

% -------Parameter der Schaltung
C = 500e-6;      % 100 MikroFarad
Rp = 1;          % 1 Ohm
L = 0.5e-3;        % 1 mH

Vin = 5;         % Eingangsspannung
tast = 50;       % Tastverhältnis des Puls-Generators

% -------Aufruf der Simulation
my_options = simset('OutputVariables', 'ty');
[t,x,y] = sim('inv_switch1',[0, 10e-3], my_options);

% Darstellungen
% y(:,1) = Spannung an der Induktivität
% y(:,2) = Strom der Induktivität
% y(:,3) = Spannung an den Kondensator
% y(:,4) = Strom des Kondensators
% y(:,5) = Strom der Quelle

n = length(y(:,1));
N = 200;
nd = n - 100:n;

figure(1);            clf;
subplot(211), plot(t(nd), y(nd,5));
title('Strom der Quelle');  grid on;
La = axis;   axis([t(nd(1)), La(2), -0.1*La(4), La(4)*1.2]);

subplot(212), plot(t(nd), y(nd,2));
title('Strom der Induktivitaet');  grid on;
La = axis;   axis([t(nd(1)), La(2), La(3), La(4)]);

figure(2);            clf;
subplot(211), plot(t(nd), y(nd,3));
title('Spannung an den Kondensator');  grid on;
La = axis;   axis([t(nd(1)), La(2), La(3:4)]);

subplot(212), plot(t(nd), y(nd,4));
title('Strom des Kondensators');  grid on;
La = axis;   axis([t(nd(1)), La(2), La(3:4)]);




