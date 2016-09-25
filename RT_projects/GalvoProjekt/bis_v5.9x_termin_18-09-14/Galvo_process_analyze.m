%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Galvo_process_analyze.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% -linmod aus Simulink Streckenmodell
%%% -Keine Torsionsfeder mehr 
%%% -Andere modellparameter- bezeichnungen (Version 4.x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

delete(findall(0,'type','line'));
SIMFILES={'GalvoModel_v44_simply',...
          'Galvo_compare_cc_and_nocc_v1',...
          'GalvoModel_v54 New CC'};
        
% *********************************************************************
%               Init block models
% *********************************************************************
param = loadGalvoParam(4);
paramCtrl = loadCtrlParam(4);
evalGalvoParam(4);
init = 0;

load_system(SIMFILES{1});
set_param(SIMFILES{1}, 'AbsTol', 'auto');
        
%open_system(SIMFILES{1});

%%
       
% *********************************************************************
% *********************************************************************
%   SIMO LTI des Streckenmodells inkl. Input/Output- Namen
% *********************************************************************
% *********************************************************************
% ------------------------------------------------------------------------
% SIMO Plant model
% ------------------------------------------------------------------------
load_system(SIMFILES{1});
%set_param( [SIMFILES{2} '/ScopeMain'],'open','off');
set_param(SIMFILES{1}, 'MaxStep', '1e-4');

Plant=linmod(SIMFILES{1});
Plant.filename = SIMFILES{1};
u_ = strrep(Plant.InputName, [Plant.filename '/'], '');
y_ = strrep(Plant.OutputName, [Plant.filename '/'], '');
Plant.InputName = u_;
Plant.OutputName = y_;

P = ss(Plant.a, Plant.b, Plant.c, Plant.d, 'u', u_, 'y', y_);         
[num, den] = ss2tf(Plant.a, Plant.b, Plant.c, Plant.d);
P.Name = Plant.filename;

NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
Ptf = tf(NUM, den, 'u', u_, 'y', y_); 
Ptf.Name = Plant.filename;

[A, b, c, d] = ssdata(P);
Ptf


%%
% *********************************************************************
%       Some plant analyze
% *********************************************************************
% eigenvalues of the system matrix, A, (equivalent to the poles of the 
% transfer fucntion) determine the stability.
%
% det(s*I-A) = 0  -->  Eig(A)
%
poles = eig(A);
ds='---------------------------------------';
sprintf('%s\n\tPlant\n%s', ds, ds)

disp(sprintf('eig(A):\t\t%.1f  %.1f  %.1f',poles(1:3)))
[ps zs]=pzmap(Ptf(4));
disp(sprintf('Poles:\t\t%.1f  %.1f  %.1f\n',ps(1:3)))

disp(sprintf('Time const:\t%.1f  %.3fms  %.3fms',-1e3*(ps(1:3).^(-1)) ))
disp(sprintf('Faustformel Abtastrate: ~0.1*kleinste Zeitkonstante\n%s\n\t--> fs_min = %.4fus',...
    ds, min( -1e6*0.1*(ps(2:3).^(-1)) )))

Co=ctrb(P(4).a,P(4).b);
Ob=obsv(P(4).a,P(4).c);
disp(sprintf('%s\nSteuerbarkeit\t Co=ctrb(P(4).a,P(4).b)\n', ds))
disp(Co)
disp(sprintf('%s\nBeobachtbarkeitsmatrix\t Ob=obsv(P(4).a,P(4).c)\n',ds))
format long
disp(Ob)
format short
disp(sprintf('%s\nBeobachtbarkeit\t rank(Ob):\t %i\n%s\n',ds,rank(Ob),ds))


f3 = figure(3);
step(feedback(P(4),1));
hold all;
step(feedback(P(4),1));
hold off;
grid on;
legend('Cp1','Cpi1');

f4 = figure(4);
h1=bodeplot(feedback(P(4),1));
hold all;
h2=bodeplot(feedback(P(4),1));
legend('Cp1','Cpi1');
hold off;
setoptions(h1, 'FreqUnits', 'kHz');

f5 = figure(5);
opt = nyquistoptions;
opt.XLimMode='manual';
opt.XLim = [-1.5 0.1];
opt.ShowFullContour='off';
nyquist(P(4), opt);
hold all;
nyquist(P(4), opt);
hold off;
grid off;
legend('Cp1','Cpi1');

%ltiview({'step','nyquist'},P(4))

%%
f33=figure(33);
plot(real(ps),imag(ps),'x','LineWidth',2)


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PID tune and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = pidtuneOptions('PhaseMargin',50);

[Cp1, info1] = pidtune(P(4),'PI',opts);
[Cpi1, infoi1] = pidtune(P(4),'PID',opts);

f33 = figure(33);
step(feedback(Cp1*P(4),1));
hold all;
step(feedback(Cpi1*P(4),1));
hold off;
grid on;
legend('Cp1','Cpi1');

f44 = figure(44);
h1=bodeplot(feedback(Cp1*P(4),1));
hold all;
h2=bodeplot(feedback(Cpi1*P(4),1));
legend('Cp1','Cpi1');
hold off;
setoptions(h1, 'FreqUnits', 'kHz');

f55 = figure(55);
opt = nyquistoptions;
opt.XLimMode='manual';
opt.XLim = [-1.5 0.1];
opt.ShowFullContour='off';
nyquist(Cp1*P(4), opt);
hold all;
nyquist(Cpi1*P(4), opt);
hold off;
grid off;
legend('Cp1','Cpi1');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eigener Zustandsraum der Strecke
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JR'     % Rotor inertia
% KMT'    % Torque constant
% Rc'     % Coil resistance
% Lc'     % Coil inductance
% KFR'    % Rotor dynamic friction
% KTB'    % Torsion bar constant
% KBM'    % Back electromotive force
% Rsh'    % Current shunt resistor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param = loadGalvoParam(4);
va = fieldnames(param)';
v2 ={'syms' va{1:end}};

syms x1 x2 x3 xd1 xd2 xd3 u

for k=1:size(va,2)
    eval(['syms ' va{k}]);
end

A1 = [ -(Rc+Rsh)/Lc   -KBM/JR    0;     
         KMT/Lc      -KFR/JR  -KTB;     
           0          1/JR      0    ];

b1=[1; 0; 0];
c1=[0, 0, 1];
d1=0;
x=[x1; x2; x3];
xd=[xd1; xd2; xd3];

ds='---------------------------------------';
sprintf('%s\n\tSystem matrix A:\n%s', ds, ds)
pretty(A1) 
sprintf('%s\n  Equation of motion:   dx = A*x+b*u \n%s', ds, ds)
pretty(A1*x+b*u) 
sprintf('\n\n%s\nState space after param substitution:\n%s', ds, ds)

s2c = struct2cell(param)';

P1 = ss( eval(subs(A1, va, s2c)),...
         eval(subs(b1, va, s2c)),...
         eval(subs(c1, va, s2c)),...
         eval(subs(d1, va, s2c)));

u_ = {'Vcoil'};     
y_ = {'Pos'};     

P1.InputName = u_;
P1.OutputName = y_;
P1     

[num, den] = ss2tf(P1.a, P1.b, P1.c, P1.d);

NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
P1tf = tf(NUM, den, 'u', u_, 'y', y_);

%SIMO3 = tf(num, den, 'u', u_, 'y', y_(1)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% *********************************************************************
%       Torsion bar - no Torsion bar
%*********************************************************************

for k=1:2
    param.KTB = num2str(1e-4*(k-1));
    evalGalvoParam;
    
    tmp1=linmod(SIMFILES{1});
    tmp1.filename = SIMFILES{1};
    u_ = strrep(tmp1.InputName, [tmp1.filename '/'], '');
    y_ = strrep(tmp1.OutputName, [tmp1.filename '/'], '');
    tmp1.InputName = u_;
    tmp1.OutputName = y_;

    Ptmp{k} = ss(tmp1.a, tmp1.b, tmp1.c, tmp1.d, 'u', u_, 'y', y_);         
    [num, den] = ss2tf(tmp1.a, tmp1.b, tmp1.c, tmp1.d);
    Ptmp{k}.Name = tmp1.filename;

    NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
    Ptmptf{k} = tf(NUM, den, 'u', u_, 'y', y_); 
end

Ptmptf{1}(4)
Ptmptf{2}(4)

pole(Ptmp{1}(4))
pole(Ptmp{2}(4))

pole(Ptmp{1}(4))-pole(Ptmp{2}(4))


%% 
% ------------------------------------------------------------------------
% ----- Estimate tf of current controller simulated in LTSpice
% ------------------------------------------------------------------------
estLTI='/home/mainster/CODES_local/matlab_workspace/RT_projects/GalvoProjekt/estimatedLTI/';

if ~exist('tfCC.mat','file')
    tfCC=idSpice('powerstage_PushPull_FET_lochraster_KOB.raw',...
                 'V(out_A)',[0 2e6],[3 1],0);
    save([estLTI 'tfCC'], 'tfCC');
    sprintf('New tf estimated!')
else
    load('tfCC.mat');
    sprintf('estimated tfCC loaded from %s\n', [estLTI 'tfCC.mat'])
end

[num, den] = tfdata(tfCC);
tfCC2 = tf(num, den);
tfCC2 = balred(tfCC2, [1 2 3]);

%-----------------%
%---  Figure 1 ---%
%-----------------%
f1 = figure(1);
h = bodeplot(tfCC, {1e3*180/pi, 10e6*180/pi});
grid on;
opt = getoptions(h);
opt.FreqUnits = 'MHz';
setoptions(h, opt);


Rs=0.1;
Lc=170e-6;
Rc=1.5;

R2=20e3;
R1=10e3;

%-----------------%
%---  Figure 2 ---%
%-----------------%
f2 = figure(2);
SUB = 110;
subplot(SUB+1);

fb=tf(Rs, [Lc Rs+Rc]);
Kp = -R2/R1;

tfccCmpl = feedback(Kp*tfCC, fb);
lt = tf2spiceLaplace(tfccCmpl, 'NumDen',5);



%%

P_current = P(find(~cellfun(@isempty, strfind(P.OutputName,'current'))));
%-----------------%
%---  Figure 2 ---%
%-----------------%
f2 = figure(2);
SUB = 220;
subplot(SUB+1);
rlocus(P_current);
legend('P_current')

subplot(SUB+2);
rlocus(P_current*tfCC);
legend('P_current*tfCC')

subplot(SUB+3);
rlocus(feedback(P_current,1));
legend('P_current')
return


% ------------------------------------------------------------------------
% ----- Wenn die scopes wieder probleme machen --> Signal Log
% ------------------------------------------------------------------------
%%
if 0
par = get_param(SIMFILES{1},'ObjectParameters');
names = fieldnames(par);
for k=1:length(SEARCH)
    ind{k}=find(~cellfun(@isempty, strfind(names,SEARCH{k})));
    if isempty(ind{k})
       add_param(SIMFILES{1}, SEARCH{k}, num2str(VAL(k)))
    else 
%        sprintf('Parameter %s existiert bereits\n', SEARCH{k})
       set_param(SIMFILES{1}, SEARCH{k}, num2str(VAL(k)))
    end
end



    simOut = sim(SIMFILES{1},'SimulationMode','normal',...
                'AbsTol','1e-5',...
                'MaxStep','1e-6',...
                'StopTime', '30e-3', ... 
                'ZeroCross','on', ...
                'SaveTime','on','TimeSaveName','tout', ...
                'SaveState','on','StateSaveName','xoutNew',...
                'SignalLogging','on','SignalLoggingName','logsout',...
                'SaveOutput','on','OutputSaveName','youtNew')

        to = simOut.get('xoutNew');
        h=sig.values;
        h(:,1);
        sig = simOut.get('xoutNew').signals;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% Figure 5 %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f5=figure(5);
    SUB=510;

    for k=1:length(sig)
        subplot(SUB+k)
        plot(to.time , sig(1,k).values) 
    end
end