%% Calculate Gtot (1) 
% Calculate tf Gtot by subsystem tfs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%% Load Galvo parameters (2)
% Load parameter set and derive a param structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=loadGalvoParam(98);
p=struct;

for k=1:length(P)
    p.(P{k,1}).v=P{k,2};
    p.(P{k,1}).unit=P{k,3};
    p.(P{k,1}).desc=P{k,4};
end

%% Create transfer function (3)
% Create tf based on (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=tf('s');

Gts=subs(Gt,...
    {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
    {p.KEL.v, p.KTB.v, p.KFR.v, p.KEMF.v, p.JR.v, p.RL.v, p.L.v});

[num,den]=numden(Gts);
Gts=tf(double(coeffs(num,'s')), double(coeffs(den,'s')))

%% Plots
% Create system response plots of (3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','lines'))
h.f1=figure(1);
SUBS=210;

h.s1=subplot(SUBS+1);
bodeplot(Gts, ol.optb); legend on;
h.s2=subplot(SUBS+2);
nyquist(Gts, ol.optn); legend on;

%% Linmod
% Derive a LTI object via linmod of the corresponding simulink mdl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MDL='GalvoModel_v160.slx';
open_system(MDL);

S=linmodHighLevel(gcs);

subplot(h.s1); hold all;
for k=1:length(S.zpk.OutputName)
    bodeplot(S.zpk(k), ol.optb);
end
hold off;

subplot(h.s2); hold all;
for k=1:length(S.zpk.OutputName)
    nyquist(S.zpk(k), ol.optn); 
end
hold off;
    





