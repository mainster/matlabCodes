% Programm zeit_1.m zum Experimentieren mit den Zeitfunktionen
% für LTI-Systeme

clear
% ------- Erzeugung LTI-Systems
sys=[tf(1,[1,1]),tf([0.1,1],[1,0.2,1]);tf(1,[1,0.2,1]),...
                      zpk([],[-1,-0.5+j*0.2,-0.5-j*0.2],1)]

% ------- Sprungantwort
figure(1);      clf;
step(sys);

% ------- Impulsantwort
figure(2);      clf;
impulse(sys);

% ------- Natürliche Antwort
figure(3);      clf;
sys_n = ss(sys);
[ma,na] = size(sys_n.a);      % Ermittlung der Dimension der matrix s des SS-Modells

initial(sys_n, randn(1,ma));

% ------- Antwort auf weißem Rauschen der Covarianzmatrix Q
Q_eingang = [1, -0.5; -0.5, 1]

tf = 300;         dt = 0.1;         t = 0:dt:tf;
n = length(t);

G = chol(Q_eingang)/sqrt(dt);
randn('seed', 14678);

u = randn(2,n);       % Weißes Rauschen 
us = G*u;             % Weißes Rauschen mit cov Q

% ------- Überprüfung der Covarianz des Eingangs
Q_gesaetzt = cov(us')*dt      % Für ein kontinuierliches system

% ------- Antwort auf us
y = lsim(sys, us, t);

figure(4);     clf;
subplot(211), plot(t, y(:,1));
title('Antwort auf weissen Rauschen');
grid;
subplot(212), plot(t, y(:,2));
xlabel('Zeit in s');
grid;

% ------- Geschätzte Covarianz der Antwort
Q_ausgang = cov(y)

% ------- Covarianz des Systems mit der Funktion covar(sys) ermittelt
Q_ausg_covar = covar(sys, Q_eingang)

