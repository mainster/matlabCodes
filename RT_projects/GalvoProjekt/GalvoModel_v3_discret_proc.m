% Das Streckenmodell eines Galvanometermotors scheint bis auf die 
% interpretation von signalnamen und Modell- Parametern mit dem
% Model eines DC- Servo- Motors sehr gut zusammen zu passen
% 
% Dabei ist für die Flußverkettung eines Servo- Motors eine 
% entsprechende physikalische Größe bei einem Galvo- Motor
% zu suchen. 
% Die Drehmomentkonstante eines Galvos ist eine wichtige Größe
% und wird in N/A gemessen.
% --> Für einen Modellansatz muss also als Führungsgröße der
% Wicklungsstrom im Galvo betrachtet werden.
%-------------------------------------------------------------

% V3 mit PID und tfCC  --> DISCRET

%-------------------------------------------------------------
% Diskrete systeme mit sysotool() optimiert.
%
% Gv:           o- linmod() aus simulink- modell v3 des Galvos
% GvD__:        o- kontin. zpk- system mit c2d() in diskretes z- system
%                  mit Ts=25us (GvD25) !!! bzw. Ts=50us (GvD50) konvertiert.
% tfCC:         o- Approximation des prop. stromreglers (Endstufe, CC) 
%               o- AC- Analyse der Schaltung in LTSpice.
%               o- komplexe frequenzfunktion des shuntstroms aus spicelog
%                  extrahiert. Mit idfrd (ident. freq. response data) wurde
%                  über die "system identification toolbox" ein system 3.
%                  Ordnung (2xns, 3xpol) angenähert (Fokus: 0...2MHz).
% tfCCred_      o- Systemordnung des CC modells mit balred() auf Ordnung 
%                  2 bzw. 1 reduziert.
% tfCCp1D__     o- CC mit reduzierter Ordnung, diskretes model über c2d()
%                  erzeugt



% !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! 
% !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! 
% !!!    ---------------------------------------------------------  
% !!!     tfCC hängt von der Wicklungsinduktivität des Galvos ab
% !!!    ---------------------------------------------------------  
% !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! 
% !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! 





% syms s
% [nu, de]=tfdata(gv.tfCTRL_IMC50_5,'v');
% [rs, ps, ks]=residuez(nu,de);
% 
% ccont=d2c(gv.tfCTRL_IMC50_5);
% [nu2, de2]=tfdata(ccont,'v');
% [rs2, ps2, ks2]=residuez(nu2,de2);
% 
% %sv=s.^[length(de2)-1:-1:0];
% psy=s*ones(length(ps2),1)-ps2;
% pbz=rs2./eval(psy);
% 
% pbz2=vpa(pbz,2);
% para=vpa(sum(pbz2)+ks2,2)
% %pretty(vpa(pbz2(2),2))
% s=tf('s');
% para
% sys1=sym2tf(para)
% step(feedback(c2d(sys1,50e-6)*c2d(gv.tfCCred1,50e-6)*c2d(gv.tfGv,50e-6),1))
% return

% tfCC3=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
%                 'I(Shunt2)',[0 2e6],[3,2],1);
% tfCC2=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
%                 'I(Shunt2)',[0 2e6],[2,2],1);
% tfCC1=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
%                 'I(Shunt2)',[0 2e6],[1,1],1);
% [z p k]=zpkdata(tfCC3)
% tfCCp3=zpk(z,p,k)
% [z p k]=zpkdata(tfCC2)
% tfCCp2=zpk(z,p,k)
% [z p k]=zpkdata(tfCC1)
% tfCCp1=zpk(z,p,k)
% return
% tfCC=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
%                 'I(Shunt2)',[0 2e6],[3,2],1);
% s1=tf(tfCC.num(:)',tfCC.den(:)')
% tfCCp2=balred(s1,2)
% tfCCp1=balred(s1,1)
% [z p k]=zpkdata(tfCCp2)
% tfCCp2=zpk(z,p,k)
% [z p k]=zpkdata(tfCCp1)
% tfCCp1=zpk(z,p,k)
% tf2spiceLaplace(tfCCp1)
% return


