% Skript erben_1_ursp1.m, zur Parametrierung und Aufrufs
% des Modells erben_1_ursp_1.mdl
clear;
% ------- Parameter des Modells
ampl = 1;      % Amplitude für Block Sine Wave
Ts = 1/1000;   % Abtastperiode der zeitdiskreten Signale
Tfinal = 0.1;  % Simulationszeit
td = 0:Ts:Tfinal-Ts;
ntd = length(td);
u1 = filter(fir1(32, 0.4), 1, randn(1,ntd));  % Anregung für 'From Workspace'
simin = [td',u1'];  % Matrix für 'From Workspace'
% ------- Aufruf der Simulation
[t,x,y] = sim('erben_1_ursp_1', [0:Ts/5:Tfinal]);
% In y sind in drei Spalten die Variablen vom Outport Out1
figure(1),   clf;
stairs(t, y(:,1));
   axis tight;     hold on;
stairs(t, y(:,2),'r');
plot(t, y(:,3), 'g');
   hold off;
   title('Signale des Outports Out1');   grid on;
   xlabel('Zeit in s');
La = axis;   axis([0.05, 0.07, -1.2 1.2]); % Ausschnitt
