% Programm (pol1.m) zur Durchf�hrung der Simulation
% einer Polplatzierung mit Zustandsr�ckf�hrung  
% mit Hilfe des Simulink-Modells s_pol1.mdl 
%
% Testaufruf: pol1;

%------ Verhalten des Prozesses ohne R�ckf�hrung
T1 = -5;	T2 = 10;	% Zeitkonstanten des Prozesses
x10 = 1;	x20 = 0;	% Anfangsbedingungen
k1 = 0;		k2 = 0;		% Ohen R�ckf�hrung

%------ Aufruf der Simulation
my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'ty');
[t,x,y] = sim('s_pol1', [0, 20], my_opt);    % SIMULINK 2
 
figure(1);	clf;
subplot(211), plot(t,y(:,1));
title('Antwort ohne Rueckfuehrung:  x1 f uuml r x1(0) = 1');
xlabel(' Zeit in s');	grid;
subplot(212), plot(t,y(:,2));
title(' x2 f�r x1(0) = 1');
xlabel(' Zeit in s');	grid;

% Gew�nschte stabile Pole
s1 = -1+j*2;		s2 = conj(s1);
a = real(s1);		b = imag(s1);

% Verhalten mit R�ckf�hrung
k1 = -2*a*T1-1-T1/T2;	k2 = (a^2+b^2)*T1*T2-1-k1;

my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'ty');
[t,x,y] = sim('s_pol1', [0, 20], my_opt);    

figure(2);	clf;
subplot(211), plot(t,y(:,1));
title('Antwort mit Rueckfuehrung:  x1 fuumlr x1(0) = 1');
xlabel(' Zeit in s');		grid;
subplot(212), plot(t,y(:,2));
title(' x2 f�r x1(0) = 1');
xlabel(' Zeit in s');		grid;
k1, k2, a, b,
