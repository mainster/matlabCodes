% Programm inv_pendel_1.m zur Definition des SS-Systems
% eines inversen Pendel-Systems

M = 5;          % Masse des Wagens
m = 0.5;        % Masse des Pendels (konzentriert am Ende)
l = 0.75;       % Länge des Pendels
g = 9.89;

a = [0,1,0,0;(M+m)*g/(M*l),0,0,0;0,0,0,1;-m*g/M,0,0,0];

b = [0,-1/(M*l),0,1/M]';

c = [1,0,0,0;0,0,1,0];

d = 0;

% ------- Eigenwerte des Systems (Polstellen)
Eigenwerte = eig(a)            % Pole des Systems

% ------- Bildung des SS-Systems
my_sys = SS(a, b, c, d);
my_sys1 = my_sys(1,1);         % Subsystem von Eingang 1 zu Ausgang 1
my_sys2 = my_sys(2,1);         % Subsystem von Eingang 1 zu Ausgang 2

% ------- Aufruf der LTI-Viewers
v1 = ltiview(my_sys)
v2 = ltiview(my_sys1)
v3 = ltiview(my_sys2)
v4 = ltiview(my_sys1, my_sys2)




