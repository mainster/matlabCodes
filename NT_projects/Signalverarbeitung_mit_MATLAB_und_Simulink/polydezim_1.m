% Programm polydezim_1.m zur Parametrierung der Modelle
% polydezim_1_.mdl oder polydezim_2_.mdl bzw. polydezim_3_.mdl 

fs = 1000;
Ts = 1/1000;
% --------- FIR-Filter
M = 5;
fr = 1/(2*M);     % Relative Frequenz 

nf = 128;
h = fir1(nf-1, 2*fr);

% --------- Parameter des Polyphasenfilters
rn = rem(nf,M);   
if rn == 0
    g = zeros(M, nf/M);  % nf ein Vielfaches von M
else
    g = zeros(M, fix(nf/M)+1); % Filterlänge zu einem
    h = [h, zeros(1,M-rn)]; % Vielfach von M erweitert
end;

for k = 1:M
    g(k,:) = h(k:M:end); % Teilfilter des Polyphasen-
end;                     % filters

gt = g';


    