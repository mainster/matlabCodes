function ode_test4
% Funktion ode_test4.m in der ein einfaches Feder-Masse-System
% mit externe Einwirkung (Kraft) über die ODE-Funktion gelöst

%------- Initialisierung des Systems
m = 0.2;                % Masse
r = 0.9;                % Dämpfungfaktor
D = 0.8;                % Federkonstante

% Anfangsbedingungen
x10 = 0.2;              % Weg
x20 = -0.2;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
[t1,x1] = ode45(@ableitung1,[0, 20], x0, [], m, r, D);

[t2,x2] = ode45(@ableitung2,[0, 20], x0, [], m, r, D);

% Darstellung der Lösungen ohne und mit externer Kraft
figure(1);      clf;
subplot(211), plot(t1,x1);
title(['Weg und Geschwindigkeit für x0 = [',num2str(x10),'; ',...
        num2str(x20),']']);
grid on;
legend('Weg x1','Geschwindigkeit x2');

subplot(212), plot(t2,x2);
title(['Weg und Geschwindigkeit für x0 = [',num2str(x10),'; ',...
        num2str(x20),' ] und externe Kraft']);
xlabel('Zeit in s');        grid on;
legend('Weg x1','Geschwindigkeit x2');


%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
% ohne externer Kraft
function ableit = ableitung1(t, x, m, r, D)

ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2)*abs(x(2))];
% Private Funktion, in der die Ableitungen berechnet werden
% mit externer Karft
function ableit = ableitung2(t, x, m, r, D)

% Parameter der Kraft-Erregung
amp = 1.2;      freq = 1;       nullphase = pi/3;
kraft = amp*sin(2*pi*freq*t + nullphase);

ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2)*abs(x(2))+(1/m)*kraft];
