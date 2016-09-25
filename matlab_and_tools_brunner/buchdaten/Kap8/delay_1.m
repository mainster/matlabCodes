% Programm (delay_1.m) zur Untersuchung des 
% Unterschieds und Ähnlichkeit zwischen der 
% Eigenschaft InputDelay und Verspätung nk

clear
% -------- LTI-Modell für Daten
Ts = 0.5;
my_sys = tf({1, [0.1,1],1,1},{[0.2,1],[1,0.5,1],[0.5,1],1},'InputDelay',[3*Ts,2*Ts,0,0])
                              % System 4. Ordnung mit 3 Steuereingängen und einem Ausgang
                              % und ein zusätzlicher Eingang für das Meßrauschen
my_sys_d = c2d(my_sys, Ts)

% -------- id-Modell
my_sys_id = idss(my_sys_d, 'NoiseVar', 0.001)    
                              % Umwandlung in id-Modell

% -------- Eingangs- und Ausgangssignale
u = iddata([],idinput([400,3],'rgs'),Ts);
e = iddata([],randn(400,1),Ts);

y = sim(my_sys_id, [u,e]);
data_id = [y,u];

% -------- Identifikation
my_sys1 = pem(data_id, 4, 'InputDelay', [3,2,0])
my_sys2 = pem(data_id, 4, 'nk', [3,2,0])

% -------- Frequenzgang
figure(1);      clf;
disp('Die einzelnen Frequenzgaenge erhaelt man mit CR');
bode(my_sys_id, my_sys1, my_sys2);

figure(2);      clf;
step(my_sys_id, my_sys1, my_sys2);