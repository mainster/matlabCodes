% Programm (pol61.m) zur Durchführung der Simulation 
% eines Beobachters entworfen nach Katsuhiko Ogata 
% "Linear Control Systems with MATLAB"
% Prentice Hall 1994 mit Hilfe des Simulink-Modells
% s_pol6.mdl

%------- Ursprüngliches System
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
A = my_sys1.a;     B = my_sys1.b;
C = my_sys1.c;     D = my_sys1.d;

%------- Koeffizienten des charakteristischen Polynoms des Systems
a = poly(A);

%------- Bestimmung der Rückführungsmatrix Ke des Beobachters
%------- Gewünschte Pole für den Beobachter

p1 = -0.9+0.5*j*sqrt(3);	p2 = conj(p1);  
p3 = -1.0+0.5*j*sqrt(3);	p4 = conj(p3);
p5 = -1.1+0.5*j*sqrt(3);	p6 = conj(p5);

%------- Koeffizienten des charakteristischen Polynoms des Beobachters
Be = [p1 0 0 0 0 0;
     0 p2 0 0 0 0;
     0 0 p3 0 0 0;
     0 0 0 p4 0 0;
     0 0 0 0 p5 0;
     0 0 0 0 0 p6];
be = real(poly(Be));

%------- Beobachtbarkeitsmatrix
Ob = obsv(A,C);
if rank(Ob) < 6
   disp(' Das System ist nicht Beobachtbar !!!');
   return;
end;

[Ac,Bc,Cc,Dc,T] = canon(A,B,C,D,'companion');
Tn = zeros(6,6);
for q = 1:6
   for l = 1:6
     Tn(q,l) = T(q,7-l);
   end;
end;

Q = inv(Tn*Ob');
Ke = Q*(be(7:-1:2)-a(7:-1:2))'

e = eig(A-Ke*C)	% Eigenwerte des Beobachters als Probe

%------- Antwort des Systems und des Beobachters
my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'txy');
[t,x,y] = sim('s_pol6', [0, 100], my_opt);    
  
figure(1);	clf;
subplot(211), plot(t,x(:,1),t,x(:,7));
title('x1 und geschaetzte x1');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,3),t,x(:,9));
title('x3 und geschaetzte x3');
grid;	xlabel('Zeit in s')

figure(2);	clf;
subplot(211), plot(t,x(:,5),t,x(:,11));
title('x5 und geschaetzte x5');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,6),t,x(:,12));
title('x6 und geschaetzte x6');
grid;	xlabel('Zeit in s')

