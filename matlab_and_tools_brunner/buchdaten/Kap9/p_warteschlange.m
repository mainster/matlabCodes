% Programm p_warteschlange.m zum Aufruf der 
% Simulation mit dem Modell warteschlange.mdl

% ------- Initialisierungen
imin = 2;      imax = 20;
smin = 4;      smax = 10;

rand('state',0);       % Ergibt dieselbe Zufallssequenz

% ------- Aufruf der Simulation
sim('warteschlange');     % Ergebnisse: tout und yout

figure(1);      clf;
plot(tout, yout)
title(['Anzahl Kunden; imin = ',num2str(imin),...
                    ', imax = ',num2str(imax),...
                    ', smin = ',num2str(smin),...
                    ', smax = ',num2str(smax)]);
            
                      
