% Programm estimate_2.m zur Parametrierung des Experiment mit
% einem Schätzer/Beobachter (Estimator/Observer)
% Arbeitet mit dem Modell estimate2.mdl 

% --------MISO-System
a = [-0.5, 0, 0; 0, -3, 0; 0, 0, -6];
b = [0, 0; 1, 0; 0, 1];
c = [0.3, 0.5, 1];
d = [0, 0];

my_sys = ss(a,b,c,d)  % Ohne ; um das System anzeigen

% --------Überprüfen der Steuerbarkeit
con = ctrb(my_sys);
disp(['Rank Steuerbarkeitsmatrix = ', num2str(rank(con))]);

% --------Überprüfen der Beobachtbarkeit
obs = obsv(my_sys);
disp(['Rank Beobachtbarkeitsmatrix = ', num2str(rank(obs))]);

% --------Matrix des Schätzers
p = [-10,-3,-5];
Ke = place(a', c', p).';

% --------Schätzer
my_estim = estim(my_sys, Ke, 1, 2)

% --------Anfangszustände
%randn('seed', 18754);
%x0 = randn(3,1)
x0 = [1 2 3]

% --------Aufruf der Simulation
dt = 0.1;
my_opt = simset('OutputVariables', 'ty');
[t,x,y] = sim('estimate2', [0:dt:5], my_opt);  

figure(1)
subplot(221), plot(t, [y(:,1),y(:,5)]);
title('y und y^');    grid;
La = axis;    axis([La(1), t(length(t)), La(3:4)]);

subplot(222), plot(t, [y(:,2),y(:,6)]);
title('x1 und x1^');    grid;
La = axis;    axis([La(1), t(length(t)), La(3:4)]);

subplot(223), plot(t, [y(:,3),y(:,7)]);
title('x2 und x2^');    grid;
La = axis;    axis([La(1), t(length(t)), La(3:4)]);

subplot(224), plot(t, [y(:,4),y(:,8)]);
title('x3 und x3^');    grid;
La = axis;    axis([La(1), t(length(t)), La(3:4)]);










