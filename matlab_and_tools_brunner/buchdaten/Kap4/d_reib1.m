% Programm (d_reib1.m) zur Darstellung der Ergebnisse der Simulation 
% mit dem SIMULINK-Modell s_reib1.m darstellt

disp('Die Simulation muß zuerst durchgeführt werden !!!');

set(gcf,'DefaultLineLineWidth',1);

figure(1);			clf;
subplot(211), plot(yout(:,5), yout(:,1),yout(:,5), yout(:,2));
title(' Auslenkung der Plattform und der aufgelegten Masse');
xlabel(' Zeit in s');		grid;

subplot(212), plot(yout(:,5), yout(:,3));
title(' Haft- und Gleitreibungskraft ');
xlabel(' Zeit in s');		grid;

figure(2);			clf;
plot(yout(:,1),yout(:,4));
title(' Phasenkurve der Plattform ');
ylabel(' Geschwindigkeit Plattform');	
xlabel(' Auslenkung Plattform');	grid;

