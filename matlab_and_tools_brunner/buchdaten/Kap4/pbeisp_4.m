% Programm (pbeisp_4.m) zur Parametrierung des Modells 
% beisp_4.mdl

t1 = 0:0.01:10;               u1 = sin(2*pi*t1/1.5);
t2 = 0:0.02:10;               u2 = sign(cos(2*pi*t2/2));

A1 = [t1',u1'];               A2 = [t2',u2'];   
