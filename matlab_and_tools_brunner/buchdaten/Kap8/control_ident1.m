% Programm (control_ident1.m) zur Untersuchung einer 
% Umwandlung von einem LTI-Objekt zu einem id-Modell

% -------- LTI-Objekt vom Typ tf
my_sys1 = tf({1,[1,0];1,1;1,[1,0]},{[1,1],[0.5,1];[1,0.2,1],[1,0.5,1];[1,0],[1,1]})

my_sys = ss(my_sys1)       % SS-Model 6 Ordnung mit zwei Ausgängen und 3 Eingängen

% -------- Umwandlung in einem id-Modell
my_sys_id = idss(my_sys)

% -------- Frequenzgang
figure(1);      clf;
disp('Die einzelnen Frequenzgaenge erhaelt man mit CR');
bode(my_sys_id, my_sys)

% -------- Sprungantwort
figure(2);      clf;
step(my_sys_id, my_sys)