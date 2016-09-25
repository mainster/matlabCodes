% Programm (akalm1.m) zur Parametrierung und Durchführung 
% der Simulation eines diskreten Kalman-Filters als Zustandschätzer 
% für eine LQG-Regelung
% Benuzt das SIMULINK-Modell s_akalm1.mdl 
%
% Testaufruf: akalm1;

% ------Der Prozeß
prozess = tf(1, [1, 0.5, 1])*tf(1, [2, 1]);

%-------Zustandsmodell des Prozesses
prozess_ss = ss(prozess);
Ap = prozess_ss.a;        Bp = prozess_ss.b;
Cp = prozess_ss.c;        Dp = prozess_ss.d;
[np, mp] = size(Ap);

%------Die Störung
stoerung = tf(1,[0.5, 1]);

%-------Zustandsmodell der Störung
stoerung_ss = ss(stoerung);
As = stoerung_ss.a;        Bs = stoerung_ss.b;
Cs = stoerung_ss.c;        Ds = stoerung_ss.d;
[ns, ms] = size(As);

%------Gesamt Modell
A = [Ap, Bp*Cs; zeros(ns,np), As];
B = [Bp; zeros(ns,1)];	
G = [zeros(np,1); Bs];
C = [Cp, zeros(1,ns)];
D = [0];

%--------Prozeßrauschen und Meßrauschen
qp = 0.01;		qm = 0.01;	% Leistungsdichten
Qw = qp;		Rv = qm;

%--------Diskretes Kalman-Filter
Ts = 0.25;			% Abtastperiode
[L, M, P, Ek] = lqed(A, G, C, Qw, Rv, Ts) 

%-------LQR-Regelung für den Steuerbaren Teil
%-------Gewichtungen für den Fehler (Zustand) und Steuerung
Qr = eye(np,np)*1;    
Qr(3,3) = 100; 		% Die x3 ist der Ausgang
Rr = 0.1

%-------Optimale Rückführung
[K, S, Elqr] = lqrd(Ap,Bp,Qr,Rr,Ts);

%-------Führungsmatrix
yp_un = 1;
up_un = yp_un/(Cp*(-inv(Ap)*Bp));
xp_un = (-inv(Ap)*Bp)*up_un;

alpha = up_un/(K*xp_un)+1
F = xp_un*alpha

%-------Diskretes Modell für die Simulation des Kalman-Filters
[Ad, Bd] = c2d(A,B,Ts);		% Diskretes Modell
Cd = C;		Dd = D;
Extr_p = [eye(np,np), zeros(np,ns)];	% Steuerbarer Zustandsvektor
  
% -------Antwort des Kalman-Filters und der LQG-Regelung
t_final = 10;
min_step = 0.1; 	max_step = min_step;

my_opt = simset('OutputVariables', 'ty');
[t,x,y] = sim('s_akalm1', [0:min_step:t_final], my_opt);    

figure(1);	clf;
subplot(211), plot(t,y(:,1));
title('Ausgang mit Messrauschen (Einheitssprung bei 2,5 s)');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,y(:,2));
title('Steuerung');
grid;	xlabel('Zeit in s')

