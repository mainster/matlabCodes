% Programm imp_ident3.m zur Untersuchung der Identifikation 
% einer Impulsantwort mit der Funktion cra für ein System mit Rückkopplung

% ------- Kontinuierliches System
my_sys = tf(1,[0.5,0.4,1])*tf(0.1,[1,0])     % Prozess
feedback_sys = tf([1,1], [0.2,1])            % Rückführung
my_sys_f = feedback(my_sys, feedback_sys)    % System mit Rückführung

% ------- Diskretisierung des Systems
Ts = 0.5;
my_sys_d = c2d(my_sys_f, Ts)

% ------- Impulsantwort des Systems mit Rückführung
n = 100;
t = (0:n-1)*Ts;
h = impulse(my_sys_d,t);

figure(1);    clf;
stairs(t,h);
title('Impulsantwort des Systems');
xlabel(['Zeit in s (Ts = ',num2str(Ts),'s)']);
grid;

% ------- Unabhängige Eigangssequenz
ns = 5000;
t = (0:ns-1)*Ts;
u = randn(ns,1);      % unabhängige Sequenz

% ------- Identifikation mit der Funktion cra 
% ------- Antwort des Systems
y = lsim(my_sys_d, u);
noise = 0.05;
y = y + sqrt(noise)*randn(ns,1);
data = iddata(y,u,Ts);

figure(2);      clf;
[hg, R, cl] =cra(data, n, 20, 2);

figure(3);     clf;
stairs(0:length(h)-1, h);
title(['Gewuenschte und über cra ermittelte Impulsantwort (Varianz = ',...
        num2str(noise),')']);
hold on
stairs(0:length(hg)-1, hg,'r');
hold off
    
% ------- Identifikation mit der Funktion cra, in der der Fehler des Systems als Eingang 
% benutzt wird
% Das Rückführungssignal
yr = lsim(feedback_sys, y, t);
% Fehler
ur = u - yr;
data = iddata(y,ur,Ts);

% Identifikation
figure(4);      clf;
[hg_r, R, cl] =cra(data, n, 20, 2);

figure(5);     clf;
stairs(0:length(h)-1, h);
title(['Gewuenschte und über cra ermittelte Impulsantwort (Varianz = ',...
        num2str(noise),')']);
hold on
stairs(0:length(hg_r)-1, hg_r,'r');
hold off
    

