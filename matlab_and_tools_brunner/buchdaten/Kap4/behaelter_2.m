% Programm behaelter_2.m zur Parametrierung und Aufrufen des 
% Modells behaelter2.mdl, in dem ein schwingender Behälter
% simuliert wird

% ------ Parameter
g = 9.81;
dB = 0.3;
AB = pi*(dB^2)/4;
dL = 0.05;
AL = pi*(dL^2)/4;
m0 = 50;
ro = 1000;
h0 = m0/(ro*AB);
r = 2;
D = 100;
x0 = 0.5;

% ------- Aufruf der Simulation 
my_options = simset('OutputVariables', ' ');
[t,x,y] = sim('behaelter2', [0:0.01:20], my_options);

% ------- Darstellung der Ergebnisse
figure(1);    clf;
subplot(211), plot(simout(:,4), [simout(:,1), simout(:,2)]);
title(['Weg der Masse (x0 = ',num2str(x0),') und Höhe (h0 = ',num2str(h0),')']);
xlabel('s');  grid;

subplot(212), plot(simout(:,4), simout(:,3));
title('Austrittsgeschwindigkeit');
xlabel('s');  grid;

