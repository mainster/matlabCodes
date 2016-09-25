function ode_test6
% Funktion ode_test6.m in der ein einfaches Feder-Masse-System
% mit ODE-Funktion gelöst wird
% Es wird eine eigene Funktion als OutputFcn benutzt

%------- Initialisierung des Systems
m = 0.2;                % Masse
r = 0.9;                % Dämpfungfaktor
D = 0.8;                % Federkonstante

% Anfangsbedingungen
x10 = 0.2;              % Weg
x20 = -0.2;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
my_option = odeset('OutputFcn',@my_function);

[t,x] = ode45(@ableitung,[0, 20], x0, my_option, m, r, D);


%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
% ohne externer Kraft
function ableit = ableitung(t, x, m, r, D)
ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2)*abs(x(2))];

%******************************************************
% Funktion, die mit der Option OutupFcn als Ausgangsfunktion
% gewählt wurde
function status = my_function(t,x,flag,varargin)
if strcmp(flag, 'init');
    tspan = t;          % hier nicht benutzt
    x0 = x;
    figure;             % öffnet ein neues Bild
elseif strcmp(flag, 'done');
    clear x t
else
    plot(t,x,'ko-');
    hold on
end;
status = 0;



