function [tfCalc, tfLin]=calcGtot(model, varargin)
% [tfCalc, tfLin]=calcGtot(model, varargin) can be used to compare "by hand"
%   calculated tf Gtot by a LTI object which is derived from a block diagram
%   via linmod.
% (...) = calcGtot('mdl', 1.5) Call function with iL_40Deg=1.5A argument. This
%   means, the model parameter KTB will be calculated by
%   KTB=KEL*iL_40Deg/dPosMax

%% Parse Input args (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~ischar(model)
    error 'Please pass a simulink model file name in first argument'
end

model = strsplit(model,'.');

if ~exist([model{1} '.slx'], 'file') && ~exist([model{1} '.mdl'], 'file')
    error ('model %s not found!', model)
end

%% Load Galvo parameters (2)
% Load parameters from data dictionary file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MDL=model{1};
open_system(MDL,'loadonly');
DATA_DICT=get_param(MDL,'DataDictionary');
ddo=Simulink.data.dictionary.open(DATA_DICT);
dds=ddo.getSection('Design Data');

% Check if model has a KTBsub block
hasKTBsub=~isempty(find_system(MDL,'Name','KTBsub'));

%% Parse Input args (2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==1
    if hasKTBsub
        set_param([MDL '/KTBsub'], 'iL_40', '0');
    else
        ddModifyEntry(get_param(MDL,'DataDictionary'),'KTBmess',0);
        set_param([MDL '/Torsion Bar'], 'Gain','KTB');
    end
else
    if isnumeric(varargin{1})
        if hasKTBsub
            set_param([MDL '/KTBsub'], 'iL_40', num2str(varargin{1}));
        else
            iL_40=varargin{1};
            % Calc KTB as function of iL_40
            KTBmess_=iL_40*dds.getEntry('KEL').getValue.Value/...
                dds.getEntry('dPosMax').getValue.Value
            ddModifyEntry(get_param(MDL,'DataDictionary'),'KTBmess',KTBmess_);
            set_param([MDL '/Torsion Bar'], 'Gain','KTBmess');
        end
    end
end

%% Calculate Gtot (1)
% Calculate tf Gtot by subsystem tfs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms KEL KTB KFR KEMF JR RL L real; syms s
ds=evalin('base','ds');
ol=evalin('base','ol');

% fprintf('\n%s\n%s\n',ds,ds);
G1=1/(s*L+RL);
G2=1/(s*JR+KFR);
G3=G1*KEL;
G4=G2/(1+G2*KTB/s);
G5=G3*G4/(1+G3*G4*KEMF);
G6=G5/s;

% Gsym=[{G1,'G1'}; {G2,'G2'}; {G3,'G3'}; {G4,'G4'}; {G5,'G5'}; {G6,'G6'}];
Gsym=[G1;G2;G3;G4;G5;G6];

for k=1:length(Gsym)
    Gsym(k)=collect(simplify(Gsym(k), 'steps', k*10), s);
%     pretty(Gsym(k));
end

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
%%
if hasKTBsub
    % Determine if KTB from data dict is used or if KTBmess(iL_40Deg) is used
    if str2double(get_param([MDL '/KTBsub'], 'iL_40')) ~= 0
        % Replace the numeric value of KTB by KTBmess
        numvec(~cellfun(@isempty, strfind(svstr,'KTB')))=...
            dds.getEntry('KTBmess').getValue;
    end
else
    if dds.getEntry('KTBmess').getValue.Value ~= 0
        % Replace the numeric value of KTB by KTBmess
        numvec(~cellfun(@isempty, strfind(svstr,'KTB')))=...
            dds.getEntry('KTBmess').getValue.Value;
    end
end
% Substitution of syms, except s
Gsys=sym2tf( vpa(subs(Gsym, svs, num2cell(numvec)), 5) );
set(Gsys,'OutputName', {'G1' 'G2' 'G3' 'G4' 'G5' 'G6' });

%
% s=tf('s');
% [num,den]=numden(Gts);
% Gts=tf(double(coeffs(num,'s')), double(coeffs(den,'s')))
% p=load('ddict.mat');
%
% Gts1=subs(G1,...
%     {'KEL' 'KTB' 'KFR' 'KEMF' 'JR' 'RL' 'L'},...
%     {p.KEL.Value, p.KTB.Value, p.KFR.Value, p.KEMF.Value, p.JR.Value,...
%     p.RL.Value, p.L.Value});
%
% [num,den]=numden(Gts1);
% Gts1=tf(double(coeffs(num,'s')), double(coeffs(den,'s')))

%% Linmod (4)
% Derive a LTI object via linmod of the corresponding simulink mdl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear S
open_system(MDL);
S=linmodHighLevel(gcs);

%% Plots (5)
% Create system response plots of (3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete(findall(0,'type','line'))
h.f1=figure(1);

GtCalc=Gsys(6);
GtCalc.Name='GtCalc';
hold on;
bodeplot(GtCalc, ol.optb);
legend show; hold on;

%%
GtLin=S.zpk(end);
GtLin.Name=['G_' S.zpk.OutputName{end}];
bodeplot(GtLin, '-.');

tfCalc=GtCalc;
tfLin=S.zpk;


