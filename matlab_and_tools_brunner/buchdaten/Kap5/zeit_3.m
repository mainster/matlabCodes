% Programm zeit_3.m in dem die Zeitfunktionen mit eigenen
% Darstellungen angewandt werden

clear
% ------- Erzeugung eines LTI-Systems
sys = [tf(1,[1,1]),tf([0.1,1],[1,0.5,1]);tf(1,[1,0.2,1]),...
                      zpk([],[-1,-0.5+j*0.2,-0.5-j*0.2],1)]

% ------- Sprungantwort
[st, t] = step(sys);

n = length(t);
st1(1:n) = st(:,1,1);    % Eingang 1 zu Ausgang 1
st2(1:n) = st(:,2,1);    % Eingang 1 zu Ausgang 2
st3(1:n) = st(:,1,2);    % Eingang 2 zu Ausgang 1
st4(1:n) = st(:,2,2);    % Eingang 2 zu Ausgang 2

figure(1);      clf;
plot(t,[st1', st2', st3', st4']);
legend('e1-a1', 'e1-a2', 'e2-a1', 'e2-a2'); 
title(' Sprungantworten ');
xlabel('Zeit in s');    grid;

% ------- Impulsantwort
[it, t] = impulse(sys);

n = length(t);
it1(1:n) = it(:,1,1);    % Eingang 1 zu Ausgang 1
it2(1:n) = it(:,2,1);    % Eingang 1 zu Ausgang 2
it3(1:n) = it(:,1,2);    % Eingang 2 zu Ausgang 1
it4(1:n) = it(:,2,2);    % Eingang 2 zu Ausgang 2

figure(2);      clf;
plot(t,[it1', it2', it3', it4']);
legend('e1-a1', 'e1-a2', 'e2-a1', 'e2-a2'); 
title(' Impulsantworten ');
xlabel('Zeit in s');    grid;

% ------- Natürliche Antwort
sys_n = ss(sys);
[ma,na] = size(sys_n.a);      % Ermittlung der Dimension der matrix s des SS-Modells

[y,t,x] = initial(sys_n, randn(1,ma));

figure(3);      clf;
plot(t, x)
title('Natuerliche Antwort (Zustandsvariablen) für zufaellige Anfangsbedingungen');
xlabel('Zeit in s');      grid;

% ------- Antwort auf weissen Rauschen
tf = 300;         dt = 0.1;         t = 0:dt:tf;
n = length(t);
randn('seed', 14678);

u = randn(2,n);       % Weißes Rauschen 
y = lsim(sys, u, t);

figure(4);      clf;
plot(t, y);
title('Antwort auf weissen Rauschen');
xlabel('Zeit in s');    grid;



