% Programm mikrofon1.m zur Untersuchung des 
% Modells eines kapazitiven Mikrofon

% ------- Parameter des linearisierten SS-Modells
m = 1e-3;           % 1e-3 kg

alpha = 100; betha = 0.01; gamma = 100;
lamda = 0.001; delta = 0.001;

c = alpha*m;
d = betha*m;
R = gamma*m;
L = lamda*m;
q0_eA = delta*m

% Matrizen des SS-Modells
A = [0 1 0 0;-c/m, -d/m, q0_eA/m, 0;...
     0 0 0 1;q0_eA/L 0 0 -R/L]
B = [0, 1/m, 0, 1/L]';
C = [0 0 0 1];
D = 0;

% ------- LTI-Modell
my_sys = ss(A, B, C, D);

% ------- Frequenzgang und Sprungantwort
figure(1);      clf;
w = logspace(0,5,1000);
bode(my_sys,w);

figure(2);      clf;
step(my_sys,0.0002);
