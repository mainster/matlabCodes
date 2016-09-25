% Programm polydezim_4.m , in dem eine Dezimierung mit Polyphasen-
% Filtern in MATLAB programmiert wird.
% Das Programm initialisiert auch alle Variablen des Modells
% polydezim_4_.mdl in dem das Filter implementiert ist

% --------- Abtastfrequenz für das Modell
fs = 1000;
Ts = 1/1000;

% --------- Entwicklung des normalen FIR-Filters
% für die Dezimierung
nf = 128;   fr = 0.1;
h = fir1(nf-1, fr);

% --------- Bildung des Polyphasenfilters
M = 5;      % Dezimierungsfaktor
% Teilfilter des Polyphasenfilters
rn = rem(nf,M);
if rn == 0
    g = zeros(M, nf/M);
else
    g = zeros(M, fix(nf/M)+1);
    h = [h, zeros(1,M-rn)];
end;
 
for k = 1:M
    g(k,:) = h(k:M:end);
end;
[mg,ng] = size(g);

% -------- Polyphasen-Dezimierung mit MATLAB-Programm 
ns = 1000;           % L‰änge Signal
x = randn(1,ns);     % Signal

y = zeros(1, fix(ns/M));  % Dezimiertes Signal
k = 1;   i = 1;
x_matrix = zeros(M,ng);
while k < ns-M
    x_matrix = [x(k+M-1:-1:k)', x_matrix(1:M,1:ng-1)];
    y_temp = x_matrix.*g;           % Polyphase-
    y(i) = sum(sum(y_temp,2));      % Filterung
    i = i+1;
    k = k + M;   % Index f¸ür neuen Frame
end;
n_buffer = ng*M;     % Nur f¸ür das Modell polydezim_4_.mdl

% -------- Darstellungen 
xf = filter(h,1,x);           % Dezimierung ¸über normales FIR-
xd = xf(5:M:end);             % Filter mit angepasstem Ursprung

figure(1);   clf,
subplot(211), stairs(0:length(xd)-1, xd)
title('Dezimierung mit normalen FIR-Filter');
grid;
subplot(212), stairs(0:length(y)-1, y);
title('Dezimierung mit Polyphasen-FIR-Filter'); 
grid;

% ------- Aufruf des Modells
sim('polydezim_4_',[0, 10]);
    