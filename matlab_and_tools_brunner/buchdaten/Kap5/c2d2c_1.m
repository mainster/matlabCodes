% Programm c2d2c_1.m zum Experimentieren mit 
% Umwandlungsfunktionen c2d 

% ------- Umwandlung c2d
% SISO-System
sysc = tf(1, [1, 0.5 1]);


sysd1 = c2d(sysc, 1, 'zoh');
sysd2 = c2d(sysc, 1, 'foh');
sysd3 = c2d(sysc, 1, 'tustin');
sysd4 = c2d(sysc, 1, 'prewarp', 0.4);
sysd5 = c2d(sysc, 1, 'matched');

figure(1);     clf;
step(sysc);
hold on
step(sysd1);
step(sysd2);
step(sysd3);
step(sysd4);
step(sysd5);
hold off
