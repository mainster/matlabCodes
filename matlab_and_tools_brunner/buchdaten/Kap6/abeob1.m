% Programm (abeob1.m) zur Parametrierung und 
% Durchführung der Simulation eines diskreten Beobachters und
% einer LQR-Regelung
% Benutzt die SIMULINK-Modelle: s_proz2.mdl,
% s_abeob1.mdl und s_abeob2.mdl
% 
% Testaufruf: abeob1;

%------Ermittlung des Zustandsmodells
[A, B, C, D] = linmod('s_proz2');

T = [1 0 0 0; 0 0 0 1; 0 0 1 0; 0 1 0 0];
[A,B,C,D] = ss2ss(A,B,C,D,T);

%------Diskretisierung des Modells
Ts = 0.5;		% Abtastperiode
[Ad, Bd] = c2d(A,B,Ts);		Cd = C; 	Dd = D;

Co = ctrb(Ad,Bd);
if rank(Co) ~= 4
    disp(' Das System ist nicht Steuerbar !!!');
    return;
end;
Ob = obsv(Ad,Cd);
if rank(Ob) ~= 4
    disp(' Das System ist nicht Beobachtbar !!!');
    return;
end;

%------Beobachter
%------Pole des dikreten Beobachters 
p1 = 0.8+j*0.8;		p2 = conj(p1);
p3 = 0.85; 		p4 = 0.9;
p = [p1; p2; p3; p4]*0.5;
K = place(Ad', Cd', p);		% Beobachter Rückführungsmatrix
Ke = K'
%------Überprüfung der neuen Pole
eig(Ad-Ke*Cd)

%------Verhalten des Systems mit den neuen Polen
figure(1);		clf;
t_final= 100;	
x0 = [5, 0, 0, 0];	% Anfangsbedingung
min_step = 0.1;		max_step = min_step;

my_opt = simset('InitialStep', min_step, 'OutputVariables', 'txy');
[t,x,y] = sim('s_abeob1', [0, t_final], my_opt);    

n0 = 1;
nt = length(t);
subplot(211), plot(t(n0:nt), x(n0:nt,1:4));
title('Zustandsvariablen des Prozesses fuer x(0) = [ 5 0 0 0 ]');
xlabel('Zeit in s');	grid;
subplot(212), plot(t(n0:nt), x(n0:nt,5:8));
title('Zustandsvariablen des Beobachters fuer x(0) = [ 5 0 0 0 ]');
xlabel('Zeit in s');	grid;

%------Führungsregelung 
Q = eye(4,4);	Q(1,1) = 100;		R = 1;

K = lqrd(A, B, Q, R, Ts);

kq1 = K(1); 	kq2 = K(2);	
kq3 = K(3);	kq4 = K(4);

%-----Bestimmung der Führungsmatrix
x_un = inv(A-B*K)*(-B*kq1);

% x_un = x_un/x_un(1);		%-----Verfahren Nr. 1
% F = -B'*(A-B*K)*x_un/k1;
% F = 1/x_un(1);	      	%-----Verfahren Nr. 2
F = K*(x_un/x_un(1))/kq1	%-----Verfahren Nr. 3

%------Verhalten des Regelungssystems
figure(2); 		clf;
min_step = 0.05;	max_step = min_step;
t_final = 15;

my_opt = simset('InitialStep', min_step, 'OutputVariables', 'ty');
[t,x,y] = sim('s_abeob2', [0, t_final], my_opt);    

subplot(211), plot(t, y(:,1));
title('Antwort auf einen Sprung und x(0) = [5 0 0 0] (Sprung bei 2,5 s)');
xlabel('Zeit in s');		grid;
La = axis;	axis([La(1), La(2), La(3), 1.2*La(4)]);
subplot(212), plot(t, y(:,2));
title('Prozess_Steuerung');	
xlabel('Zeit in s');		grid;

