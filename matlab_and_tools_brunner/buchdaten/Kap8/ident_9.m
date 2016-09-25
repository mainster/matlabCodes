% Programm ident_9.m in dem die Identifikation eines 
% SS-Modells mit der Funktion n4sid durchgef�hrt wird
%
% Arbeitet mit dem Simulink-Modell turb_ident1.mdl


% ------- System mit dem die Daten f�r die Identifikation erzeugt werden
[a,b,c,d] = linmod('turb_ident1')
c = eye(4,4)             % Alle Zustandsvariablen sind Ausg�nge
d = zeros(4,2)           % D-Matrix

my_sys = ss(a,b,c,d);
save turb_ident.mat my_sys

% ------- Diskretisierung des Modells
Ts = 0.2;
my_sys_d = c2d(my_sys, Ts);

% ------- Eingangssignale
n = 500;
[nb,mb] = size(my_sys_d.b);
u = randn(n,mb);

% ------- Ausgang des Systems
t = (0:(n-1))*Ts;
y = lsim(my_sys_d, u, t);

figure(1);      clf;
subplot(211), plot((0:n-1)*Ts, [u(:,1), u(:,2)+4])
title('Eingaenge u1 und u2+4');
xlabel('Zeit in s');

subplot(212), plot((0:n-1)*Ts, y)
title('Ausgang');
xlabel('Zeit in s');

% ------- Daten f�r die Funktion n4sid vorbereiten
daten = iddata(y, u, Ts);

% ------- Einsatzt der Funktion n4sid um das gesch�tzte Modell zu erhalten
ng = 6;            % Gesch�tzte Ordnung
my_sys_g = n4sid(daten, ng,'n4horizon',[7:15]','trace','on');

% ------- Darstellung der Frequenzg�nge
figure(2),     clf;
bode(my_sys_g, my_sys_d)
xlabel('rad/s');

% ------- Sprungantwort
figure(3),     clf;
step(my_sys_g, my_sys,[0:0.1:50]);

% ------- A-Matrizen der Systeme
ag = my_sys_g.a,       ad = my_sys_d.a,

% ------- Eigenwerte des Systeme
eig_g = eig(ag),
eig_d = eig(ad),
