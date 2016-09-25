% Programm bohrhammer2.m zur Bildung des SS-Modells
% eines hydraulischen Bohrhammers und Untersuchung 
% der Kraftanregung mit dem Simulink-Modell bohrhammer_2.mdl 

% ------- Parameter des Systems
c = 8.8e5;       % Federsteifigkeit der Hydraulikflüssigkeit in N/m^2
d = 22.2;        % Dämpfung in Ns/m
m1 = 0.014;      % in kg
mk = 0.0565;     % in kg

% ------- Matrizen des SS-Modells
A = [0 1 0 0;-c/mk, -d/mk, c/mk, d/mk;...
     0 0 0 1; c/m1,  d/m1, -2*c/m1, -2*d/m1];
B = [0, 1/mk,0,0]';
C = [0,0,c,d];
D = 0;

% ------- SS-LTI-Modell
my_sys = ss(A, B, C, D)

% ------- Aufruf der Simulation 
T = 0.01;        % Periode der Anregungspulse
dt = 0.01;       % Dauer der Pulse in % relativ zur Periode

sim('bohrhammer_2',[0,0.1]);    % Ergebnisse in tout, yout

% ------- Darstellung der Antwort
figure(1);      clf;
plot(tout, yout);
title(['Antwort auf Pulse der Periode T = ',...
    num2str(T),'s und relativer Dauer dt/T = ',...
    num2str(dt),' %']);
xlabel('Zeit in s');
