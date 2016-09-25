% Programm gleit_komma_3.m zur Simulation
% der Fehler im Gleitkomma-Format bei der
% diskreten Integration 
%
% Arbeitet mit dem Modell gleit_komma3.mdl
%
% -------- Aufruf der Simulation
sim('gleit_komma3',[0, 10]);

% Darstellung der Ergebnisse
t = simout.time;
y1 = simout.signals.values(:,1);  % Lšsung der Differenzengleichung
y2 = simout.signals.values(:,2);  % Exponentialfunktion
y3 = simout.signals.values(:,3);  % Fehler

figure(1);   clf;
subplot(211), plot(t, [y1,y2]);
title('Exponentialfunktion und Loesung der Differenzengleichung');
xlabel('Zeit');    grid;

subplot(212), plot(t, y3);
title('Differenz zwischen der Exponentialfunktion und Loesung der Differentialgleichung');
xlabel('Zeit');    grid;




