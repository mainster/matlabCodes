% Programm r_ident_3.m in dem die rekursive Identifikation eines Systems 
% 2. Ordnung mit der Funktion roe durchgeführt wird
% Es wird effektiv on-line identifiziert
%
clear
% ------- id-Modell
A = 1;
B = [1];    F = conv([1,-0.8+j*0.5],[1,-0.8-j*0.5]);
C = 1;      D = 1;

Ts = 0.5;
noise = 1;        % Varianz des Meßrauschens
my_sys_id = idpoly(A,B,C,D,F,noise,Ts,'nk',1)

% ------- Initialisierung der Identifikation
N = 400;              
randn('seed', 175931);  % Initialisierung des Zufallsgenerators

u = iddata([], randn(N,1), Ts);      % Eingangswerte
e = iddata([], sqrt(noise)*randn(N,1), Ts);      % Messrauschen
y = sim(my_sys_id, [u,e]);           % Ausgangswerte

figure(1);     clf;
subplot(211), plot((0:N-1)*Ts, u.InputData);
title('Eingangsequenz');   xlabel('Zeit in s'); grid;
La = axis;    axis([La(1), N*Ts, La(3:4)]);

subplot(212), plot((0:N-1)*Ts, y.OutputData);
title('Ausgangssequenz');   xlabel('Zeit in s'); grid;
La = axis;    axis([La(1), N*Ts, La(3:4)]);

disp('*************************************');
disp(' Bitte warten Sie !!!');
disp('*************************************');

% -------- Identifikation
% Initialisierung der Rekursion (erster Schritt)
[sys_id, yg, P, phi, psi] = roe([y(1), u(1)], [2,2,1],'ff', 0.98);

figure(2);     clf;
plot(1, sys_id,'*');
hold on;
% Rekursive Identifikation
for k = 2:200
   [sys_id, yg, P, phi, psi] = roe([y(k),u(k)], [2,2,1],'ff', 0.98, sys_id', P, phi, psi);
   plot(k, sys_id,'*'); 
end;
title('Anpassung der Koeffizienten des Modells');
xlabel('Anpassungsschritte'); grid;
hold off;