%[z,p,k]=linmod('GalvoModel_v3_tfCCneu');
%[num den]=linmod('GalvoModel_v3_tfCCneu');
%st=linmod('GalvoModel_v3');
%stneu=linmod('GalvoModel_v3_tfCCneu');
%[z p k]=tf2zpk(num,den);
%tfGvCC = zpk(z(:1),p,k);
%tfGvCC(1,:)=tf(num(1,:),den,'OutputName','angle');
%tfGvCC(2,:)=tf(num(2,:),den,'OutputName','current');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Direkter vergleich von SISO und SIMO systemen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    siso=linmod('GalvoModel_v3');
    simo=linmod('GalvoModel_v3_SIMO');

    [nso dso]=ss2tf(siso.a, siso.b, siso.c, siso.d);
    [nmo dmo]=ss2tf(simo.a, simo.b, simo.c, simo.d);

    sisys=tf(nso,dso)
    mosys=tf({nmo(1,:), nmo(2,:)},dmo)

    f33=figure(33);
    subplot(121);
    step(sisys);
    grid on

    subplot(122);
    step(mosys);
    grid on

    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Vergleich von simo mit und ohne current ctrl in simulink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
    gv=load('GV');
% ------------------------------------------------------
%          P- Regler parameter
%
%       ccKp = (Gain*CR)/(1-Gain*H)
%       Gain = (CR/ccKp + H)^(-1)
% ------------------------------------------------------
    H=1/20;
    H=0.1403;
%    H=1;
    calc_ccKp=@(x,y) (x*CR)/(1-x*y)
    ccKp=calc_ccKp(10,H)
    
    C=gv.tfCCv2p2;
    
    clear tf1 tf2;
    t1=linmod('GalvoModel_v3_SIMO');
    [num, den] = linmod('GalvoModel_v3_SIMO');
    sys1(:,2)=fieldnames(t1);
    sys1(1,1)={t1};
    sys1(:,3)=struct2cell(t1);
    tf1=tf({num(1,:); num(2,:)}, den);
    
    G=tf1;
    
%    t2=linmod('GalvoModel_v3_tfCCneu');
%    t2.filename='GalvoModel_v3_tfCCneu';
    t2=linmod('GalvoModel_v3_tfCCneu_frd');
    t2.filename='GalvoModel_v3_tfCCneu_frd';

    t2.InputName=strrep(t2.InputName, t2.filename, 'v3_CCneu');
    [num2, den2] = linmod('GalvoModel_v3_tfCCneu_frd');
    sys2(:,2)=fieldnames(t2);
    sys2(1,1)={t2};
    sys2(:,3)=struct2cell(t2);
    tf2=tf({num2(1,:); num2(2,:)}, den2,...
            'OutputName',strrep(sys2{1}.OutputName, t2.filename, 'neu' ),...
            'InputName',sys2{1}.InputName);
    tf2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% P- Regler 'C' ist in einem simulink modell schon verbaut,
%%%% im anderen wird er von hand mit dem SIMO- modell verbunden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	C=pid( ccKp );  
%    C=gv.tfCCv2p2;
%    Hs=tf(H);
    Hs=tf(H);
     INV=tf(-1);
     INV.u='e';
     INV.y='ei'
    Hs.u='current';
    Hs.y='hy';
    C.u='ei'; 
    C.y='u';
%    G.u='u'; 
    G.u='u'; 
    G.y{1}='pos';
    G.y{2}='current';

    Sum = sumblk('e = r + hy');
    Gt = connect(G,C,INV,Hs,Sum,'r',{'pos','current'});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Sum = sumblk('e = r - hy');
%   + statt - weil C=gv.tfCCv2p1 ein invertierender verstärker ist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%|    _    |%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%|   | |   |%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%|   | |   |%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%|   \ /   |%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%|    V    |%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f33=figure(33);
    
    ha(1)=subplot(121);
    step(Gt);
    title(ha(1),'Stromregler per SIMO- modell und connect() angebunden')
    grid on

	ha(2)=subplot(122);
    step(tf2);
    title(ha(2),'Stromregler in Simulink ')
    grid on
    
    f34=figure(34);
    
    ha(3)=subplot(121);
    step(feedback(Gt,[1,0]));
    title(ha(3),'closed loop Stromregler per SIMO- modell und connect() angebunden')
    grid on

	ha(4)=subplot(122);
    step(feedback(tf2,[0,1]));
    title(ha(4),'closed loop Stromregler in Simulink ')
    grid on    
    
    open_bd = find_system('type', 'block_diagram');
    ind=find(~cellfun(@isempty, strfind(open_bd,'tfCCneu')));
    if ~isempty(ind)
        blp=find_system(open_bd(ind),'Type','Block');
    else
        disp('blockdiagram not found')
        open ('GalvoModel_v3_tfCCneu');
    end
    bt = get_param(blp,'BlockType')
