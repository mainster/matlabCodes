% Programm (kalm3.m) zur Durchführung der Simulation 
% eines Kalman-Filters als als Zustandsschätzer für
% eine LQR-Regelung
% Es wird das SIMULINK-Modells s_kalm3.mdl benutzt 
%
% Testaufruf: kalm3;

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
[ns,ns] = size(A); 

%--------Diskretes Modell des Prozesses
Ts = 0.5;			            % Abtastperiode
[Ad, Bd] = c2d(A,B,Ts);		% Diskretes Modell
Cd = C;		Dd = D;

%--------Prozeßrauschen und Meßrauschen
qw = 0.1;		      qv = 0.02;	% Leistungsdichten
Qw = eye(ns,ns)*qw;	  Rv = qv;
G = eye(ns,ns);

%--------Diskretes Kalman-Filter
[L, M, P, E] = lqed(A, G, C, Qw, Rv, Ts) 

%-------LQR-Regelung
%-------Gewichtungen für den Fehler (Zustand) und Steuerung
Qr = eye(ns,ns)*1;    
Qr(ns,ns) = 100; 	% Die sechste Variable ist der Ausgang
Rr = 1;
%-------Optimale Rückführung
[K, S, E] = lqrd(A,B,Qr,Rr,Ts); 
K
S
E

% -------Antwort des Kalman-Filters und der LQG-Regelung
dt = 0.1;
my_opt = simset('OutputVariables', 'txy');
[t,x,y] = sim('s_kalm3', [0:dt:100], my_opt);    % SIMULINK 2

K = K*0;		% Ohne LQG-Regelung
my_opt = simset('OutputVariables', 'txy');
[t,x1,y1] = sim('s_kalm3', [0:dt:100], my_opt);    % SIMULINK 2

figure(1);	clf;
subplot(211), plot(t, y(:,2));
title('Ausgang des Prozesses (mit Prozessrauschen)');
grid;	xlabel('Zeit in s')
subplot(212), plot(t, y(:,1));
title('Ausgang des Prozesses mit Prozess- und Messrauschen');
grid;	xlabel('Zeit in s')

figure(2);	clf;
subplot(211), plot(t,y(:,2), t, y1(:,2));
title('Ausgang ohne Messrauschen mit und ohne LQG-Regelung');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,y(:,3), t,y1(:,3));
title(' Stellgliedsteuerung');
grid;	xlabel('Zeit in s');

figure(3);	clf;
subplot(211), plot(t,x(:,1),t,x(:,7));
title('Zustandsvariable x1 und geschaetzte x1');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,6),t,x(:,12));
title('Zustandsvariable x6 und geschaetzte x6');
grid;	xlabel('Zeit in s')



