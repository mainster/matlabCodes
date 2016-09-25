% Skript farrow_3.m in dem ein Farrow-Filter
% mit veränderlicher Verspätung untersucht wird
clear;
% ------- Entwicklung des Filters
L = 3;    M = 5;              % Abtastrate Änderungsparameter
f = fdesign.polysrc(L,M);     % Filter-Objekt
f.PolynomialOrder = 3;        % Kubische-Interpolation
H = design(f, 'lagrange');    % Filter Entwurf

% ------- Beispiel für eine Filterung
Ts = 2;      Tfinal = 500;
t = 0:Ts:Tfinal-Ts;
nt = length(t);
% ------- Bandbegrenztes Eingangssignal 
randn('seed', 9375);
noise = randn(1,nt);
nord = 128;
x = filter(fir1(nord,0.1), 1, noise);  % Eingangssignal
% ------- Fractional-delay Filterung
y = filter(H, x);             % Ausgangssignal mit Ts' = 5Ts/3 
ny = length(y);

figure(1);   clf;
stem(t, x);
hold on;
plot(t, x);
stem((0:ny-1)*5*Ts/3-2*Ts, y,'r*');
hold off;
title('Signal und interpoliertes Signal mit Ts'' = 5Ts/3');
xlabel('Zeit in s');    grid on;
