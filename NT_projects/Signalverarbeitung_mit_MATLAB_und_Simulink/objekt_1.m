% Skript objekt_1.m in dem der Umgang mit MATLAB-Objekten
% demonstriert wird
clear;
% ------- plot-Objekt
t = 0:0.1:100;
x = 2.5*sin(2*pi*t/20 + pi/3);
y = 0.15*cos(2*pi*t/10 - pi/4);

% ------- Standard Aufruf
figure(1);    clf;
plot(t, x);
title('Sinus-Signal');   xlabel('Zeit in s');   grid on;

% ------- Aufruf mit Zeiger
figure(2);    clf;
zeiger1 = plot(t,x);
get(zeiger1);




