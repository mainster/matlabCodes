% Programm (kalm4.m) zur Durchführung der Simulation 
% eines diskreten Kalman-Filters als Zustandsschätzer 
% für eine LQG-Regelung
% Es wird das SIMULINK-Modells s_kalm1.mdl benutzt
%
% Testaufruf: kalm4;

clear
% -------Das Schwingungssystem
D12 = 1;	D23 = 1;
r12 = 0.1;	r23 = 0.5;
m1 = 0.8;		m2 =1;		m3 = 0.5;

A = zeros(6,6);
A(1:3,4:6) = eye(3,3);
A(4,1) = -D12/m1;	A(4,2) = -A(4,1);
A(4,4) = -r12/m1;	A(4,5) = -A(4,4);

A(5,1) = D12/m2;	A(5,2) = -(D12+D23)/m2;
A(5,3) = D23/m2;	A(5,4) = r12/m2;
A(5,5) = -(r12+r23)/m2;	A(5,6) = r23/m2;

A(6,2) = D23/m3;	A(6,3) = -A(6,2);
A(6,5) = r23/m3;	A(6,6) = -r23/m3;

B = [zeros(3,3); 1/m1, 0, 0; 0, 1/m2, 0; 0, 0, 1/m3];
C = [eye(3,3), zeros(3,3)];	D = zeros(3,3);

[ns,ns] = size(A);
[nx,no] = size(B);          % no Eingänge

Ts = 0.25;			        % Abtastperiode
[Ad, Bd] = c2d(A,B,Ts);		% Diskretes Modell
Cd = C;		Dd = D;

%--------Prozeßrauschen und Meßrauschen
% qp = 1;			qm = 0.001;	% Leistungsdichten
qw = 0.01;			rv = 0.001;	% Leistungsdichten
Qw = eye(3,3)*qw;	Rv = eye(3,3)*rv;
G = B;

%--------Diskretes Kalman-Filter
[L, M, P, Ek] = lqed(A, G, C, Qw, Rv, Ts) 

%-------LQR-Regelung
%-------Gewichtungen für den Fehler (Zustand) und Steuerung
Qr = eye(ns,ns)*1;    
Qr(1:3,1:3) = 100*eye(3,3); 	% Die Bewegungen sind die Ausgänge
Rr = eye(3,3)*0.1;

%-------Optimale Rückführung
[K, S, Elqr] = lqrd(A,B,Qr,Rr,Ts)
K_temp = K;
F = [ones(3,1); zeros(3,1)];	% Führungsmatrix

% -------Antwort des Kalman-Filters und der LQG-Regelung
dt = 0.1;
my_opt = simset('OutputVariables', 'txy');
[t,x,y] = sim('s_kalm4', [0:dt:25], my_opt);    

% -------Antwort des Kalman-Filters ohne LQG-Regelung
K = K*0;		
my_opt = simset('OutputVariables', 'txy');
[t1,x1,y1] = sim('s_kalm4', [0:dt:25], my_opt);    % SIMULINK 2


K = K_temp;
figure(1);	clf;
subplot(211), plot(t1,x1(:,3));
title('Bewegung x3 ohne LQG-Regelung');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,3));
title('Bewegung x3 mit LQG-Regelung');
grid;	xlabel('Zeit in s')

figure(2);	clf;
subplot(211), plot(t,x(:,3));
title('Bewegung x3 mit LQR-Regelung');
grid;	xlabel('Zeit in s')
subplot(212), plot(t, y(:,6));
title('Steuerung F3 der LQR-Regelung');
grid;	xlabel('Zeit in s')

figure(3);	clf;
subplot(211), plot(t1,x1(:,6),t1,x1(:,12));
title('Geschwindigkeit x6 und geschaetzte x6 ohne LQG-Regelung');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,x(:,6),t,x(:,12));
title('Geschwindigkeit x6 und geschaetzte x6 mit LQR-Regelung');
grid;	xlabel('Zeit in s')