%    par = get_param(st(5),bt{5})

    opts = pidtuneOptions('PhaseMargin',40);
    [Csis, info] = pidtune(( Gt(1) ),'pidf',opts);
    sisotool(Gt(1),Csis)
    
return
    [a1, b1, c1, d1]=linmod('GalvoModel_v3_SIMO');
    ss1=ss(a1, b1, c1, d1);
    [n1 d1]=ss2tf(a1, b1, c1, d1);
    sys1=tf({n1(1,:), n1(2,:)},d1,ss1);

    t2=linmod('GalvoModel_v3_tfCCneu');

    [a1, b1, c1, d1]=linmod('GalvoModel_v3_tfCCneu');
    ss2=ss(a1, b1, c1, d1);
    [ncc dcc]=ss2tf(a1, b1, c1, d1);
    sys2=tf({ncc(1,:), ncc(2,:)},dcc,ss2)

%     [n1 d1]=ss2tf(sys.a, sys.b, sys.c, sys.d);
%     [ncc dcc]=ss2tf(syscc.a, syscc.b, syscc.c, syscc.d);
%     sys1=tf({n1(1,:), n1(2,:)},d1)
%     sys2=tf({ncc(1,:), ncc(2,:)},dcc)

    CP=pid(10*CR/(1-10*H))
%    connect(CP)
    f33=figure(33);
    subplot(121);
    step(sys1);
    grid on

    subplot(122);
    step(sys2);
    grid on

    return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[nu de]=ss2tf(st.a,st.b,st.c,st.d)
[nuneu deneu]=ss2tf(stneu.a,stneu.b,stneu.c,stneu.d)

tfGvCC=tf({nuneu(1,:), nuneu(2,:)},deneu)
%tfGvCC.InputName='Ue'; 

opt=pidtuneOptions;
opt.PhaseMargin=40;
C0=pidstd(1,1,1,1);
[ctrl1 info]=pidtune(tfGvCC(1,:),C0,opt)
f33=figure(33);
step(feedback(ctrl1*tfGvCC,[1 1]));
step(feedback(ctrl1*tfGvCC(1,:),0))
grid on

dcgain(tfGvCC)
return

delete(findall(0,'type','line'));


LOAD=0;

if ~LOAD   
    if ~exist('param')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Liste der Modellparameter
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        param={
            'RIN';   % Rotor inertia
            'TRC';   % Torque constant
            'CR';    % Coil resistance
            'CL';    % Coil inductance
            'FR';    % Rotor dynamic friction
            'KTR';   % Torsion bar constant
            'BEM'       % Back electromotive force
            };
    end
    if find( ~cellfun(@exist, param(:)))

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Modell 6860
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mod_6860={
        '6e-8'       % Rotor inertia
        '9.3e-3'     % Torque constant
        '1.5'        % Coil resistance
        '160e-6'     % Coil inductance
        '4e-6'       % Rotor dynamic friction
        '100e-3'     % Torsion bar constant
        '170e-6'     % Back electromotive force
    };


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % another CamTech 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mod2={
        '1.25e-8'    % Rotor inertia
        '6.17e-3'      % Torque constant
        '2.79'        % Coil resistance
        '180e-6'      % Coil inductance
        '1e-12'        % Rotor dynamic friction
        '47e-3'      % Torsion bar constant
        '108e-6'       % Back electromotive force
    };

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameter für Blockvereinfachung
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    paramSimp={
        'T1', 'CL/CR';
        'K1', 'TRC/CR';
        'T2', 'RIN/FR';
        'K2', '1/FR';
    };

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Wertetabelle für simulink- mod. laden
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    syms(param{:});
    syms(paramSimp{:,1});

        for i=1:length(param);      
            eval([param{i} '=' Mod2{i}]); 
        end;
    end
    % for i=1:length(paramSimp);  
    %     eval([paramSimp{i,1} '=' paramSimp{i,2}]); 
    % end;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %open 'GalvoModel_v3_PID_tfCC';

    SIMU={  'GalvoModel_v3',...
            'GalvoModel_v3_PID_tfCC',...
            'GalvoModel_servolike_v2_simpli_B',...
            'GalvoModel_servolike_v2_simpli_B2',...
            'GalvoModel_servolike_v2'};

    %-----------------------------------------
    %---  linmod Galvo tf by simulink model
    %-----------------------------------------
    clear gv.tfGv 
    for i=1:1
        [num den]=linmod(SIMU{i});
        [z p k]=tf2zpk(num,den);
        gv.tfGv(i,:)= zpk(z,p,k);
    end

    % ---------------------------------------------------------------
    % ----- Estimate tf of current controller, simulated by LTSpice
    % ---------------------------------------------------------------
    tfCC=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
                    'I(Shunt2)',[0 2e6],[3,2],0);

