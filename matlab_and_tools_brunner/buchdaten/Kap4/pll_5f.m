function [y_eing, y_filter, y_vco, t] = pll_5f(f01, tau1, kvco1, ph_fehler1)
% Funktion zur Untersuchung des PLL-Modells pll_5.mdl
% fo1 = Ruhefrequenz; 
% tau1 = Zeitkonstante des Schleifen-Filters
% kvco = Verstärkung des VCOs; 
% ph_fehler1 = Phasenfehler des VCOs
% y_eing, y_filter, y_vco und t = Signale und Zeit
%
% Testaufruf: [y1, y2, y3, t] = pll_5f(100, 0.5, 500, pi/3);

%-------- Parametervariablen des Modells pll_5.mdl
f0 = f01;
tau = tau1;
kvco = kvco1;
ph_fehler = ph_fehler1;

%-------- Aufruf der Simulation
my_options = simset('OutputVariables','ty','SrcWorkspace','current');
tfinal = 1;
dt = tfinal/1000;
[t,x,y] = sim('pll_5',[0:dt:tfinal],my_options);

y_filter = y(:,1);       y_vco = y(:,2);     y_eing = y(:,3);

%-------- Darstellung der Ergebnisse
n = length(y(:,1));
nf = fix(n/10);
nd1 = 1:nf;

figure(1);     clf;
subplot(211), plot(t(nd1), [y_eing(nd1), y_vco(nd1)]);
title('Eingangs- und VCO-Signal beginend mit t = 0');
xlabel('Zeit in s');    grid;

subplot(212), plot(t(nd1), y_filter(nd1));
title('Ausgangssignal des Schleifenfilters beginned mit t = 0');
xlabel('Zeit in s');    grid;

nd1 = n-nf:n;
figure(2);     clf;
subplot(211), plot(t(nd1), [y_eing(nd1), y_vco(nd1)]);
title('Eingangs- und VCO-Signal im stationaeren Zustand');
xlabel('Zeit in s');    grid;

subplot(212), plot(t(nd1), y_filter(nd1));
title('Ausgangssignal des Schleifenfilters im stationaeren Zustand');
xlabel('Zeit in s');    grid;

figure(3);     clf;
plot(t, y_filter);
title('Ausgangsspannung des Filters');
xlabel('Zeit in s');    grid;

