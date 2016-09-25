% Programm c2d2c_3.m zum Experimentieren mit 
% Umwandlungsfunktionen d2c 

% ------- Umwandlung d2c
% SISO-System
sysc = tf(1, [1, 0.5, 1]);
sysd = c2d(sysc, 1);         % diskretes System

sysc1 = d2c(sysd,'zoh');
sysc2 = d2c(sysd,'tustin');
sysc3 = d2c(sysd,'prewarp', 0.4);

figure(1);     clf;
step(sysd);
hold on
step(sysc1);
step(sysc2);
step(sysc3);
hold off
