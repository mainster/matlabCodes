% Programm mis_data1.m in dem die Funktion misdata
% untersucht wird

% -------- Eingangsdaten
Ts = 0.5;
n = 200;
u = iddata([], randn(n,1), Ts);

% -------- Gleitendes Mittelwertfilter
nf = 20;
A = 1;
B = ones(1,nf);
C = 1;
D = 1;
F = 1;
noise = 0.1;
my_sys_id = idpoly(A,B,C,D,F,noise,Ts)

% -------- Ausgangsdaten
y = sim(my_sys_id, u);

% -------- Einfügen von fehlerhaften Daten
y.outputdata(10:2:50) = NaN;
data1 = iddata(y.outputdata,u.inputdata,Ts);

% -------- Rekonstruktion der fehlerhaften Werte
yr = misdata(data1);

% -------- Darstellung
figure(1);      clf;
subplot(211), plot(y.outputdata);
title('Sequenz mit fehlerhaften Werten');
subplot(212), plot(yr.outputdata);
title('Rekonstruierte Sequenz');


