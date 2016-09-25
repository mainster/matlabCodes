% Programm inv_pendel_3.m zur Parametrierung des Modells
% inv_pendel3.mdl 

clear;
% -------- Pendel-System
M = 5;          % Masse des Wagens
m = 0.5;        % Masse des Pendels (konzentriert am Ende)
l = 0.75;       % L�nge des Pendels
g = 9.89;

a = [0,1,0,0;(M+m)*g/(M*l),0,0,0;0,0,0,1;-m*g/M,0,0,0];

b = [0,-1/(M*l),0,1/M]';

c = eye(4,4);   % Alle Zustandsvariablen sind auch Ausg�nge

d = zeros(4,1);

my_sys = ss(a,b,c,d);

% ------- Eigenwerte des Systems (Polstellen)
Eigenwerte_0 = eig(a)

% ------- Regler �ber alle Zustandsvariablen
% f�r Polplatzierung

p = [-1+j*1.5, -1-j*1.5, -3, -1.5];    % Gew�nschte Pole 
K = place(a,b,p);                       % R�ckkopplungsmatrix
disp(['Ruekopplungsmatrix = ',num2str(K)]);

