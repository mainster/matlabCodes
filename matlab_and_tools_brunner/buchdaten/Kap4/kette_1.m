% Programm kette_1.m zur Parametrierung und Aufrufen des 
% Modells kette1.mdl, in dem der Aufzug einer Kette
% simuliert wird

% ------ Parameter
P = 200;               % Kraft kg m/s^2
ro = 10;               % Spezifische Masse kg/m
g = 9.8;               % Gravitationsbeschleunigung
x0 = 1;                % Anfnagslänge
mue = 0.5;             % Reibungsfaktor

% ------- Aufruf der Simulation 
my_options = simset('OutputVariables', ' ');
[t,x,y] = sim('kette1', [0:0.001:10], my_options);

% ------- Darstellung der Ergebnisse
figure(1);    clf;
subplot(211), plot(simout(:,4), simout(:,1));
title(['Kettenlaenge (x0 = ',num2str(x0),')']);
xlabel('s');  grid;

subplot(212), plot(simout(:,4), [simout(:,2), simout(:,3)/3]);
title('Geschwindigkeit und Beschleunigung/3');
xlabel('s');  grid;

