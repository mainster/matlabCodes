% Programm bohrhammer1.m zur Bildung des SS-Modells
% eines hydraulischen Bohrhammers

% ------- Parameter des Systems
c = 8.8e5;       % Federsteifigkeit der Hydraulikflüssigkeit in N/m^2
d = 22.2;        % Dämpfung in Ns/m
m1 = 0.014;      % in kg
mk = 0.0565;     % in kg

% ------- Matrizen des SS-Modells
A = [0 1 0 0;-c/mk, -d/mk, c/mk, d/mk;...
     0 0 0 1; c/m1,  d/m1, -2*c/m1, -2*d/m1];
B = [0, 1/mk,0,0]';
C = [0,0,c,d];
D = 0;

% ------- SS-LTI-Modell
my_sys = ss(A, B, C, D)

% ------- Pole oder Eigenwerte des Systems
Eg = eig(A)

% ------- Bode-Diagramm
figure(1);      clf;
w = logspace(3,5,500);
bode(my_sys, w);

% ------- Sprungantwort
figure(2);      clf;
step(my_sys);

% ------- Eigenfrequenzen und Dämpfungen
p = find(imag(Eg) >= 0);
alpha = (imag(Eg(p))./-real(Eg(p))).^2;
D = sqrt(1./(1+alpha))
f0 = (-real(Eg(p))./D)/(2*pi)

% ------- Umwandlung in TF-Modell
my_sys1 = tf(my_sys)