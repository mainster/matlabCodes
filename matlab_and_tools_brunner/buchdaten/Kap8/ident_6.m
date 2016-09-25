% Programm ident_6.m in dem die Identifikation eines 
% ARMAX-Modells mit der Funktion armax durchgeführt wird
%

% ------- Das kontinuierliche System
sys1 = tf(1,[1,0.1,1])        % Eingangspfad
sys2 = tf([1,0],[1,1])       % Störungspfad

% ------- Diskretisierung des Systems
Ts = 0.5;
sys1_d = c2d(sys1, Ts)
sys2_d = c2d(sys2, Ts)

a1 = sys1_d.den{1,:};     b1 = sys1_d.num{1,:};
a2 = sys2_d.den{1,:};     b2 = sys2_d.num{1,:};

% ------- Zusammensetzung in Form eines ARMAX-Modells
b = conv(b1, a2);        c = conv(b2,a1);
a = conv(a1, a2);        
c = c/c(1);              % c muss 'monic' sein und mit 1 beginnen

% ------- Erzeugung der Eingänge u und e
n = 300;
T = pi;
%u = randn(n,1);             % Meßbarer Eingang
u = sin(2*pi*(0:n-1)/(0.5*T))' + sin(2*pi*(0:n-1)/T)' + cos(2*pi*(0:n-1)/(2*pi))';

noise = 0.01;                % Varianz der e Sequenz
e = randn(1,n)*sqrt(noise);  % Unabhängige Störung e

% ------- Ausgang des Systems
y = lsim(sys1_d, u, (0:n-1)*Ts) + lsim(sys2_d, e, (0:n-1)*Ts);
ny = length(y);

figure(1);     clf;
subplot(211), plot((0:n-1)*Ts, u);
subplot(212), plot((0:n-1)*Ts, y);

% ------- Daten für die Funktion armax vorbereiten
daten = iddata(y, u, Ts);

% ------- Einsatzt der Funktion armax um das geschätzte Modell zu erhalten
my_sys_g = armax(daten, [4,4,4,1]); 

% ------- Korrektes Modell
my_sys = idpoly(a,b,c,1,1,noise,Ts);       % c, d und f müssen 'monic' sein
% und mit 1 beginnen

% ------- Darstellung der Frequenzgänge
figure(2),     clf;
bode(my_sys_g, my_sys)
xlabel('rad/s');

% ------- Sprungantwort
figure(3),     clf;
step(my_sys_g, my_sys,[0:0.1:50]);
