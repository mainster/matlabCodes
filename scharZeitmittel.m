%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stochastik - Ergodizität prüfen:
%% Schar- und Zeitmittelwerte
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Uniformly distributed random numbers ohne mittelwert
% 100 Musterfunktionen mit je 5000 Werten
x=rand(1000,100)-.5;

f1=figure(1);
SUBS=210;

% 100x Zeitmittelwert bilden
mxt = sum(x)/size(x,2);
subplot(SUBS+1);
plot(mxt); legend('Zeitmittelwerte');

% 1000x Ensamble mittelwert bilden
mxe = sum(x')/size(x',2);
subplot(SUBS+2);
plot(mxe); legend('Schar-mittelwerte');



