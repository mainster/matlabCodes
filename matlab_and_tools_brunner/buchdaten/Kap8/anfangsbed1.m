% Programm (anfangsbed1.m) zur Untersuchung einer 
% der Anfangsbedingungen bei der Identifikation

% -------- id-Modell
A = conv([1,-(0.8+j*0.5)],[1,-(0.8-j*0.5)])
B = 1;
C = [1,1];
D = 1;
F = 1;
sigma_noise = 2;
Ts = 0.5;

my_sys_id = idpoly(A,B,C,D,F,sigma_noise,Ts)

% ------- Simulation des Modells um Daten für eine Identifikation zu erhalten
u = iddata([], idinput([800,1],'rbs'),Ts);  % Zufällige binäre Sequenz
e = iddata([], randn(800,1),Ts);            % Meßrauschen für die 3 Ausgänge

% Ausgangssignal
y = sim(my_sys_id, [u,e]);

% ------- Identifikation
my_sys_g = armax([y,u],'na',2,'nb',2,'nc',1,'nk',2)

% ------- Änderung der Parameter und erneute Identifikation
my_sys_g.b(1) = 1;                         % Es wird eine Verspätung gelöscht
my_sys_g1 = armax([y,u], my_sys_g)

% -------- Frequenzgang
figure(1);      clf;
bode(my_sys_id, my_sys_g, my_sys_g1)
legend('Korrektes System','Geschaetztes mit nk = 2','nk = 0');

% -------- Sprungantwort
figure(2);      clf;
step(my_sys_id, my_sys_g, my_sys_g1)
legend('Korrektes System','Geschaetztes mit nk = 2','nk = 0');
