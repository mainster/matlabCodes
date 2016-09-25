% Programm inv_pendel_3.m zur Parametrierung des Modells
% inv_pendel3.mdl 

clear;
% -------- Pendel-System
M = 5;          % Masse des Wagens
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

