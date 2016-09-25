% Programm linea_1.m, in dem für das Modell
% linea1.mdl die Matrizen des Zustandsmodells ermittelt 
% werden und einige Eigenschaften des Modells untersucht werden

% Einsatzt der Funktion linmod
[a,b,c,d] = linmod('linea1');

% Frequenzgang des Systems
my_system = ss(a,b,c,d);        % Definition des Systems

% Frequenzgang
figure(1);      clf;
bode(my_system);

% Sprungantwort
figure(2);      clf;
step(my_system);
