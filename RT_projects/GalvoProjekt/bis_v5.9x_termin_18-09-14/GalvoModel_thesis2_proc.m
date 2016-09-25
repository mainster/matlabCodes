% GalvoModel_thesis2 proc
% Thesis PHD main, Michael Widlok
% S.26
%

delete(findall(0,'type','line'));

% Modell 6860
%
RIN=6e-8;    % Rotor inertia
TRC=9.3e-3;      % Torque constant
CR=1.5;        % Coil resistance
CL=160e-6;      % Coil inductance
FR=4e-6;        % Rotor dynamic friction
KTR=100e-3;      % Torsion bar constant
BEM=170e-6;       % Back electromotive force

[num1 den1]=linmod('GalvoModel_thesis_v2');
sys1=tf(num1, den1);

%%%%
% Parameter für Blockvereinfachung
%%%%
T1=CL/CR;
K1=TRC/CR;
T2=RIN/FR;
K2=1/FR;

[num1b den1b]=linmod('GalvoModel_thesis_v2_simpli');
sys1b=tf(num1b, den1b);
[z1b p1b k1b]=tf2zpk(sys1b.num{1},sys1b.den{1});

% other CamTech
%
RIN=1.25e-8;    % Rotor inertia
TRC=6.17e-3;      % Torque constant
CR=2.79;        % Coil resistance
CL=180e-6;      % Coil inductance
FR=4e-6;        % Rotor dynamic friction
KTR=47e-3;      % Torsion bar constant
BEM=108e-6;       % Back electromotive force


cr=zpk([-3000 -4000-j*5e3 -4000+j*5e3],[],1);
%cr=1;

G0(4)=zpk(z1b,p1b,k1b)*cr;


[num2 den2]=linmod('GalvoModel_thesis_v2');
sys2=tf(num2, den2);

[num3 den3]=linmod('GalvoPHD');
sys3=tf(num3, den3);
[z3 p3 k3]=tf2zpk(sys3.num{1},sys3.den{1});
G0(3)=zpk(z3,p3,k3)*cr;



[z p k]=tf2zpk(sys1.num{1},sys1.den{1});
G0(1)=zpk(z,p,k)*cr;
[z p k]=tf2zpk(sys2.num{1},sys2.den{1});
G0(2)=zpk(z,p,k)*cr;

max(G0(1).k,G0(2).k);
[r1 p1 k1]=residue(num1,den1);
[r2 p2 k2]=residue(num2,den2);

for i=1:4
    Gtot(i,:)=feedback(G0(i),10);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=130;

subplot(SUB+1);
hold on;
step(G0(1)); grid on;
step(G0(2)); grid on;
%step(G0(3)); grid on;
step(G0(4)); grid on;
hold off;
legend('sys1','sys2','Simpl')
subplot(SUB+2);
hold on;
bode(G0(1)); grid on;
bode(G0(2)); grid on;
bode(G0(3)); grid on;
bode(G0(4)); grid on;
hold off

legend('sys1','sys2','PHD','Simpl')

hold on
subplot(SUB+3);
pzmap(G0(1),G0(2),G0(3),G0(4)) 
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

axes(hs(2));
rlocus(G0(2));

axes(hs(3));
rlocus(G0(3));

axes(hs(4));
rlocus(G0(4));

legend('sys1','sys2','PHD','Simpl')

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








