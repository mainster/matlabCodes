% Programm temp1.m zur Identifikation eines thermischen Systems,
% das im Modell temp_1.mdl simuliert ist
% 

% ------- Abtastperiode für die Daten und diskretes Modell
Ts = 10;

% ------- Ausfruf der Simulation mit Simulink-Modell
sim('temp_1');          % Es werden die Daten u und y für die Identifikation erzeugt
n = length(y);
n2 = fix(n/2);
data_e = iddata(y(1:n2),u(1:n2),Ts);
data_v = iddata(y(n2+1:n),u(n2+1:n),Ts);

figure(1);     clf;     % Darstellung der Daten für die Überprüfung
subplot(211), plot((0:n-1)*Ts/60, u);
title('Eingangssignal des Prozesses');
subplot(212), plot((0:n-1)*Ts/60, y);
title('Ausgangssignal des Prozesses (mit Messrauschen)');
xlabel('Zeit in Minuten');

% ------- Eine erste Identifikation
disp('************************');
disp('sys1 = pem(data_e)');
disp('************************');

sys1 = pem(data_e)
figure(2);     clf;
compare(data_v, sys1)

% ------- Impulsantwort
figure(3);     clf;
impulse(data_e, 'sd', 3);

% ------- ARX-Modell
V = arxstruc(data_e, data_v, struc(1:2, 1:2, 3:8));
nn = selstruc(V,0)
% Das beste Modell

disp('************************');
disp('sys2 = arx(data_e, nn)');
disp('************************');
sys2 = arx(data_e, nn)

% Vergleich
figure(4);     clf;
compare(data_v, sys1, sys2);

% ------- Nähere Ermittlung der Ordnung
% die Verspätung wird beibehalten
disp('*********************************************');
disp('sys3 = pem(data_e, ''nk'', nn(length(nn)');
disp('*********************************************');

sys3 = pem(data_e, 'nk', nn(length(nn)))

% ------- Modell 1. Ordnung mit Verspätung
disp('************************************************');
disp('sys4 = pem(data_e, 1, ''nk'', nn(length(nn)');
disp('************************************************');

sys4 = pem(data_e, 1, 'nk', nn(length(nn)))

figure(5);     clf;
compare(data_v, sys4)

% ------- Umwandlung in ein kontinuierlichen Modell
disp('************************');
disp('sys5 = d2c(sys4)');
disp('************************');

sys5 = d2c(sys4)

disp('************************');
disp('sys6 = tf(sys5(''m'')');
disp('************************');

sys6 = tf(sys5('m'))     % Nur der Steuerpfad (ohne Störung oder Meßrauschen)

