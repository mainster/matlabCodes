function ode_test5
% Funktion ode_test5.m in der ein einfaches Feder-Masse-System
% mit ODE-Funktion gel�st wird
% Es werden die Optionen OutputFcn mit odeplot und die Option
% OutputSel auf die zweite Kommponente gesetzt

%------- Initialisierung des Systems
m = 0.2;                % Masse
r = 0.9;                % D�mpfungfaktor
D = 0.8;                % Federkonstante

% Anfangsbedingungen
x10 = 0.2;              % Weg
x20 = -0.2;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
my_option = odeset('OutputFcn',@odeplot,'OutputSel',[2]);

[t,x] = ode45(@ableitung,[0, 20], x0, my_option, m, r, D);


%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
% ohne externer Kraft
function ableit = ableitung(t, x, m, r, D)

ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2)*abs(x(2))];