else
    gv=load('GV');
end

% ---------------------------------------------------------------
% ---------------------------------------------------------------

%-------------------------------
%---  random testsignal
%-------------------------------
y=-0.5+rand(1,20);

y2=[];
for k=1:20
    y2=[y2 ones(1,500)*y(k)];
end
uw=y2*2;
%-------------------------------

%Gp=gv.tfCC*gv.tfGv;       % Plant model including current controller            


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 21 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f21=figure(21);
set(f21,'Name','Discret system Ts=25us','NumberTitle','off')

delete(findall(f21,'type','text'))
marg=[0.03 0.03];
hs1(1)=subtightplot(2,2,1,marg);  
hs1(2)=subtightplot(2,2,2,marg);  
hs1(3)=subtightplot(2,2,3:4,marg);  

P=nyquistoptions;
P.ShowFullContour='off';
P.XLim=[-2 2];
P.YLim=[-2 1];

clear G0D;
G0D=gv.tfCTRL_IMC25_4_0003*gv.Gp1D25;

[~, tsim]=lsim(feedback(G0D,1),uw);

for i=1:3
    cla(hs1(i),'reset');
    hold(hs1(i), 'all');
end
plot(hs1(2),tsim,uw,'Color',[1 1 1]*0.4,'Linestyle','--')
%tt=linspace(0,2e-3,200);
tt=[0:25e-6:4e-3];
subplot(hs1(2));

lg=[];
for k=1:5
%---------------------------------------------------
%-----  increase discrete-time delays
%---------------------------------------------------
    gv.Gp1D25.InputDelay=k-1;
    G0D=gv.tfCTRL_IMC25_5_00025*gv.Gp1D25;
    
    [z, p, ks]=zpkdata(G0D,'v');
    [A,b,c,d]=zp2ss(z, p, ks);
    [ysim tsim]=lsim(   feedback(ss(A,b,c,d,G0D),1),uw);
    
    subplot(hs1(1));
    nyquist(G0D,P);

    subplot(hs1(2));
    plot(tsim,ysim,'linewidth',1);

    subplot(hs1(3));
    stepplot( feedback(ss(A,b,c,d,G0D),1),tt );
    lg=[lg, sprintf('Delay: %.0f;',k-1)];
    grid on;
end
textVisible(f21,'nyquist','off');

