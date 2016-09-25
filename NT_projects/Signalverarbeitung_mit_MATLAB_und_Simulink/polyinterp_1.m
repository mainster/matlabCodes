% Programm polyinterp_1.m zur Parametrierung der Modelle
% polyinterp_1_.mdl oder polyinterp_2_mdl bzw. polyinterp_3_mdl 

fs = 1000;
Ts = 1/1000;
% --------- FIR-Filter
nf = 128;
L = 5;
fr = 1/L;
h = fir1(nf-1, fr);

% --------- Parameter des Polyphasenfilters
L = 5;
rn = rem(nf,L);
if rn == 0
    g = zeros(L, nf/L);
else
    g = zeros(L, fix(nf/L)+1);
    h = [h, zeros(1,L-rn)];
end;

for k = 1:L
    g(k,:) = h(k:L:end);
end;

gt = g';


    