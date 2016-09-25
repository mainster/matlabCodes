% Programm (torce11.m) zur Durchführung der Simulation 
% einer hydraulischen Füllstandsregelung in einem System mit
% drei Tanks. Arbeitet mit den SIMULINK-Modellen 
% s_toce1.mdl, s_torce2.mdl, s_torce3.mdl
 

disp('****************************************************');
disp('Bitte warten, die Simulation dauert etwas länger !!!');
disp('****************************************************');

%-------Parameter des hydraulischen Systems
g = 9.81;                        % Fallbeschleunigung

A1 = 2;		A2 = 2;		A3 = 2; 	% Querschnitte
		                   % der Tanks und der Verbindungkanäle 
A12 = 0.1;	A23 = 0.1;	A30 = 0.1;

Qz_max = 4; 	% Der maximale Zustrom 
Qz_min = 0;     % Der minimale Zustrom (wenn nur gepumt wird)
 
%-------Simulation mit Simulink-Modell s_torce1.mdl
my_opt = simset('OutputVariables', 'ty');
[t,x,y] = sim('s_torce1',[0:0.1:200], my_opt);

figure(1);	clf;
subplot(211), plot(t, y(:,1:3));
title(' Sprungantwort : Fuellstaende h1, h2, h3 ');
xlabel(' Zeit in s');	ylabel('Hoehen in m')
grid;
subplot(212), plot(t, y(:,4:6));
title(' Durchfluesse  Q12, Q23, Q30 ');
xlabel(' Zeit in s');	ylabel('Kubikmeter / s')
grid;	

%------PID-Regelung mit SIMULINK-Modell s_torce2.mdl
%------Parameter des Reglers
kp = 5;		ki = 0.1;		kd = 15;	N = 20;
%------Simulation

my_opt = simset('OutputVariables', 'ty');
[t,x,y] = sim('s_torce2',[0:0.1:100], my_opt);

figure(2);	clf;
subplot(121), plot(t, y(:,1:3));
title(' h1, h2, h3 ');
xlabel(' Zeit in s');	ylabel('Hoehen in m')
grid;
subplot(122), plot(t, y(:,4:7));

t_final = 50;
L = axis;	
axis([L(1),t_final, min(-0.5, Qz_min*1.2), 1.2*Qz_max]);
title('Qz (Steuerung), Q12, Q23, Q30 ');
xlabel(' Zeit in s');	ylabel('Kubikmeter pro s')
grid;	

