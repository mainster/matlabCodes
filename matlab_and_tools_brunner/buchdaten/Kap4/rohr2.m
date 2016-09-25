% Programm rohr2.m zur Parametrierung des Modell
% rohr_2.m, in dem die Bewegung einer Flüssigkeitsseule
% in einem U-Rohrmanometer untersucht wird

l = 8;          b = 4;
h0 = 0.1;       r = 0.5;
g = 9.89;

% -------- Anlaufverlauf der Drehgeschwindigkeit
step_v = 0.1;
omega_final = 2.5;

% -------- Sinusförmige Erregung für die Drehgeschwindigkeit
A = 0.5;
freq = 0.5;

% -------- Simulationsdauer
t0 = 0;         dt = 0.05;           tfinal = 200;
t = t0:dt:tfinal;

% -------- Aufruf der Simulation
my_options = simset('OutputVariables', ' ','SrcWorkspace','current');
[t,x,y] = sim('rohr_2' ,[t] ,my_options);

% -------- Darstellung der Ergebnisse
figure(1);       clf;
subplot(311), plot(simout(:,4), simout(:,3));
ylabel('Eingang');   grid;    
subplot(312), plot(simout(:,4), simout(:,2));
ylabel('Hoehe');   grid;    
subplot(313), plot(simout(:,4), simout(:,1));
ylabel('Geschwindigkeit');   grid;    

figure(2);      clf;
plot(simout(:,1), simout(:,2));
title('Phasenebene');
ylabel('Geschwindigkeit der Hoehenaenderung');
xlabel('Hoehe');  grid;





