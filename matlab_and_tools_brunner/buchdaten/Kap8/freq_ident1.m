% Programm freq_ident1.m zur Identifikation des Frequenzgangs
% über Leistungsspektraldichten mit der Funktion spa

% ------- Kontinuierliches System
my_sys = tf(1,[2,0.1,1])

% ------- Diskretisierung
Ts = 0.5;
my_sys_d = c2d(my_sys, Ts)

% ------- Daten
% Eingangssequenz
ns = 5000;
t = (0:ns-1)*Ts;
u = randn(ns,1);      % Unabhängige Sequenz am Eingang

% Ausgangssequenz
y = lsim(my_sys_d, u);
noise = 0.1;          % Varianz des unkorrelierten Meßrauschens

y = y + sqrt(noise)*randn(ns,1);
data = iddata(y,u,Ts);

% ------- Identifikation des Frequenzgangs
w = logspace(-1, pi, 128);
[Guy, Gyv] = spa(data, 128, w);

figure(1);     clf;
bode(Guy,my_sys_d)
legend('Identifizierter Frequenzgang', 'Frequenzgang des LTI')

figure(2);     clf;
ffplot(Gyv);
xlabel('2 * pi * f / fs');
