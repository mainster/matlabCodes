% Programm (dbeisp_3.m) zur Darstellung der Ergebnisse 
% des Modells beisp_3.mdl

%------- Darstellung der Variablen die �ber den Outport
%        der MATLAB-Umgebung �bertragen wurden
%        tout und yout
figure(1);      clf;
plot(tout, yout);
xlabel('Zeit in s');     grid;
title('Variablen yout nach tout');
%------- Darstellung der Variablen die �ber der To-Workspace
%        Senke der MATLAB-Umgebung �bertragen wurden
%        zeit und simout
figure(2);      clf;
plot(zeit, simout);
xlabel('Zeit in s');     grid;
title('Variablen simout nach zeit');

%------- Anzahl der Schritte der Simulation
n = length(zeit);
disp(['Anzahl der Schritte der Simulation = ',num2str(n)]);

%------- Schrittweite der Simulation
Schrittweite = diff(zeit)

