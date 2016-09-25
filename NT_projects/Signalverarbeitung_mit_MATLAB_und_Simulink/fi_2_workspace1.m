% Programm fi_2_workspace1.m in dem fi-Daten aus der 
% MATLAB-Umgebung einem Modell (fi_2_worksp.mdl) transferiert werden
% bzw. aus dem Modell gelesen werden

u = fi(randn(1,1000));    % Zufallssequenz
% mit Default Parameter des fi-Objekts
u(1:20)

% --------- Bildung einer Struktur s
s.signals.values = u';     % Value-field der Struktur
s.signals.dimensions = 1;
Ts = 0.1;
s.time = [0:Ts:100-Ts]';   % Zeit-Feld
s
% --------- Aufruf des Modells
sim('fi_2_worksp',[0, 100]);
y
y.signals
y.signals.values(1:20)
