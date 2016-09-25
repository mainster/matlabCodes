% Programm (control_ident3.m) zur Untersuchung einer 
% Umwandlung von einem id-Modell zu einem LTI-Objekt und dessen Simulation

% -------- id-Modell
A = conv([1,-(0.8+j*0.5)],[1,-(0.8-j*0.5)])
B = 1;
C = [1,1];
D = 1;
F = 1;
sigma_noise = 2;
Ts = 0.5;

my_sys_id = idpoly(A,B,C,D,F,sigma_noise,Ts)

% ------- Umwandlung in einem LTI-Modell
my_sys_lti = ss(my_sys_id)


% ------- Simulation mit Modell control_ident_3.mdl
% Simulation ohne Störeffekt 
a = 0;           % Der zweite Eingang wird mit 0 gewichtet
my_options = simset('OutputVariables','ty');
[t,x,y] = sim('control_ident_3',[0, 50], my_options);

% ------- Darstellung der Sprungantwort ohne Störeinfluß
figure(1);     clf;
stairs(t, y(:,1));
title('Sprungantwort ohne Stoerungseinfluss');
xlabel('Zeit in s');     grid;

% Simulation mit Störeffekt 
a = 1;           % Der zweite Eingang wird mit 0 gewichtet
my_options = simset('OutputVariables','ty');
[t,x,y] = sim('control_ident_3',[0, 50], my_options);

% ------- Darstellung der Sprungantwort ohne Störeinfluß
figure(2);     clf;
subplot(211), stairs(t, y(:,2));
title('Stoereingang der Varianz 1');
xlabel('Zeit in s');     grid;

subplot(212), stairs(t, y(:,1));
title('Sprungantwort mit Stoerungseinfluss');
xlabel('Zeit in s');     grid;
