function [t, y, mass] = ode_mass1
% Funktion ode_mass1.m in der ein Feder-Masse-System mit
% ver�nderliche Masse �ber ODE-Funktion gel�st wird

%------- Initialisierung des Systems
m = 0.2;                % Masse
r = 0.09;               % D�mpfungfaktor
D = 0.8;                % Federkonstante
delta_m = 3;            % Zeitkonstante f�r die Masse�nderung

% Anfangsbedingungen
x10 = 0.2;              % Weg
x20 = -0.2;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
my_option = odeset('OutputFcn',@odeplot,'Jacobian',@Fjac,'Mass',@my_mass);

[t,y] = ode15s(@ableitung,[0, 20], x0, my_option, m, r, D, delta_m);

% Berechnung der Masse�nderung f�r die Darstellung
mass = m*exp(-t/delta_m);

figure(2);      clf;      % Figure(1) von odeplot benutzt
subplot(211), plot(t,mass);
title('Aenderung der Masse');
grid on;
subplot(212), plot(t,y);
title('Weg und Geschwindigkeit der Masse');
grid on;   xlabel('Zeit in s');

%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
% ohne externer Kraft
function ableit = ableitung(t, x, m, r, D, delta_m)
ableit = [x(2); (-D)*x(1)+(-r)*x(2)*abs(x(2))];

% Private Funktion f�r die Jacobian-Matrix
function J = Fjac(t, x, m, r, D, delta_m)
J = [0, 1; (-D), (-r)*2*abs(x(2))];

% Private Funktion f�r Masse-Matrix
function M = my_mass(t, x, m, r, D, delta_m)
M = [1, 0; 0, m*exp(-t/delta_m)];







