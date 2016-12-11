%% Calculate Gtot (1)
% Calculate tf Gtot by subsystem tfs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear KEL KTB KFR KEMF JR RL L s
syms KEL KTB KFR KEMF JR RL L s

fprintf('\n\n')
G1=1/(s*L+RL);
G1=(1/(s*L))/(1+RL/(s*L));
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

if 0
    P=loadGalvoParam(98);
    p=struct;
    
    for k=1:length(P)
        p.(P{k,1}).v=P{k,2};
        p.(P{k,1}).unit=P{k,3};
        p.(P{k,1}).desc=P{k,4};
    end
    Gts=subs(Gt,...
        {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
        {p.KEL.v, p.KTB.v, p.KFR.v, p.KEMF.v, p.JR.v, p.RL.v, p.L.v});
    
else
    p=load('ddict.mat');
    
    Gts=subs(Gt,...
        {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
        {p.KEL.Value, p.KTB.Value, p.KFR.Value, p.KEMF.Value, p.JR.Value,...
        p.RL.Value, p.L.Value});
    Gts1=subs(G1,...
        {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
        {p.KEL.Value, p.KTB.Value, p.KFR.Value, p.KEMF.Value, p.JR.Value,...
        p.RL.Value, p.L.Value});
end
%% Create transfer function (3)
% Create tf based on (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=tf('s');
[num,den]=numden(Gts);
Gts=tf(double(coeffs(num,'s')), double(coeffs(den,'s')))

%%
p=load('ddict.mat');

    Gts1=subs(G1,...
        {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
        {p.KEL.Value, p.KTB.Value, p.KFR.Value, p.KEMF.Value, p.JR.Value,...
        p.RL.Value, p.L.Value});
    
[num,den]=numden(Gts1);
Gts1=tf(double(coeffs(num,'s')), double(coeffs(den,'s')))

%% Plots
% Create system response plots of (3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','lines'))
h.f1=figure(1);
SUBS=210;

% h.s1=subplot(SUBS+1);
bodeplot(Gts, ol.optb); legend show; hold on;
% h.s2=subplot(SUBS+2);
% nyquist(Gts, ol.optn); legend on;

%% Linmod
% Derive a LTI object via linmod of the corresponding simulink mdl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find_system(gcs, 'regexp','on','blocktype','port')
MDL='GalvoModel_v160.slx';
open_system(MDL);
clear S

S=linmodHighLevel(gcs);

%%
% subplot(h.s1); hold all;
for k=1:length(S.zpk.OutputName)
    Gtmp=S.zpk(k);
    Gtmp.Name=['G_' S.zpk.OutputName{k}]
    bodeplot(Gtmp, ol.optb);
end
hold off;

% subplot(h.s2); hold all;
% for k=1:length(S.zpk.OutputName)
%     nyquist(S.zpk(k), ol.optn);
% end
% hold off;






