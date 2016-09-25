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

% V3 mit PID und tfCC

delete(findall(0,'type','line'));

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
elseif find( ~cellfun(@exist, param(:)))

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
clear tfGv 
for i=1:1
    [num den]=linmod(SIMU{i});
    [z p k]=tf2zpk(num,den);
	tfGv(i,:)= zpk(z,p,k);
end

% ---------------------------------------------------------------
% ----- Estimate tf of current controller, simulated by LTSpice
% ---------------------------------------------------------------
tfCC=idSpice(   'galvoscanner/OpAmp_LT1028_biased_currentsource.raw',...
                'I(Shunt2)',[0 2e6],0);
            
%-------------------------------
%---  PID tuning
%-------------------------------
opts = pidtuneOptions('PhaseMargin',40);
[tfCTRL,info] = pidtune(( tfCC*tfGv ),'pid',opts);

opts = pidtuneOptions('PhaseMargin',40);
[tfCTRL_f,info] = pidtune(( tfCC*tfGv ),'pidf',opts);

opts = pidtuneOptions('PhaseMargin',40);
C0 = pidstd(1,1,1); 
[tfCTRL_s,info] = pidtune(( tfCC*tfGv ),C0,opts);

%-------------------------------
%---  loop gain
%-------------------------------
G0(1,:)=tfCTRL*tfCC*tfGv;
G0(2,:)=tfCTRL_f*tfCC*tfGv;
G0(3,:)=tfCTRL_s*tfCC*tfGv;

%-------------------------------
%---  random testsignal
%-------------------------------
% aa=ones(1,200);
y=[];
% for k=1:15
%     y=[y k*aa];
% end
y=-0.5+rand(1,20);

y2=[];
for k=1:20
    y2=[y2 ones(1,500)*y(k)];
end

uw=y2*2;
%-------------------------------
% ts=load('lsimGUI.mat');
% tt=linspace(0,ts.savedsimsamples*ts.savedStepLength, ts.savedsimsamples);

%tfCC=tf(1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);

marg=[0.03 0.03];
hs(1)=subtightplot(2,2,1,marg);
hs(2)=subtightplot(2,2,2,marg);
hs(3)=subtightplot(2,2,3:4,marg);

P=nyquistoptions;
P.ShowFullContour='off';
P.XLim=[-5 10];
P.YLim=[-5 2];

subplot(hs(1));
hold all;
for k=1:3
    hny(k)=nyquistplot(hs(1), G0(k), P); 
end
hold off;
legend(hs(1),'tfCTRL','tfCTRL_f','tfCTRL_s');
textVisible(f1,'nyquist','off');


subplot(hs(2));
hold all;
for k=1:3
    hb(k)=bodeplot(feedback(G0(k),1),logspace(3,7,5e3));
end
% setoptions(hb,'MagLowerLimMode','manual','MagLowerLim',-100)
% setoptions(hb,'PhaseWrapping','off')
% for k=1:3
%     setoptions(hb(k),op);
%     op=getoptions(hb(1));
%     op.YLim{1}=[-100 10];
% end
textVisible(f1,'bode','off');
grid on;
%bode(Gtot(2)); grid on;
hold off;
legend(hs(2),'tfCTRL','tfCTRL_f','tfCTRL_s');


subplot(hs(3));
hold off;
clear ysim;
%[ysim tsim]=lsim(feedback(G0,[1 1 1]),uw,linspace(0,100e-3,length(uw)));
for k=1:3
    [ysim(k,:) tsim]=lsim(feedback(G0(k),1),uw,linspace(0,100e-3,length(uw)));
end
%ysim=ysim';

plot(tsim,uw,'Color',[1 1 1]*0.4,'Linestyle','--')
hold all;
plot(tsim,ysim(1,:),'r-','linewidth',2)
plot(tsim,ysim(2,:),'g--','linewidth',1)
plot(tsim,ysim(3,:),'b-.','linewidth',1)
legend(hs(3),'u(t)','tfCTRL','tfCTRL_f','tfCTRL_s')
grid on;
hold off;
%ylim(hs(3),[-1.1 1.1]);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%% Figure 2 %%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------
%---  PID tuning
%-------------------------------

C0 = pidstd(1,1,1); 
opts = pidtuneOptions('PhaseMargin',35);
[tfCTRL_s,info] = pidtune(( tfCC*tfGv ),C0,opts);

save('Cselfs','tfCTRL_s','-append');

%-------------------------------
%---  loop gain
%-------------------------------
% tfCTRL_s.Kp = 786.725;
% tfCTRL_s.Ti = 0.0034211;
% tfCTRL_s.Td = 0.00018308;
% 
% tfCTRL_s.Kp = 261.5663;
% tfCTRL_s.Ti = 0.0024414;
% tfCTRL_s.Td = 0.00061036;
% 37.4%
% 35deg @ 1.84e4 rad
clear G0;

for k=1:5
%   tfCTRL_s.Kp=tfCTRL_s.Kp-k*20/10;
    opts = pidtuneOptions('PhaseMargin',30);
    [tfCTRL_s,info] = pidtune(( tfCC*tfGv ),C0,1.84e4*(1+(k-1)/5),opts);
    wd(:,k)=1.84e4*(1+(k-1)/5);
