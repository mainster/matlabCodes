% Programm (alqr1.m) zur Parametrierung und 
% Durchführung der Simulation einer Regelung mit
% LQR-Verfahren
% Benutzt die SIMULINK-Modelle: s_proz1.mdl, s_apol1.mdl und 
% s_apol2.mdl 
%
% Testaufruf: alqr1;

%------Ermittlung des Zustandsmodells
[A, B, C, D] = linmod('s_proz1');

T = [1 0 0 0; 0 0 0 1; 0 0 1 0; 0 1 0 0];
[A,B,C,D] = ss2ss(A,B,C,D,T);

Co = ctrb(A,B);
if rank(Co) ~= 4
    disp(' Das System ist nicht Steuerbar !!!');
    return;
end;

%------LQR-Rückführungsmatrix
%------Kosten der Abweichunge
Q = eye(4,4);		Q(1,1) = 100;
R = 1;

[K, S, E] = lqr(A,B,Q,R);

%------Überprüfung der neuen Pole
eig(A-B*K)

%------Verhalten des Systems mit den neuen Polen
figure(1);		clf;
t_final= 15;	
x0 = [5, 0, 0, 0];	% Anfnagsbedingung
min_step = 0.1;		max_step = min_step;

my_opt = simset('InitialStep', min_step, 'OutputVariables', 'ty');
[t,x,y] = sim('s_apol1', [0, t_final], my_opt);    % SIMULINK 2

subplot(211), plot(t, y(:,1));
title('Ausgang fuer x(0) = [ 5 0 0 0 ]');
xlabel('Zeit in s');	grid;
subplot(212), plot(t, y(:,2:5));
title('Zustandsvariablen fuer x(0) = [ 5 0 0 0 ]');
xlabel('Zeit in s');	grid;

%------Führungsregelung 
k1 = K(1); 	k2 = K(2);	
k3 = K(3);	k4 = K(4);

%-----Bestimmung der Führungsmatrix
x_un = inv(A-B*K)*(-B*k1);

% x_un = x_un/x_un(1);		%-----Verfahren Nr. 1
% F = -B'*(A-B*K)*x_un/k1;
% F = 1/x_un(1);	      	%-----Verfahren Nr. 2
F = K*(x_un/x_un(1))/k1		%-----Verfahren Nr. 3

%------Verhalten des Regelungssystems
figure(2); 		clf;
min_step = 0.1;		max_step = min_step;
t_final = 15;

my_opt = simset('InitialStep', min_step, 'OutputVariables', 'ty');
[t,x,y] = sim('s_apol2', [0, t_final], my_opt);    % SIMULINK 2

subplot(211), plot(t, y(:,2));
title('Sprungantwort (Sprung bei 2,5 s)');
xlabel('Zeit in s');		grid;
La = axis;	axis([La(1), La(2), La(3), 1.2*La(4)]);
subplot(212), plot(t, y(:,1));
title('Prozess_Steuerung');	
xlabel('Zeit in s');		grid;

