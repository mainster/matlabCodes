% Skript inport_block1.m in dem das Modell inport_block_1.mdl
% aufgerufen wird
% Die Daten für den Inport-Block müssen in Form [t,u] vorliegen
clear;
% ------- Zeitschritte
Tfinal = 10;
dt = Tfinal/1000;
t = (0:dt:Tfinal-dt)';
% ------- Signal
u = 2.5*sin(2*pi*t/2);
[t, u]
% ------- Aufruf der Simulation
sim('inport_block_1', t);