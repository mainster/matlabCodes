% Programm ncd_pol1.m zur Polpaltzierung mit Hilfe des NCD-
% Optimierungsprozesses.
% Benutzt das Modell ncd_pol_1.mdl 

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

%------- System mit allen Zustandsvariablen als Ausgänge
C_n = eye(6,6);              D_n = 0;
my_sys_n = ss(A, B, C_n, D_n);

%------- Sprungantwort des Systems ohne Rückführung
figure(1);    clf;
[y,t] = step(my_sys_n);
plot(t, y(:,6)*C(6));
title('Sprungantwort ohne Rueckfuerung');
xlabel('Zeit in s');  grid;

% --------- Anfangswerte für die Rückführungsmatrix 
p = -(1:6)/2      % Gewünschte Pole

k = place(A, B, p) % Rückführungsmatrix

% --------- Optimierungsvariablen
k1 = k(1);
k2 = k(2); 
k3 = k(3);
k4 = k(4);
k5 = k(5);
k6 = k(6);

