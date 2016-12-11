%% Calculate Gtot (1)
% Calculate tf Gtot by subsystem tfs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vars=[KEL KTB KFR KEMF JR RL L];
clear vars s
syms vars s

fprintf('\n%s\n%s\n',ds,ds);
G1=1/(s*L+RL);
G2=1/(s*JR+KFR);
G3=G1*KEL;
G4=G2/(1+G2*KTB/s);
G5=G3*G4/(1+G3*G4*KEMF);
G6=G5/s;

Gsym=[G1; G2; G3; G4; G5; G6];
for k=1:length(Gsym)
    Gsym(k)=collect(simplify(Gsym(k), 'steps', k*10), s);
    pretty(Gsym(k));
end

%% Load Galvo parameters (2)
% Load parameters from data dictionary file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DATA_DICT='modelDesignData_Galvo_sys_Ccont_Pcont.sldd';
ddo=Simulink.data.dictionary.open(DATA_DICT);
dds=ddo.getSection('Design Data');

%% Create transfer function (3)
% Create tf by subs symbolic equation from (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get all sym variables and Remove non-replaceable symbolic variable 's'
svs=symvar(Gsym);
svs=svs(svs~=s);
svstr=arrayfun(@char, svs, 'UniformOutput', false);

% Create numeric vector for symbol substitution
numvec=zeros(size(svs));
for k=1:length(svs); 
     numvec(k)=dds.getEntry(svstr{k}).getValue.Value;
end    

% Substitution of syms, except s
Gnum=vpa(subs(Gsym, svs, num2cell(numvec)), 5);

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






