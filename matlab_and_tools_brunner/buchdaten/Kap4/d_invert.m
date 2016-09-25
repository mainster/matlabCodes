% Programm zur Darstellung der Ergebnisse
% der Simulation eines Inverters mit OP-Modell
% mit dem SIMULINK-Modell s_invert.m
%
disp('Die Simulation muß zuerst durchgeführt werden !!!');

set(0,'DefaultLineLineWidth', 1.2);

figure(1); 	clf;
subplot(211), plot(t, y(:,1), t, y(:,2));
title(' Eingangs- und Ausgangssignal ');
xlabel(' Zeit in s ');	grid;

subplot(212), plot(t, y(:,3));
title(' Eingangsspannung des OPs');
xlabel(' Zeit in s ');  grid;

