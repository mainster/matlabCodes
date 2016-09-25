function ode_test9
% Funktion ode_test9.m in der ein einfaches Feder-Masse-System
% mit der ODE-Funktion ode15s gelöst wird
% Es wird die Jacobian-Matrix eingesetzt

%------- Initialisierung des Systems
m = 0.2;                % Masse
r = 0.09;               % Dämpfungfaktor
D = 0.8;                % Federkonstante

% Anfangsbedingungen
x10 = 0.2;              % Weg
x20 = -0.2;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
my_option = odeset('OutputFcn',@odeplot,'Jacobian',@Fjac);

[t,x] = ode15s(@ableitung,[0, 20], x0, my_option, m, r, D);


%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
% ohne externer Kraft
function ableit = ableitung(t, x, m, r, D)
ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2)*abs(x(2))];

% Private Funktion für die Jacobian-Matrix
function J = Fjac(t, x, m, r, D)
J = [0, 1; (-D/m), (-r/m)*2*abs(x(2))];








