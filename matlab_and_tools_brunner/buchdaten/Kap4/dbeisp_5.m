% Programm (dbeisp_5.m) zur Darstellung der Ergebnisse 
% des Modells beisp_5.mdl

%------- Darstellung der Variablen die über den Outport
%        der MATLAB-Umgebung übertragen wurden
%        tout und yout
figure(2);      clf;
subplot(211), plot(tout, yout(:,1:3));
xlabel('Zeit in s');     grid;
title('Variablen yout nach tout');
subplot(212), stairs(tout, yout(:,4));
xlabel('Zeit in s');     grid;
title('Rauschsignal');

%------- Darstellung der Variablen die über der To-Workspace
%        Senke der MATLAB-Umgebung übertragen wurden
%        zeit und simout
figure(3);      clf;
subplot(211), plot(zeit, simout(:,1:3));
xlabel('Zeit in s');     grid;
title('Variablen simout nach zeit');
subplot(212), stairs(zeit, simout(:,4));
xlabel('Zeit in s');     grid;
title('Rauschsignal');

%------- Anzahl der Schritte der Simulation
n = length(zeit);
disp(['Anzahl der Schritte der Simulation = ',num2str(n)]);

%------- Schrittweite der Simulation
Schrittweite = diff(zeit)

