% Programm r_ident_1.m in dem die rekursive Identifikation eines Systems 
% 2. Ordnung mit der Funktion roe durchgef�hrt wird
%

% ------- id-Modell
A = 1;
B = [1];    F = conv([1,-0.8+j*0.5],[1,-0.8-j*0.5]);
C = 1;      D = 1;

Ts = 0.5;
noise = 1;        % Varianz des Me�rauschens
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

% -------- Identifikation
z = [y(1:200),u(1:200)];
sys_id = roe(z, [2, 2, 1],'ff', 0.995);

figure(2);    clf;
plot(sys_id);
title('Modellparameter');
xlabel('Anpassungsschritte');
legend('B(1)', 'B(2)', 'F(2) (F(1) = 1)','F(3)');

% -------- Extrahieren der Parameter:
param = sys_id(length(sys_id),:)
B = [param(1:2)];
F = [1, param(3:4)];
A = 1;   C = 1;    D = 1;
sys_g_id = idpoly(A, B, C, D, F, 0, Ts, 'nk', 1);

figure(3);    clf;
bode(sys_g_id, my_sys_id);

figure(4);    clf;
step(sys_g_id, my_sys_id);

figure(5);    clf;
compare([y(201:400),u(201:400)], sys_g_id)
