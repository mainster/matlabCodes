% Programm ident_7.m in dem die Identifikation eines 
% Output-Error-Modells mit der Funktion oe durchgeführt wird
%

% ------- Das kontinuierliche System
sys1 = tf(1,[1,0.1,1])        

% ------- Diskretisierung des Systems
Ts = 0.5;
sys1_d = c2d(sys1, Ts)
b = sys1_d.num{1,:};     f = sys1_d.den{1,:};

% ------- Erzeugung der Eingänge u und e
n = 300;
u = randn(n,1);             % Meßbarer Eingang
%T = pi;
%u = sin(2*pi*(0:n-1)/(0.5*T))' + sin(2*pi*(0:n-1)/T)' + cos(2*pi*(0:n-1)/(2*pi))';

noise = 1;                  % Varianz der e Sequenz
e = randn(n,1)*sqrt(noise); % Unabhängige Störung e

% ------- Ausgang des Systems
y = lsim(sys1_d, u, (0:n-1)*Ts) + e;
ny = length(y);

figure(1);     clf;
subplot(211), plot((0:n-1)*Ts, u);
subplot(212), plot((0:n-1)*Ts, y);

% ------- Daten für die Funktion oe vorbereiten
daten = iddata(y, u, Ts);

% ------- Einsatzt der Funktion armax um das geschätzte Modell zu erhalten
my_sys_g = oe(daten, [3,3,1]); 

% ------- Korrektes Modell
my_sys = idpoly(1,b,1,1,f,noise,Ts);       % a, c, d = 1, 

% ------- Darstellung der Frequenzgänge
figure(2),     clf;
bode(my_sys_g, my_sys)
xlabel('rad/s');

% ------- Sprungantwort
figure(3),     clf;
step(my_sys_g, my_sys,[0:0.1:50]);
