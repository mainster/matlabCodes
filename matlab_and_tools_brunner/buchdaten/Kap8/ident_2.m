% Programm ident_2.m in dem die Identifikation eines Systems 
% 2. Ordnung direkt durchgeführt wird
%

% ------- Kontinuierliches System
my_sys = tf(1,[1,0.1,1])

% ------- Diskretisierung des Systems
Ts = 0.5;
my_sys1 = c2d(my_sys, Ts)

% ------- Koeffizienten des Polynoms im Zähler und Nenner
b = my_sys1.num{1,:}
a = my_sys1.den{1,:}
nt = length(a)-1;     % Effektive Anzahl der Koeffizienten 

% ------- Initialisierung der Identifikation
N = 500;                % Anzahl der Spalten der Matrix Phi
ns = N + nt;          % Anzahl der Datenpaare

randn('seed', 175931);  % Initialisierung des Zufallsgenerators

u = randn(1,ns);      % Eingangswerte

y = filter(b,a,u);    % Ausgangswerte
y = y + randn(1, length(y))*0.05;     % Ausgangswerte mit Meßauschen

figure(1);     clf;
subplot(211), plot((0:ns-1)*Ts, u);
title('Eingangsequenz');   xlabel('Zeit in s'); grid;
La = axis;    axis([La(1), ns*Ts, La(3:4)]);

subplot(212), plot((0:ns-1)*Ts, y);
title('Ausgangssequenz');   xlabel('Zeit in s'); grid;
La = axis;    axis([La(1), ns*Ts, La(3:4)]);

% -------- Identifikation
z = [y', u'];
phi = zeros(2*nt, ns-nt);
for k = 1:ns-nt
    phi(:,k) = [-z(k+nt-1:-1:k,1); z(k+nt-1:-1:k,2)];
end;
yv = z(nt+1:ns,1);

tetha = zeros(2*nt,1);
tetha = pinv(phi*phi')*(phi*yv)

% ------- Differenzen der Koeffizienten
fehler_koeff = [a(2:3), b(2:3)] - tetha'
standard_abw = std(fehler_koeff)

