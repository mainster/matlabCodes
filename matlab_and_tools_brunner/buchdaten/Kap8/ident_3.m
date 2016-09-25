% Programm ident_3.m in dem die Identifikation eines Systems 
% 2. Ordnung mit der Funktion arx durchgeführt wird
%

% ------- Kontinuierliches System
my_sys = tf(1,[1,0.1,1])

% ------- Diskretisierung des Systems
Ts = 0.5;
my_sys1 = c2d(my_sys, Ts)

% ------- Koeffizienten des Polynoms im Zähler und Nenner
a = my_sys1.den{1,:}
b = my_sys1.num{1,:}
nt = length(a)-1;     % Effektive Anzahl der Koeffizienten 

% ------- Initialisierung der Identifikation
N = 500;                % Anzahl der Spalten der Matrix Phi
ns = N + nt;          % Anzahl der Datenpaare

randn('seed', 175931);  % Initialisierung des Zufallsgenerators

u = randn(1,ns);      % Eingangswerte

y = filter(b,a,u);    % Ausgangswerte
noise = 0.05;         % Varianz Messrauschen
y = y + randn(1, length(y))*sqrt(noise);     % Ausgangswerte mit Meßauschen

figure(1);     clf;
subplot(211), plot((0:ns-1)*Ts, u);
title('Eingangsequenz');   xlabel('Zeit in s'); grid;
La = axis;    axis([La(1), ns*Ts, La(3:4)]);

subplot(212), plot((0:ns-1)*Ts, y);
title('Ausgangssequenz');   xlabel('Zeit in s'); grid;
La = axis;    axis([La(1), ns*Ts, La(3:4)]);

% -------- Identifikation
daten = iddata(y',u',Ts);
sys_id = arx(daten, 'na', 2,'nb', 2, 'nk', 1);

a_g = sys_id.a
b_g = sys_id.b

% ------- Differenzen der Koeffizienten
fehler_koeff = [a, b] - [a_g, b_g]
standard_abw = std(fehler_koeff)

