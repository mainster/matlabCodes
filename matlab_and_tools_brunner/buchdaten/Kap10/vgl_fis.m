clear;clf;
gen_trndata;  % generiert Trainingsdaten trn
fstart=readfis('fstart.fis');
n_epoch=100;  % Anzahl Optimierungszyklen
[fopt,error]=anfis(trn,fstart,n_epoch); % fstart wird trainiert
y_start=evalfis(x',fstart); % generiert "Startkennlinie" fstart
y_opt=evalfis(x',fopt);  % generiert optimierte Kennlinie fopt
plot(x,y_gen,x,y_start,x,y_opt);  %
xlabel('Input x');
ylabel('Output y'); 
title('Vergleich');