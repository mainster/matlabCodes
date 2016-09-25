function ode_test3
% Funktion ode_test3.m in der ein einfaches Feder-Masse-System
% mit ODE-Funktion gelöst wird

%------- Initialisierung des Systems
m = 0.2;                % Masse
r = 0.9;                % Dämpfungfaktor
D = 0.8;                % Federkonstante

% Anfangsbedingungen
x10 = 0.2;              % Weg
x20 = -0.2;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
[t,x] = ode45(@ableitung,[0, 20], x0, [], m, r, D);

% Darstellung der Lösung
figure(1);      clf;
plot(t,x);
title(['Weg und Geschwindigkeit für x0 = [',num2str(x10),'; ',...
        num2str(x20),']']);
xlabel('Zeit in s');        grid on;
legend('Weg x1','Geschwindigkeit x2');

%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
function ableit = ableitung(t, x, m, r, D)

% Parameter der Kraft-Erregung
amp = 1.2;      freq = 1;       nullphase = pi/3;
kraft = amp*sin(2*pi*freq*t + nullphase);

ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2)*abs(x(2))+(1/m)*kraft];
