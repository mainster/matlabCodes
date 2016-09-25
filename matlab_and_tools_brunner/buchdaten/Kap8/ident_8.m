% Programm ident_8.m in dem die Identifikation eines 
% Box-Jenkins-Modells mit der Funktion bj durchgef�hrt wird
%

% ------- Das kontinuierliche System
sys1 = tf(1,[1,0.1,1])       % Eingangspfad
sys2 = tf([1,0],[1,1])       % St�rungspfad

% ------- Diskretisierung des Systems
Ts = 0.5;
sys1_d = c2d(sys1, Ts)
sys2_d = c2d(sys2, Ts)

f = sys1_d.den{1,:};     b = sys1_d.num{1,:};
d = sys2_d.den{1,:};     c = sys2_d.num{1,:};
a = 1;    % a, d, c und f mussen 'monic' sein und mit 1 beginnen

% ------- Erzeugung der Datenpaare 
n = 500;
u = randn(n,1);             % Me�barer Eingang
%T = pi;
%u = sin(2*pi*(0:n-1)/T)';

noise = 1;                  % Varianz der e Sequenz
e = randn(1,n)*sqrt(noise); % Unabh�ngige St�rung e

% ------- Ausgang des Systems
y = lsim(sys1_d, u, (0:n-1)*Ts) + lsim(sys2_d, e, (0:n-1)*Ts);

figure(1);     clf;
subplot(211), plot((0:n-1)*Ts, u);
subplot(212), plot((0:n-1)*Ts, y);

% ------- Daten f�r die Funktion armax vorbereiten
daten = iddata(y, u, Ts);

% ------- Einsatzt der Funktion armax um das gesch�tzte Modell zu erhalten
my_sys_g = bj(daten, 'nb',3,'nc',3,'nd',3,'nf',3,'nk',1); 

% ------- Korrektes Modell
my_sys = idpoly(a,b,c,d,f,noise,Ts);       % a = 1

% ------- Darstellung der Frequenzg�nge
figure(2),     clf;
bode(my_sys_g, my_sys)
xlabel('rad/s');

% ------- Sprungantwort
figure(3),     clf;
step(my_sys_g, my_sys,[0:0.1:50]);
