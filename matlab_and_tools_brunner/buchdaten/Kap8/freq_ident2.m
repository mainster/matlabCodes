% Programm freq_ident2.m zur Identifikation des Frequenzgangs
% ¸ber Leistungsspektraldichten mit der Funktion spa

% ------- Kontinuierliches System
my_sys = tf(1,[1,0.1,1])*tf(1,[10,0.2,1])

% ------- Diskretisierung
Ts = 0.5;
my_sys_d = c2d(my_sys, Ts)

% ------- Daten
% Eingangssequenz
ns = 5000;
t = (0:ns-1)*Ts;
u = randn(ns,1);      % unabh‰ngige Sequenz

% Ausgangssequenz
y = lsim(my_sys_d, u);

% ------- Korreliertes Meﬂrauschen
R = 1;                       % Welligkeit im Durchlaﬂbereich
fd = 0.3;                    % Durchlaﬂfrequenz f/fs
[b,a] = cheby1(8, R, fd);    % Diskretes Tchebyschev-Filter

sys_v_d = tf(b,a,Ts);        % LTI-System
noise = 0.1;                 % Varianz der unabh‰ngiger Sequenz

ev = sqrt(noise)*randn(ns,1); % Unabh‰ngige Sequenz 
v = lsim(sys_v_d, ev);       % Korreliertes Meﬂrauschen

y = y + v;
data = iddata(y,u,Ts);

% ------- Identifikation des Frequenzgangs
w = logspace(-1, pi, 128);
[Guy, Gyv] = spa(data, 128, w);

figure(1);     clf;
bode(Guy, my_sys_d)
legend('Identifizierter Frequenzgang', 'Frequenzgang des LTI-Systems');

figure(2);     clf;
subplot(211), plot(ev);
title('Unabhaengiges Rauschens zum Erzeugen des korrelierten Messrauschens');
subplot(212), plot(v);
title('Korreliertes Messrauschens');

figure(3);     clf;
ffplot(Gyv)
xlabel('2 * pi * f / fs');


