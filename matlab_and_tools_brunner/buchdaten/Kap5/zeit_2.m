% Programm zeit_2.m in dem die Impulsantwort von LTI-Modelle
% mit Delta-Funktionen im Ausgang

clear
% -------- Modell in Form eines Hochpassfilters 1. Ordnung
sys = tf([1,0],[1,1])

% -------- Impulsantwort
figure(1);      clf;
impulse(sys);

% -------- Annäherung der Impulsantwort mit Hilfe eines Pulses
% und Normierung mit der Fläche des Pulses

tf = 2;
dt = 1/100;

t = 0:dt:tf;
n = length(t);
u = [1, 1, zeros(1,n-2)];

y = lsim(sys,u,t);     % Antwort auf ein Puls der Dauer dt
yn = y/(2*dt);          % Normierte Antwort als Annäherung der Impulsantwort

figure(2);      clf;
plot(t, yn);
axis([-0.5, 2, -1, 5]);
title('Impulsantwort durch normierte Pulsantwort')
xlabel('Zeit ins');   grid on;
