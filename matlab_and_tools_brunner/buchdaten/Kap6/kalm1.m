% Programm (kalm1.m) zur Durchführung der Simulation 
% eines Kalman-Filters als Zustandsschätzer 
% Es wird das SIMULINK-Modells s_kalm1.mdl benutzt
%
% Testaufruf: kalm1;

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

%--------Prozeßrauschen und Meßrauschen
qw = 0.1;		qv = 0.2;	% Leistungsdichten
Qw = eye(ns,ns)*qw;	              Rv = qv;
G = eye(ns,ns);

%--------Kalman-Filter
[L, P, E] = lqe(A, G, C, Qw, Rv)  

% -------Antwort des Systems und des Kalman-Filters
dt = 0.1;
my_opt = simset('OutputVariables', 'txy');
[t,x,y] = sim('s_kalm1', [0:dt:100], my_opt);    

figure(1);	clf;
subplot(211), plot(t, y(:,2));
title('Ausgang des Prozesses (mit Prozessrauschen)');
grid;	xlabel('Zeit in s')
subplot(212), plot(t, y(:,1));
title('Ausgang des Prozesses mit Prozess- und Messrauschen');
grid;	xlabel('Zeit in s')


figure(2);	clf;
subplot(211), plot(t,x(:,2),t,x(:,8));
title('Zustandsvariable x2 und geschaetzte x2');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,3),t,x(:,9));
title('Zustandsvariable x3 und geschaetzte x3');
grid;	xlabel('Zeit in s')

figure(3);	clf;
subplot(211), plot(t,x(:,1),t,x(:,7));
title('Zustandsvariable x1 und geschaetzte x1');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,6),t,x(:,12));
title('Zustandsvariabel x6 und geschaetzte x6');
grid;	xlabel('Zeit in s')

% -------Relativer Fehler
leistung = sum(x(:,1:6).*x(:,1:6))/length(x(:,1))    % Leistung der Zustandsvariablen

r_leistung = diag(P)'./leistung          % Relativer Fehler

