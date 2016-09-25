% Programm pendel_1.m zur Parametrierung und Aufrufen des 
% Modells pendel1.mdl, in dem ein nichtlineares Pendel simuliert ist

% ------ Parameter
m = 500; 
r = 1000;
g = 9.8;
theta0 = 20*pi/180;

l0 = 5;           % Anfangslänge des Pendels
v = 1;            % Änderungsgeschwindigkeit der Länge des Pendels

% ------- Aufruf der Simulation 
my_options = simset('OutputVariables', ' ');
[t,x,y] = sim('pendel2', [0:0.1:50], my_options);

% ------- Darstellung der Ergebnisse
figure(1);    clf;
subplot(211), plot(simout(:,3), simout(:,1));
title('Winkel des Pendels');
xlabel('s');  grid;

subplot(212), plot(simout(:,3), simout(:,2));
title('Winkelgeschwindigkeit');
xlabel('s');  grid;

figure(2);    clf;
plot(simout(:,1),simout(:,2));
title('Phasenebene');  xlabel('Winkel');   
ylabel('Winkelgeschwindigkeit');    grid;
