% Programm zur Darstellung der Ergebnisse
% der Simulation eines Differenzierers mit OP_Modell
% mit dem SIMULINK-Modell s_differ.m
%
disp('Die Simulation mu� zuerst durchgef�hrt werden !!!');

set(0,'DefaultLineLineWidth', 1.2);

figure(1); 	clf;
subplot(211), plot(t, y(:,1), t, y(:,2));
title(' Eingang- und Ausgangssignal ');
xlabel(' Zeit in s ');	grid;

subplot(212), plot(t, y(:,3));
title(' Eingangsspannung des OPs');
xlabel(' Zeit in s ');  grid;

  