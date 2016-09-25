% Programm inv_pendel_2.m zur Untersuchung eines SS-Systems
% in Form eines inversen Pendel-Systems
% Es benötigt das Simulink-Modell inv_pendel2.mdl

% -------- Pendel-System
M = 5;          % Masse des Wegelchens
m = 0.5;        % Masse des Pendels (konzentriert am Ende)
l = 0.75;       % Länge des Pendels
g = 9.89;

a = [0,1,0,0;(M+m)*g/(M*l),0,0,0;0,0,0,1;-m*g/M,0,0,0];

b = [0,-1/(M*l),0,1/M]';

c = eye(4,4);   % Alle Zustandsvariablen sind auch Ausgänge

d = zeros(4,1);

my_sys = ss(a,b,c,d);

% ------- Eigenwerte des Systems (Polstellen)
Eigenwerte_0 = eig(a)

% ------- Regler über alle Zustandsvariablen
% für Polplatzierung

p = [-1+j*1.5, -1-j*1.5, -3, -1.5];    % Gewünschte Pole 
K = place(a,b,p);                       % Rückkopplungsmatrix
disp(['Ruekopplungsmatrix = ',num2str(K)]);

sys_regler = tf({K(1), K(2), K(3), K(4)},{1, 1, 1, 1});   % Rückkopplungssystem

% ------- Gesamtsystem (mit Rückkopplung)
sys = feedback(my_sys, sys_regler);
v = ltiview(sys);

Eigenwerte_1 = eig(sys.a)

% ------- Simulation mit Simulink-Modell

my_options = simset('OutputVariables','ty');
[t,x,y] = sim('inv_pendel2',[0:0.1:10], my_options);

figure(1);     clf;
subplot(211), plot(t, y(:,2:5));
title('Winkel, Winkelgeschwindigkeit, Weg und Geschwindigkeit');
grid;   xlabel('Zeit in s');
subplot(212), plot(t, y(:,1));
title('Stellgröße (Kraft auf das System)');
grid;   xlabel('Zeit in s');




