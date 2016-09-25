% Programm (control_ident2.m) zur Untersuchung einer 
% Umwandlung von einem id-Modell zu einem LTI-Objekt 

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


% -------- Frequenzgang
figure(1);      clf;
disp('Die einzelnen Frequenzgaenge erhaelt man mit CR');
bode(my_sys_id, my_sys_lti)

% -------- Sprungantwort
figure(2);      clf;
step(my_sys_lti)
