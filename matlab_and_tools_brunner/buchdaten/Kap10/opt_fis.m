clear;clf;
gen_trndata;  % generiert Trainingsdaten trn
fstart=readfis('fstart.fis');  % liest zu trainierendes FIS fstart ein
n_epoch=100;  % Anzahl Optimierungszyklen
[fopt,error]=anfis(trn,fstart,n_epoch); % fstart wird trainiert
plot(error);  % Plot mit den Werten des Fehlerkriteriums 
xlabel('nach Anzahl Zyklen');
ylabel('Fehlerkriterium'); 
title('Optimierungsverlauf');