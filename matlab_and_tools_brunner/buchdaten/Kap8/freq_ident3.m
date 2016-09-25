% Programm freq_ident3.m zur Identifikation des Frequenzgangs
% ¸ber mit der Funktion etfe

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
noise = 0.01;                % Varianz der unabh‰ngiger Sequenz

ev = sqrt(noise)*randn(ns,1);% Unabh‰ngige Sequenz 
v = lsim(sys_v_d, ev);       % Korreliertes Meﬂrauschen

y = y + v;
data = iddata(y,u,Ts);

% ------- Identifikation des Frequenzgangs
M = 128;
Guy = etfe(data, M);

figure(1);     clf;
bode(Guy, my_sys_d)
legend('Identifizierter Frequenzgang', 'Frequenzgang des LTI-Systems');



