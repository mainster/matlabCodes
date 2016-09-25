% Programm spring_ball_darstell.m zum Aufruf 
% der Simulation mit dem Modell spring_ball.mdlund 
% und Darstellung der Ballposition und Ballgeschwindigkeit 

% ------- Aufruf der Simulation
sim('spring_ball',[0, 15]);      % Ergebnisse in tout und yout

% ------- Darstellung der Ergebnisse 
figure(1);         
plot(tout, yout)
title('Ballposition und Ballgeschwindigkeit')
xlabel('Zeit in s');
grid
 
