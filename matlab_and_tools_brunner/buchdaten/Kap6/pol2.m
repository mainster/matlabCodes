% Programm (pol2.m) zur Durchführung der Simulation
% einer Polplatzierung mit Zustandsrückführung  
% mit Hilfe des Simulink-Modells s_pol2.mdl 
%
% Testaufruf: pol2;

T1 = -5;	T2 = 10;	% Zeitkonstanten des Prozesses
% Gewünschte stabile Pole

s1 = -1+j*2;		s2 = conj(s1);
a = real(s1);		b = imag(s1);

%------- Rückführungskonstanten für die Zustandsvaraibelen
k1 = -2*a*T1-1-T1/T2;	k2 = (a^2+b^2)*T1*T2-1-k1;
ks = 1/(k1+k2+1);	% Verstärkung des Systems Rückführung
			% der Zustandsvariablen
K = 1/ks;		% Gewichtung der Führungsgröße

%------- Aufruf der Simulation
my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'ty');
[t,x,y] = sim('s_pol2', [0, 10], my_opt);   
  
figure(1);	clf;
subplot(211), plot(t,y(:,1));
title('Zustandsvariable x1 ');
xlabel(' Zeit in s');		grid;
subplot(212), plot(t,y(:,2));
title('Ausgang ( oder Zustandsvariable x2 ) ');
xlabel(' Zeit in s');		grid;
k1, k2, a, b,