%    [tfCTRL_s,info] = pidtune(( tfCC*tfGv ),C0,opts);
    G0(k,:)=tfCTRL_s*tfCC*tfGv;
end


%////////////////////////////////////////////////////////
%///////    Console output of margins
%////////////////////////////////////////////////////////
marg=arrayfun(@allmargin, G0);
ma1=struct2cell(marg(:));
Tres=(cell2mat(ma1(3,:))*pi/180)./(cell2mat(ma1(4,:)))

trc(2,:)=ma1(3,:);
trc(3,:)=num2cell(Tres*1e6);
trc(4,:)=num2cell(wd);

trc(1,1:3)={'phir', 'Tres/us', 'wd/rad'};
trc(1,4:end)={' '};
dashL=sprintf('%.1f\t%.2f\t  %.0f\n',trc{2:4,end});
dash(1:length(dashL)-5)='-';
[   sprintf('%s\t%s\t  %s\n%s\n',trc{1,1:3},dash),...
    sprintf('%.1f\t%.2f\t  %.0f\n',trc{2:4,:})]
%////////////////////////////////////////////////////////


f2=figure(2);

marg=[0.03 0.03];
hs2(1)=subtightplot(2,6,1:2,marg);
hs2(2)=subtightplot(2,6,3:4,marg);
hs2(3)=subtightplot(2,6,5:6,marg);
hs2(4)=subtightplot(2,6,7:9,marg);
hs2(5)=subtightplot(2,6,10:12,marg);

P=nyquistoptions;
P.ShowFullContour='off';
P.XLim=[-5 10];
P.YLim=[-5 2];

legStr={'tfCTRL','tfCTRL_f','tfCTRL_s'};
for k=1:3
    hny2(k)=nyquistplot(hs2(k), G0(k), P); 
    legend(legStr(k));
%    rlocus(G0(k));
    grid off;
end
%textVisible(f2,'nyquist','off');


%save('Cselfs','tfCTRL','-append');
% G0=Cself*tfCC*tfGv;
% G0=CcpxZero*tfCC*tfGv;


subplot(hs2(4));
hold off;
clear ysim;

%load('Cselfs','tfCTRL_2D_top2','gv.GpD_top2')
gv=load('Cselfs');
G0D=gv.tfCTRL_2D_lala3*gv.GpD_lala3;

[lengG0 ~]=size(G0);
%for k=1:lengG0
for k=1:1
%    [ysim(k,:) tsim]=lsim(feedback(G0(k),1),uw,linspace(0,100e-3,length(uw)));
    [ysim(k,:) tsim]=lsim(feedback(G0D,1),uw);%linspace(0,100e-3,length(uw)));
end

plot(tsim,uw,'Color',[1 1 1]*0.4,'Linestyle','--')
hold all;
%for k=1:lengG0
 for k=1:1
    plot(tsim,ysim(k,:),'linewidth',1);
end
legend(hs(3),'u(t)','gv.tfCTRL','gv.tfCTRL_f','gv.tfCTRL_s')
grid on;
hold off;


%////////////////////////////////////////////////////////
%///////    resonanzfrequenz über sprungantwort messen
%////////////////////////////////////////////////////////
[yst ty]=step(feedback(G0(1,:),1),linspace(0,1e-3,1000)); 
G0(1,:)
stat=dcgain(feedback(G0(1,:),1));

fi(1)=find(yst >= stat, 1);
fi(2)=find(yst(fi(1)+1:end) <= stat, 1);
fi(2)=sum(fi(1:2));
fi(3)=find(yst(fi(2)+1:end) >= stat, 1);
fi(3)=sum(fi(2:3));
fi(4)=find(yst(fi(3)+1:end) <= stat, 1);
fi(4)=sum(fi(3:4));

subplot(hs2(5));
hold all;
plot(ty,yst);
plot(ty(fi),stat*ones(1,length(fi)),'rX','MarkerEdgeColor','r',...
                'MarkerFaceColor', 'k', 'MarkerSize',10,...
                'LineWidth',2);
plot(ty([1,end]), stat*ones(1,2),'r--')   
grid on;
hold off;
legend('DCgain','gv.tfCTRL_s * gv.gv.Gp');

per=[];
xy=[];
for k=1:1:length(fi)-1
    per=[per; (abs( diff(ty(fi(k:k+1))) ))];
    xy=[xy; sum(ty(fi(k:k+1)))/2, 0.7*stat];
    text(xy(k,1),xy(k,2), sprintf('%.2f us',per(k)*1e6 ),...
                'BackgroundColor',[.95 .95 .95],'EdgeColor',[0 0 0],...
                'HorizontalAlignment','center');
	if length(per)==3
        text(ty(fi(3)),0.55*stat, sprintf('T_{peri}= %.0f us',sum(per(2:3))*1e6 ),...
                    'BackgroundColor',[.8 .9 .7],'EdgeColor',[0 0 0],...
                    'HorizontalAlignment','center');
        text(ty(fi(3)),0.4*stat, sprintf('f_r = %.3f kHz',sum(per(2:3))^(-1)*1e-3 ),...
                    'BackgroundColor',[.8 .9 .7],'EdgeColor',[0 0 0],...
                    'HorizontalAlignment','center');
    end
