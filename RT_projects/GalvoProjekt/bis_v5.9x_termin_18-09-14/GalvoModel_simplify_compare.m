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
syms(param{:});
syms(paramSimp{:,1});

for i=1:length(param);      
    eval([param{i} '=' Mod2{i}]); 
end;

for i=1:length(paramSimp);  
    eval([paramSimp{i,1} '=' paramSimp{i,2}]); 
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
open 'GalvoModel_servolike_v2';
open 'GalvoModel_servolike_v2_simpli';
open 'GalvoModel_servolike_v2_simpli_B';
open 'GalvoModel_servolike_v2_simpli_B2';

SIMU={  'GalvoModel_servolike_v2_simpli',...
        'GalvoModel_servolike_v2_simpli_B',...
        'GalvoModel_servolike_v2_simpli_B2',...
        'GalvoModel_servolike_v2'};

Cr(1,:)=zpk([-3000 -4000-j*5e3 -4000+j*5e3],[],1);
Cr(2,:)=zpk([-3000 -4000-j*5e3 -4000+j*5e3],[-500],1);

clear G0 Gtot
for i=1:4
    [num den]=linmod(SIMU{i});
    [z p k]=tf2zpk(num,den);
	G0(i,:)= zpk(z,p,k);
    Gtot(i,:)=feedback(G0(i,:),10);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=220;
tt=[0:0.01:5];

for i=1:2
   y0(i,:)=step(G0(i,:),tt); 
   yt(i,:)=step(Gtot(i,:),tt); 
end

for i=1:4
    hs(i)=subplot(SUB+i);
end

subplot(hs(1));
hold all;
plot(y0(1,:));
%plot(y0(2,:));grid on;
hold off;

subplot(hs(3));
hold all;
%plot(yt(1,:));
%plot(yt(2,:));grid on;
hold off;

subplot(hs(2));
hold all;
bode(G0(1)); 
bode(G0(2)); grid on;
hold off;

subplot(hs(4));
hold all;
bode(Gtot(1)); 
bode(Gtot(2)); grid on;
hold off;

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

axes(hs(3));
rlocus(G0(2));
legend('G02')

axes(hs(4));
rlocus(Gtot(2));
legend('Gtot2')


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








