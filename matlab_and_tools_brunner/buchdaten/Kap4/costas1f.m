function [eing,in,quad,t] = costas1f(ptau, ptau1, ptau2, pf0,...
      pkvco, p_ph_fehler)
% Funktion zur Untersuchung der Costas-Schleife aus dem 
% Modell costas_1.mdl
%
% ptau = Zeitkonstante des Filters für das Eingangssignal
% ptau1 = Zeitkonstante für das Filter, das 
%         die Unterdrückung der doppelten Trägerfrequenz bewirkt
% ptau2 = Zeitkonstante des Schleifen-Filters
% pkvco = Verstärkung des VCOs; 
% p_ph_fehler1 = Phasenfehler des VCOs
% eing, in, quad und t = Signale und Zeit
%
% Testaufruf: 
%[y1, y2, y3, t] = costas1f(0.2e-2, 0.05e-2, 0.01,1000, 5000, pi/3);

%-------- Parametervariablen des Modells pll_5.mdl
tau = ptau;   tau1 = ptau1;   tau2 = ptau2;   
f0 = pf0;     kvco = pkvco;   ph_fehler = p_ph_fehler;

%-------- Aufruf der Simulation
my_options = simset('OutputVariables','ty','SrcWorkspace','current');

tstart = 0;          tfinal = 0.4;
dt = 1/(5*f0);
[t,x,y] = sim('costas_2',[tstart:dt:tfinal],my_options);

in = y(:,1);       quad = y(:,2);     eing = y(:,3);

%-------- Darstellung der Ergebnisse

figure(1);     clf;
subplot(211), plot(t, [in, quad]);
title('Inphase und Quadratur-Komponente');
xlabel('Zeit in s');    grid;

subplot(212), plot(t, eing);
title('Eingangssignal');
xlabel('Zeit in s');    grid;

