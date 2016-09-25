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

delete(findall(0,'type','line'));


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
	'4e-6'        % Rotor dynamic friction
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
% Modell 6860
%
RIN=    6e-8;    % Rotor inertia
TRC=    9.3e-3;      % Torque constant
CR=     1.5;        % Coil resistance
CL=     160e-6;      % Coil inductance
FR=     4e-6;        % Rotor dynamic friction
KTR=    100e-3;      % Torsion bar constant
BEM=    170e-6;       % Back electromotive force

% other CamTech
%
RIN=1.25e-8;    % Rotor inertia
TRC=6.17e-3;      % Torque constant
CR=2.79;        % Coil resistance
CL=180e-6;      % Coil inductance
FR=4e-12;        % Rotor dynamic friction
KTR=47e-3;      % Torsion bar constant
BEM=108e-6;       % Back electromotive force

sensDelay=100e-9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%open 'GalvoModel_servolike_v3_simpli';
%open 'GalvoModel_servolike_v3';

SIMU={  'GalvoModel_servolike_v3',...
        'GalvoModel_servolike_v3_PID'};


%spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RC.txt',',',1);
%spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RCL.txt',',',1);
%spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RCL2.txt',',',1);
% spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_RLC_abs.txt',',',1);
% freq=spiceOut.data(:,1);
% mag=10.^(spiceOut.data(:,2)/20);
% phase=spiceOut.data(:,3);
spiceOut=importdata('RT_projects/GalvoProjekt/spice_exports/OpAmp_LT1028_biased_currentsource_tf.txt',',',1);
freq=spiceOut.data(:,1);
re=spiceOut.data(:,2);
im=spiceOut.data(:,3);

cpx=re+1j*im;       % <------- import this as complex freq. function
fr_data=idfrd(cpx,freq,0);
set(fr_data,'FrequencyUnit','Hz')

estOpt=tfestOptions;
estOpt.SearchOption.MaxIter=200;
estOpt.Focus=[0 2e6*2*pi];

tfCC=tfest(fr_data,3,2,estOpt);
tfCC.Notes={    'estOpt=tfestOptions;',...
                'estOpt.SearchOption.MaxIter=200;'...
                'estOpt.Focus=[0 2e6*2*pi];',...
                '',...
                ' - Fit Frequency Range: 0...2e6*2*pi',...
                ' - LTSpice OpAmp_LT1028_biased_currentsource.asc',...
                ' - Freq. response estimation of current controller'};
            

f1=figure(1);
s1=subplot(211);
semilogx(freq, 20*log10(abs(cpx)))
grid on;
s2=subplot(212);
semilogx(freq, unwrap(angle(cpx))*180/pi)
grid on;

%-----------------------------------
% linmod aus Simulink 
%-----------------------------------
for k=1:2
    [num den]=linmod(SIMU{k})
    sys0=tf(num, den)
    [zs ps ks]=zpkdata(sys0) 
    sysz=zpk(zs,ps,ks)
    G0(k,:)=sysz;
end
    
    poles=sort(G0(1).p{:});
    poles=poles(1:end-1);
    zeros=G0(1).z{:}
    if isempty(zeros)
        zeros=[];
    end
    gaink=G0(1).k;
    
    G0(3,:)=zpk(zeros, poles, gaink)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=nyquistoptions;
P.ShowFullContour='off';
f(1)=figure(1);
f(2)=figure(2);

SUB=220;
tt=[0:0.01:5];

figure(f(1));
for k=1:4
    hs(1,k)=subplot(SUB+k);
end

figure(f(2));
for k=1:4
    hs(2,k)=subplot(SUB+k);
end

for k=1:2
    figure(f(k));
    rlocus(hs(k,1),G0(k),P);
    nyquist(hs(k,2),G0(k),P);
    pzmap(hs(k,3),G0(k),P);
    step(hs(k,4), G0(k));
end

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');


return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=220;
tt=[0:0.05:20];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplots erzeugen und handles in vektor ablegen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:4
    hs(i)=subplot(SUB+i);
end

lightGray=[1 1 1]*0.6;

clear m n rs phi hl dw


axes(hs(1));
rlocus(G0(1));
legend('G01')

axes(hs(2));
rlocus(Gtot(1));
legend('Gtot1')

% axes(hs(3));
% rlocus(G0(2));
% legend('G02')
% 
% axes(hs(4));
% rlocus(Gtot(2));
% legend('Gtot2')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
% asymptotenwinkel, xrange min/max  für alle G0's in 
% vektoren schreiben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a b]=size(G0);
Ntf=max(a,b);

for i=1:Ntf
    m(i)=length(G0(i).z{:});
    n(i)=length(G0(i).p{:});

    if m(i)==0 || n(i)==0
        break;
    end
    
    nrel(i)=n(i)-m(i);
    tmp=1/nrel(i)*( sum(real(G0(i).p{:}) )-( sum(real(G0(i).z{:})) ));
    dw(i)=eval(sym(1)*tmp);
    asym{i}=round( (2*[0:1:nrel(i)-1]+1)*pi/nrel(i)*180/pi);
    lo=min(min(min(real(G0(i).p{:}),dw(i))) , min(min(real(G0(i).z{:}),dw(i))) );
    up=max(max(max(real(G0(i).p{:}),dw(i))) , max(max(real(G0(i).z{:}),dw(i))) );
    xRan(i,:)=[lo up];
end

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
% asymptotenwinkel, xrange min/max  für alle G0's in 
% vektoren schreiben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a b]=size(G0);
Ntf=max(a,b);

for i=1:Ntf
    m(i)=length(G0(i).z{:});
    n(i)=length(G0(i).p{:});
    nrel(i)=n(i)-m(i);
    tmp=1/nrel(i)*( sum(real(G0(i).p{:}) )-( sum(real(G0(i).z{:})) ));
    dw(i)=eval(sym(1)*tmp);
    asym{i}=round( (2*[0:1:nrel(i)-1]+1)*pi/nrel(i)*180/pi);
    lo=min(min(min(real(G0(i).p{:}),dw(i))) , min(min(real(G0(i).z{:}),dw(i))) );
    up=max(max(max(real(G0(i).p{:}),dw(i))) , max(max(real(G0(i).z{:}),dw(i))) );
    xRan(i,:)=[lo up];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle subplots erzeugen und asymptoten einzeichenn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subc=1;
for pp=1:2
    
    subplot(hs(subc));

    for i=1:length(asym{pp})
        line([dw(pp) dw(pp)],[-0.5 0.5]);
        ha(i)=line([dw(pp) 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
       rotate(ha(i),[0 0 1],asym{pp}(i),[dw(pp) 0 0]);
    end
    hold all;
    
    rlocus(G0(pp));
%    legend('q1*p1');
    
    subplot(hs(subc+1));
    hold all;
    %pzmap(c1,'r');
    hold all;
    pzmap(G0(pp),'b');
    pzmap(feedback(G0(pp),1),'r');
    hold off;
%    legend('q1*p1')

    subplot(hs(subc+2));
    step(feedback(G0(pp),1),tt); grid on;
    
    subc=subc+3;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alle subplots formatieren
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yRan=[-10 10; -1.5 1.5; -10 10];
sel=[1 2; 4 5; 7 8];
for i=1:2
    set(hs(sel(i,:)),'XLimMode','manual','YLimMode','manual',...
        'XLim',xRan(i,:)*1.2,'YLim',yRan(i,:));
end



ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return;








