% Skript farrow_4.m in dem ein Farrow-Filter
% mit ver�nderlicher Versp�tung untersucht wird
clear;
% ------- Entwicklung des Filters
L = 480;    M = 441;          % Abtastrate �nderungsparameter
f = fdesign.polysrc(L,M);     % Filter-Objekt
f.PolynomialOrder = 3;        % Kubische-Interpolation
H = design(f, 'lagrange');    % Filter Entwurf

% ------- Beispiel f�r eine Filterung
Ts = 1/44.1e3;      Tfinal = 0.005;
t = 0:Ts:Tfinal-Ts;
nt = length(t);
% ------- Bandbegrenztes Eingangssignal 
randn('seed', 9375);
noise = randn(1,nt);
nord = 128;
x = filter(fir1(nord,0.1), 1, noise);  % Eingangssignal
% ------- Fractional-delay Filterung
y = filter(H, x);             % Ausgangssignal mit Ts' = Ts/3 
ny = length(y);

figure(1);   clf;
stem(t, x);
hold on;
plot(t, x);
stem((0:ny-1)*441*Ts/480-2*Ts, y,'r*');

hold off;
title('Signal und interpoliertes Signal mit Ts'' = 441*Ts/480');
xlabel('Zeit in s');    grid on;

% -------- Eingesetzte Versp�tungen
m = 0:1000;
del = mod(m*L/M, 1);     % Versp�tungen
k = find(del == 0)