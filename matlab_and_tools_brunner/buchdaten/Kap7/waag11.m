% Programm (waag11.m) zur Durchführung der Simulation
% der Regelung einer weglosen Waage mit dem 
% Simulink-Modell s_waag11.mdl
% 

%------Parameter der Waage 
R = 7.5;	L = 0.6e-3;	% Widerstand und Induktivität
				% der Tauschspule
D = 1000;	r = 100;	% Steifigkeit der Wellfeder
				% und Dämpfungsfaktor
mw = 0.1;	mx = 5;		% Masse der Waage und der Last
kg = 5;				% Übertragungskonstante für die 
				% induzierte Spannung
g = 9.81;			% Fallbeschleunigung
ks = 200;			% Übertragung Nullpositionssensor

%------Parameter PID-Regler
kp = 100; 	ki = 1000;	kd = 10;	N = 20;

%------Simulation;
min_step = 1e-4;  	

%------ Aufruf der Simulation 
my_opt = simset('OutputVariables', 'ty');
[t,x,y] = sim('s_waag11',[0:min_step:0.4], my_opt);

figure(1);	clf;
subplot(211), plot(t, y(:,1));
title(['Weg der Waage (mx = ',num2str(mx),' kg )']);
xlabel ('Zeit ins');	ylabel('m');	grid;
subplot(212), plot(t, y(:,2:3));
title(['Elektrische Kraft und Reglerausgang']);
xlabel ('Zeit ins');	ylabel(' ');	grid;

