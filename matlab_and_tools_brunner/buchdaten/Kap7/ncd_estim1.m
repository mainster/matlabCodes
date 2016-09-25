% Programm ncd_estim1.m zur Optimierung der LQRG-Regelung mit Hilfe des NCD-
% Optimierungsprozesses.
% Benutzt das Modell ncd_estim_1.mdl 

%------- System 6. Ordnung
%------- Eigenfrequenzen und Dämpfungsfaktoren
w01 = 1;	zeta1 = 0.1;	% Erster Abschnitt
w02 = 0.8;	zeta2 = 0.1;	% Zweiter Abschnitt 
w03 = 0.6;	zeta3 = 0.1;	% Dritter Abschnitt

%------- Übertragungsfunktionen der Abschnitte
zaehler1 = 1;	nenner1 = [1/(w01^2), 2*zeta1/w01, 1];
zaehler2 = 1;	nenner2 = [1/(w02^2), 2*zeta2/w02, 1];
zaehler3 = 1;	nenner3 = [1/(w03^2), 2*zeta3/w03, 1];

%------- Übertragungsfunktion des Systems
my_sys = tf(zaehler3, nenner3)*tf(zaehler2, nenner2)*tf(zaehler1, nenner1);
my_sys1 = ss(my_sys);	% Zustandsmodell
A = my_sys1.a;               B = my_sys1.b;
C = my_sys1.c;               D = my_sys1.d;
[ns,ns] = size(A);

% ------- Zustand-Estimator
p = zeros(1,ns);
p(1:3) = -(1:3)/2;  p(4) = -4+j*3;  p(5) = conj(p(4)); p(6) = -4;   
L = place(A, B, p)';

estim_1 = estim(my_sys1, L, 1, 1);

% --------- LQG-Regelung
Q = eye(ns,ns)*10;      % Kosten der Abweichung der Zustandsvariablen
R = 1;                  % Kosten der Steuerung

K = lqr(A,B,Q,R);       % LQR-Regelungsmatrix

% --------- Optimierungsvariablen
ki = 1;
k1 = K(1); k2 = K(2); k3 = K(3); k4 = K(4); k5 = K(5); k6 = K(6);