subplot(hs1(2));
grid on;
legend('ref', strsplit(lg(1:end-1),';')');

subplot(hs1(3));
grid on;
legend(strsplit(lg(1:end-1),';')');

set(hs1(3),'XTickMode','manual')
set(hs1(3),'XTick',tt)

xtl=[];
for k=0:20*25e-6:2*2e-3
    xtl=[xtl, sprintf('%.2fms',k*1e3), '||||||||||||||||||||'];
end

set(gca,'XTickLabel', xtl)


    
% for k=1:20
%     gv.Gp1D25.InputDelay=k-1;
%     G0D=gv.tfCTRL_IMC25_5_00025*gv.Gp1D25;
%     [gm(k), pm(k), wgm(k), wpm(k)]=margin(G0D);
% end
% f30=figure(30);
% hold all;
% subplot(121);
% plot([1:20],pm);
% subplot(122);
% plot([1:20],wpm);
% hold off;


%(-4.2594e06*(s+1.698e05)*(s+2.212e04)*(s^2+17.58*s+1.77e06) )/(
%s*(s^2+3.872e04*s+1.09e09)*(s^2+7.744e04*s+5.447e09) )

%-------------------------------
%---  random testsignal
%-------------------------------
% y=-0.5+rand(1,20);
% 
% y2=[];
% for k=1:20
%     y2=[y2 ones(1,250)*y(k)];
% end
% uw=[y2 y2]*2;
%-------------------------------
uw=downsample(uw,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 22 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f22=figure(22);
set(f22,'Name','Discret system Ts=50us','NumberTitle','off')

delete(findall(f22,'type','text'))
marg=[0.03 0.03];
hs2(1)=subtightplot(2,2,1,marg);  
hs2(2)=subtightplot(2,2,2,marg);  
hs2(3)=subtightplot(2,2,3:4,marg);  

P=nyquistoptions;
P.ShowFullContour='off';
P.XLim=[-2 2];
P.YLim=[-2 1];

clear G0D;

G0D=gv.tfCTRL_IMC50_5*gv.Gp1D50;
%G0D(2)=gv.tfCTRL_IMC50_5_00025*gv.Gp1D25;
[~, tsim]=lsim(feedback(G0D,1),uw);
for i=1:3
    cla(hs2(i),'reset');
    hold(hs2(i), 'all');
end
plot(hs2(2),tsim,uw,'Color',[1 1 1]*0.4,'Linestyle','--')
%tt=linspace(0,2e-3,200);
%tt=[0:50e-6:2*2e-3];
tt=downsample(tt,2);
subplot(hs2(2));

lg=[];
for k=1:5
%---------------------------------------------------
%-----  increase discrete-time delays
%---------------------------------------------------
    gv.Gp1D50.InputDelay=k-1;
    G0D=gv.tfCTRL_IMC50_5*gv.Gp1D50;

    [z, p, ks]=zpkdata(G0D,'v');
    [A,b,c,d]=zp2ss(z, p, ks);
    [ysim tsim]=lsim(   feedback(ss(A,b,c,d,G0D),1),uw);
    
    subplot(hs2(1));
    nyquist(G0D,P);

    subplot(hs2(2));
    plot(tsim,ysim,'linewidth',1);

    subplot(hs2(3));
    stepplot( feedback(ss(A,b,c,d,G0D),1),tt );
    lg=[lg, sprintf('Delay: %.0f;',k-1)];
    grid on;
end
textVisible(f21,'nyquist','off');

subplot(hs2(2));
grid on;
legend('ref', strsplit(lg(1:end-1),';')');

subplot(hs2(3));
grid on;
legend(strsplit(lg(1:end-1),';')');

set(hs2(3),'XTickMode','manual')
set(hs2(3),'XTick',tt)

xtl=[];
for k=0:10*50e-6:2*2e-3
    xtl=[xtl, sprintf('%.2fms',k*1e3), '||||||||||'];
end

set(gca,'XTickLabel', xtl)

ylim(hs2(2),get(hs1(2),'YLim'));




Gp1=gv.tfCCred1*gv.tfGv;
opts = pidtuneOptions('PhaseMargin',40);
[tfPidf, info] = pidtune(( Gp1 ),'pidf',opts);







return









tooled={'gv.tfCC','gv.tfGv','Gp_out','C_out'};

if find(~cellfun(@exist, tooled)) ~= 0
    if ~exist('PIDF_1.mat','file')
        pidtool(Gp)
    else
        load('PIDF_1.mat');
    end
end
[nu de]=tfdata(gv.tfCC)
gv.tfCC=tf(nu,de);
gv.tfCCred=balred(gv.tfCC,2)

gv.tfGvred=balred(gv.tfGv,2)

% spi(1,:)={  tf2spiceLaplace(tf(gv.tfCCred.num{1},gv.tfCCred.den{1})),...
%             tf2spiceLaplace(tf(gv.tfCCred.num{2},gv.tfCCred.den{2})) };
        
Gpred=gv.tfCCred*gv.tfGvred;
opts = pidtuneOptions('PhaseMargin',40);
[tfPIDFred, info] = pidtune(( gv.tfCCred*gv.tfGvred ),'pidf',opts);
[tfPIDF, info] = pidtune(( gv.tfCC*gv.tfGv ),'pidf',opts);

T = sisoinit(1);
T.Name=['siso_cfg_' sprintf('%d%02.0f%02.0f_%02.0f%02.0f%02.0f',fix(clock))];
T.G.Value=Gp;
T.G.Name='Gp';
T.C.Value=tfPIDF;
T.C.Name='tfPIDF';
T.OL1.View = {'rlocus','bode'};
T.CL1.View = {'bode'};

save(T.Name,'T');

sisotool(T)
return







