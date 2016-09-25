% Programm polyinterp_3.m, in dem eine Interpolierung mit Polyphasen-
% Filter programmiert wird.
% Das Programm initialisiert auch alle Variablen des Modells
% polyinterp_3_.mdl, in dem das Filter implementiert ist

% --------- Abtastfrequenz füŸr das Modell
fs = 1000;
Ts = 1/1000;

% --------- Entwicklung des normalen FIR-Filters
% fŸr die Interpolierung
L = 5;      % Interpolierungsfaktor
nf = 128;   fr = 1/L;
h = fir1(nf-1, fr);

% --------- Bildung des Polyphasenfilters
% Teilfilter des Polyphasenfilters
rn = rem(nf,L);
if rn == 0
    g = zeros(L, nf/L);
else
    g = zeros(L, fix(nf/L)+1);
    h = [h, zeros(1,L-rn)];
end;

for k = 1:L
    g(k,:) = h(k:L:end);
end;
[mg,ng] = size(g);

% -------- Polyphasen-Interpolierung mit MATLAB-Programm 
ns = 1000;                    % LŠnge Signal
x = randn(1,ns);              % Bandbegrenztes Eingangs-
x = filter(fir1(64,0.1),1,x); % signal

n_buffer = ng;       % Frame-Größe (Puffer)
y = zeros(1, ns*L);  % Interpoliertes Signal
xi = y;

k = 1;   i = 1;
x_temp = zeros(1,ng);
while k < ns-n_buffer
    x_temp = [x(k), x_temp(1:end-1)]; % Frame Bildung
    y_temp = g*(x_temp)';  % Polyphase-
    y(i:i+L-1) = y_temp';  % Filterung
    i = i + L;             % Index fŸr Ausgang
    k = k + 1;             % Index fŸr neuen Frame
end;

% -------- Darstellungen
xi(1:L:end) = x;
xi = filter(h,1,xi);      % Interpoliertes Signal üŸber 
% normalen FIR-Filter

figure(1);   clf,
subplot(211), stairs(0:length(xi)-1, xi*L)
title('Interpolierung mit normalen FIR-Filter');
hold on;
x = [zeros(1,13), x(1:end-13)];
stairs((0:ns-1)*L,x,'r');
grid;
subplot(212), stairs(0:length(y)-1, y*L);
title('Interpolierung mit Polyphasen-FIR-Filter');
hold on;
stairs((0:ns-1)*L,x,'r');
grid;

% -------- Aufruf der Simulation
sim('polyinterp_3_',[0, 2]);
