% Programm (pol7.m) zur Durchführung der Simulation
% eines Beobachters mit Hilfe des Simulink-Modells s_pol7.mdl 
%
% Testaufruf: pol7;

% -------Ursprüngliches System
% -------Eigenfrequenzen und Dämpfungsfaktoren
w01 = 1;	zeta1 = 0.1;	% Erster Abschnitt
w02 = 0.8;	zeta2 = 0.1;	% Zweiter Abschnitt 
w03 = 0.6;	zeta3 = 0.1;	% Dritter Abschnitt

% -------Übertragungsfunktionen der Abschnitte
zaehler1 = 1;	nenner1 = [1/(w01^2), 2*zeta1/w01, 1];
zaehler2 = 1;	nenner2 = [1/(w02^2), 2*zeta2/w02, 1];
zaehler3 = 1;	nenner3 = [1/(w03^2), 2*zeta3/w03, 1];

% -------Übertragungsfunktion des Systems
my_sys = tf(zaehler3, nenner3)*tf(zaehler2, nenner2)*tf(zaehler1, nenner1);
my_sys1 = ss(my_sys);	% Zustandsmodell
A = my_sys1.a;     B = my_sys1.b;
C = my_sys1.c;     D = my_sys1.d;

% -------Bestimmung der Rückführungsmatrix Ke des Beobachters
% -------Gewünschte Pole für den Beobachter
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

K = place(A',C',p);	% Rückführung für den 
Ke = K'			    % Beobachter
e = eig(A-Ke*C)		% Eigenwerte des Beobachters als Probe

% -------Rückführung für die Polplatzierung des 
% -------erweiterte Modells mit I-Anteil (wie im Programm pol5.m)

[n,m] = size(A); 
An = [A, zeros(n,1); -C, 0];	% Erweiterte A-Matrix
Bn = [B; 0];			% Erweiterte B-Matrix

%------- Gewünschte Pole für das erweiterte System
p1 = -0.5+j*1;		p2 = conj(p1);  
p3 = -0.3+j*0.6;	p4 = conj(p3);
p5 = -0.2+j*0.4;	p6 = conj(p5);
p7 = -2;

p = [p1; p2; p3; p4; p5; p6; p7];

%------- Erweiterte Rückführungsmatrix
Kn = place(An, Bn, p)
K = Kn(1:n)			    % Teil-Rückführungsmatrix		
ki = -Kn(n+1)			% I-Gewichtung

% -------Antwort des Systems und des Beobachters
my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'txy');
[t,x,y] = sim('s_pol7', [0, 100], my_opt);    
  
figure(1);	clf;
subplot(211), plot(t,x(:,2),t,x(:,8));
title('x2 und geschaetzte x2');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,3),t,x(:,9));
title('x3 und geschaetzte x3');
grid;	xlabel('Zeit in s')

figure(2);	clf;
subplot(211), plot(t,y(:,1));
title('Sprungantwort (Ausgang)');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,y(:,2));
title('Differenz Ausgang - Ausgang-Beobachter');
grid;	xlabel('Zeit in s')

