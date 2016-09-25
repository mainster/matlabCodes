% Programm (lqr_2.m) zur Durchf�hrung der Simulation einer optimalen 
% LQR-Regelung ("Linear-Quadratic-Regulator") mit Beobachter 
% im Simulink-Modells s_lqr2.mdl 
%
% Testaufruf: lqr_2;
 
% -------Urspr�ngliches System
% -------Eigenfrequenzen und D�mpfungsfaktoren
w01 = 1;	zeta1 = 0.1;	% Erster Abschnitt
w02 = 0.8;	zeta2 = 0.1;	% Zweiter Abschnitt 
w03 = 0.6;	zeta3 = 0.1;	% Dritter Abschnitt

% -------�bertragungsfunktionen der Abschnitte
zaehler1 = 1;	nenner1 = [1/(w01^2), 2*zeta1/w01, 1];
zaehler2 = 1;	nenner2 = [1/(w02^2), 2*zeta2/w02, 1];
zaehler3 = 1;	nenner3 = [1/(w03^2), 2*zeta3/w03, 1];

% -------�bertragungsfunktion des Systems
my_sys = tf(zaehler3, nenner3)*tf(zaehler2, nenner2)*tf(zaehler1, nenner1);
my_sys1 = ss(my_sys);	% Zustandsmodell
A = my_sys1.a;     B = my_sys1.b;
C = my_sys1.c;     D = my_sys1.d;
C                       % Um zu zeigen, dass C6 nicht 1 ist
[n,m] = size(A);

% -------Bestimmung der R�ckf�hrungsmatrix Ke des Beobachters
% -------Gew�nschte Pole f�r den Beobachter
p1 = -0.9+0.5*j*sqrt(3);	p2 = conj(p1);  
p3 = -1.0+0.5*j*sqrt(3);	p4 = conj(p3);
p5 = -1.1+0.5*j*sqrt(3);	p6 = conj(p5);

p = [p1; p2; p3; p4; p5; p6];

% -------Beobachtbarkeitsmatrix
Ob = obsv(A,C);
if rank(Ob) < 6
   disp(' Das System ist nicht Beobachtbar !!!');
   return;
end;

K = place(A',C',p);	% R�ckf�hrung f�r den 
Ke = K'			    % Beobachter
e = eig(A-Ke*C)		% Eigenwerte des Beobachters als Probe

%-------LQR-Regelung
%-------Gewichtungen f�r den Fehler (Zustand) und Steuerung
Q = eye(n,n);	Q(6,6) = 500;	% Die sechste Variable ist der Ausgang
R = 0.1;
%-------Optimale R�ckf�hrung
[K, S, E] = lqr(A,B,Q,R);
k15 = [K(1:n-1),0];	
k6 = K(n);
K, S, E,

% -------Antwort des Systems (Aufruf der Simulation)
randn('seed',1357);
x0 = [randn(1,6)]*2	% Beliebige Anfangsbedingungen

my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'txy');
[t,x,y] = sim('s_lqr2', [0, 20], my_opt);    

figure(1);	clf;
subplot(211), plot(t,x(:,1),t,x(:,2),t,x(:,3));
title('x1, x2, x3');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,4),t,x(:,5),t,x(:,6));
title('x4, x5, x6');
grid;	xlabel('Zeit in s')

figure(2);	clf;
subplot(211), plot(t,y(:,1),t,y(:,2));
title('Ausgang und Fehler');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x);
title('x1 bis x6 vom Prozess und Beobachter');
grid;	xlabel('Zeit in s')

