%% Calculate Gtot

clear KEL KTB KFR KEMF JR RL L s
syms KEL KTB KFR KEMF JR RL L s

fprintf('\n\n')
G1=1/(s*L+RL);
G2=1/(s*JR+KFR);
G3=G1*KEL;
G4=G2/(1+G2*KTB/s);
G5=G3*G4/(1+G3*G4*KEMF);
G6=G5/s;

Gt=collect(G6,s);
pretty(Gt)

%% Load Galvo parameters
P=loadGalvoParam(98);
P{3,2} = '1.5';
P
p=struct;


for k=1:length(P)
    p.(P{k,1}).v=P{k,2};
    p.(P{k,1}).unit=P{k,3};
    p.(P{k,1}).desc=P{k,4};
end


%% Create transfer function
s=tf('s');

Gts=subs(Gt,...
    {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
    {p.KEL.v, p.KTB.v, p.KFR.v, p.KEMF.v, p.JR.v, p.RL.v, p.L.v});

[num,den]=numden(Gts);
Gts=tf(double(coeffs(num,'s')), double(coeffs(den,'s')))

%% Plots
bodeplot(Gts, ol.optb)
nyquist(Gts, ol.optn)

