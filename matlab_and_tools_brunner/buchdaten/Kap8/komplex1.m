% Programm (komplex1.m) zur Untersuchung einer Identifikation
% mit komplexen Daten

clear;

% -------- System mit komplexen Koeffizienten
A = conv([1, -0.5+j*0.5],[1, -0.3-j*0.2]);
B = [1, -j*2];

% -------- Komplexer Eingang
n = 400;
u = randn(n,1) + j*randn(n,1);

% -------- Antwort 
y = filter(B, A, u);            % Funktion aus der Signal-Processing-Toolbox
noise = 1;
y = y + (randn(n,1)+j*randn(n,1))*sqrt(noise)/2; % Hinzufügen von Messrauschen

% -------- Daten für die Identifikation
Ts = 0.5;
u_id = iddata([], u, Ts);
y_id = iddata(y, [], Ts);

% -------- Identifikation mit komplexen Daten
my_sys_g = armax([y_id, u_id], [2, 2, 2, 0])

% -------- Komplexe Koeffizienten der Polynome
A_g = my_sys_g.a;        B_g = my_sys_g.b;        C_g = my_sys_g.c;

y_g = filter(B_g, A_g, u);

figure(1);     clf;
subplot(211), plot(0:399, [real(y_g), real(y)]);
title('Realteil der Ausgaenge (System und Modell)');

subplot(212), plot(0:399, [imag(y_g), imag(y)]);
title('Imaginaerteil der Ausgaenge (System und Modell)');