end

text(ty(end/2),0.25*stat, sprintf('In "Mann/ Schiffelgen/ Froriep" S.290 wird als\n Fausformel fuer die Abtastrate ca. 0.1*T_{peri} angegeben'),...
            'BackgroundColor',[.8 .9 .7],'EdgeColor',[0 0 0],...
            'HorizontalAlignment','center');
                
[ps zs]=pzmap(G0(1,:));
imag(ps)/(2*pi);
%////////////////////////////////////////////////////////
return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%% Figure 2 %%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f2=figure(2);
% SUB=220;
% tt=[0:0.05:20];
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % subplots erzeugen und handles in vektor ablegen
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:4
%     hs(i)=subplot(SUB+i);
% end
% 
% lightGray=[1 1 1]*0.6;
% 
% clear m n rs phi hl dw
% 
% 
% axes(hs(1));
% rlocus(G0(1));
% legend('G01')
% 
% axes(hs(2));
% rlocus(Gtot(1));
% legend('Gtot1')
% 
% axes(hs(3));
% rlocus(G0(2));
% legend('G02')
% 
% axes(hs(4));
% rlocus(Gtot(2));
% legend('Gtot2')
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
% % asymptotenwinkel, xrange min/max  für alle G0's in 
% % vektoren schreiben
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [a b]=size(G0);
% Ntf=max(a,b);
% 
% for i=1:Ntf
%     m(i)=length(G0(i).z{:});
%     n(i)=length(G0(i).p{:});
% 
%     if m(i)==0 || n(i)==0
%         break;
%     end
%     
%     nrel(i)=n(i)-m(i);
%     tmp=1/nrel(i)*( sum(real(G0(i).p{:}) )-( sum(real(G0(i).z{:})) ));
%     dw(i)=eval(sym(1)*tmp);
%     asym{i}=round( (2*[0:1:nrel(i)-1]+1)*pi/nrel(i)*180/pi);
%     lo=min(min(min(real(G0(i).p{:}),dw(i))) , min(min(real(G0(i).z{:}),dw(i))) );
%     up=max(max(max(real(G0(i).p{:}),dw(i))) , max(max(real(G0(i).z{:}),dw(i))) );
%     xRan(i,:)=[lo up];
% end
% 
% ar=sort(findall(0,'type','figure'));
% set(ar,'WindowStyle','docked');
% return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
% % asymptotenwinkel, xrange min/max  für alle G0's in 
% % vektoren schreiben
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [a b]=size(G0);
% Ntf=max(a,b);
% 
% for i=1:Ntf
%     m(i)=length(G0(i).z{:});
%     n(i)=length(G0(i).p{:});
%     nrel(i)=n(i)-m(i);
%     tmp=1/nrel(i)*( sum(real(G0(i).p{:}) )-( sum(real(G0(i).z{:})) ));
%     dw(i)=eval(sym(1)*tmp);
%     asym{i}=round( (2*[0:1:nrel(i)-1]+1)*pi/nrel(i)*180/pi);
%     lo=min(min(min(real(G0(i).p{:}),dw(i))) , min(min(real(G0(i).z{:}),dw(i))) );
%     up=max(max(max(real(G0(i).p{:}),dw(i))) , max(max(real(G0(i).z{:}),dw(i))) );
%     xRan(i,:)=[lo up];
% end
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Alle subplots erzeugen und asymptoten einzeichenn
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subc=1;
% for pp=1:2
%     
%     subplot(hs(subc));
% 
%     for i=1:length(asym{pp})
%         line([dw(pp) dw(pp)],[-0.5 0.5]);
%         ha(i)=line([dw(pp) 10],[0 0],'LineStyle','-.',...
%             'Color',lightGray,'LineWidth',0.2);
%        rotate(ha(i),[0 0 1],asym{pp}(i),[dw(pp) 0 0]);
%     end
%     hold all;
%     
%     rlocus(G0(pp));
% %    legend('q1*p1');
%     
%     subplot(hs(subc+1));
%     hold all;
%     %pzmap(c1,'r');
%     hold all;
%     pzmap(G0(pp),'b');
%     pzmap(feedback(G0(pp),1),'r');
%     hold off;
% %    legend('q1*p1')
% 
%     subplot(hs(subc+2));
%     step(feedback(G0(pp),1),tt); grid on;
%     
%     subc=subc+3;
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % alle subplots formatieren
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yRan=[-10 10; -1.5 1.5; -10 10];
% sel=[1 2; 4 5; 7 8];
% for i=1:2
%     set(hs(sel(i,:)),'XLimMode','manual','YLimMode','manual',...
%         'XLim',xRan(i,:)*1.2,'YLim',yRan(i,:));
% end
% 
% 
% 
% ar=sort(findall(0,'type','figure'));
% set(ar,'WindowStyle','docked');
% 
% return;








