% Programm anw_pid_1.m zur Simulation einer Regelung
% mit dem Modell anw_pid1.mdl, in dem das Untersystem pid_regler.mdl
% eingesetzt wird

% -------Parameter des Reglers (des Untersystems)
b = 1;          % Gewichtung des Sollwerts     
K = 5;          % Gemeinsamer Verstärkungsfaktors des PID-Reglers
Td = 80;        % Zeitkonstante des D-Anteils
N = 5;          % Td/N ist die Zeitkonstante im Nenner des D-Anteils
Ti = 0.05;      % Integrationszeitkonstante
Tt = 1;         % Nachlaufzeitkonstante für den Anti-Windup-Effekt

% -------Aufruf der Simulation 
my_options = simset('OutputVariables','ty');
tfinal = 5;
dt = tfinal/500;
[t,x,y] = sim('anw_pid1',[0:dt:tfinal],my_options);

% -------Darstellung der Ergebnisse
figure(1);      clf;
subplot(211), plot(t, y(:,1));
title('Ausgang');
grid on;

subplot(212), plot(t, y(:,2:3));
title('Ein- und Ausgang des Stellglieds');
grid on;
xlabel('Zeit in s');


