% Processfile simulink modelle servo und servo_ctrl
% Übungsaufgabe RT 2013

% PI

delete(findall(0,'type','line'));

TXTBGCOLOR = [0 0 0];

syms p J psi rho R Kp w;
% Von hand berechneter ss
Ar2=[0 1; 0 -(psi^2+R*rho)/(R*J)];
br2=[0; psi/(J*R)];
cr2=[1;0]';

% tf des servos mit allen parametern als variable
plantSym=ss2sym(Ar2,br2,cr2,0);
% tf des Regelkreises mit allen parametern als variable
cLoopSym=(Kp*plantSym)/(1+Kp*plantSym);   
% tf der Kreisverstärkung mit allen parametern als variable
G0Sym=(Kp*plantSym);  

leadBr=tf([2.667 0.667],[2 1]);
sprintf('Lösung für Lead System von H. Brunner:');
leadBr
[p z]=pzmap(leadBr);
leadBrF=zpk(z,p,2*0.667,'DisplayFormat','frequency')
leadBrR=zpk(z,p,2*0.667,'DisplayFormat','roots')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

G0KpSym=subs(G0Sym,{'psi','J','R','rho'},{psi, J, R, rho});
cLoopKpSym=subs(cLoopSym,{'psi','J','R','rho'},{psi, J, R, rho})
plant=sym2tf(subs(plantSym, {'psi','J','R','rho'},{psi, J, R, rho}));


MODE=0;

if MODE==0
    
    % Kp ermitteln für Max 5% Overshoot
    y=[2];
    Kp=0.2;
    while max(y) > 1.05
        max(y);
        Kp=Kp-0.005;
        cLoop=sym2tf(subs(cLoopKpSym,'Kp',Kp));
        [y ~]=step(cLoop);    
    end
    Kp5=Kp

    % Kp ermitteln für Max 20% Overshoot
    y=[2];
    Kp=0.35;
    while max(y) > 1.2
        max(y);
        Kp=Kp-0.005;
        cLoop=sym2tf(subs(cLoopKpSym,'Kp',Kp));
        [y ~]=step(cLoop);    
    end
    Kp20=Kp
    
    sprintf('OS <= 0.05 für Kp=%f',Kp5)
    sprintf('OS <= 0.2 für Kp=%f',Kp20)
    cLoop5=sym2tf(subs(cLoopKpSym,'Kp',Kp5));
    cLoop20=sym2tf(subs(cLoopKpSym,'Kp',Kp20));
    G05=sym2tf(subs(G0KpSym,'Kp',Kp5));
    G020=sym2tf(subs(G0KpSym,'Kp',Kp20));
    
    n1=G020.num{1};
    d1=G020.den{1};
    
    G02N=tf(n1/d1(1),d1/d1(1))
    %%%%%%%%%%%%%%%%%%%%
    % figure 1
    %%%%%%%%%%%%%%%%%%%%
    f1=figure(1);
    SUB=120;
    
    %-------------
    % Step response
    %-------------
    tt=[0:0.05:50];
    subplot(SUB+1);
    hold all;
    step(feedback(Kp5*plant,1),tt);
    step(feedback(Kp20*plant,1),tt);
    step(feedback(Kp*plant*leadBr,1),tt);
    hold off;
    grid on;
    
    hleg=legend('cLoop_{5%}','cLoop_{20%}','fb(leadBr*Kp20*plant)');
    set(hleg,'FontSize',11)

    clear am pm wgm cmpx
    
    [am(1) pm(1) wgm(1) wpm(1)]=margin(G05);
    [am(2) pm(2) wgm(2) wpm(2)]=margin(G020);

    cmpx(1)=exp(j*(pm(1)*pi/180-pi));
    cmpx(2)=exp(j*(pm(2)*pi/180-pi));
    cmpx(3)=exp(j*(60*pi/180-pi));   % Ziel- Phasenreserve mit Lead


    P = nyquistoptions;
    P.ShowFullContour = 'off'; 

    r=1;              % radius
    rv=[-r:0.005:r];    % absciss vektor

    %-------------
    % nyquist
    %-------------
    subplot(SUB+2);

    hold all;
    nyquistplot(G05,P);
    nyquistplot(G020,P);
    nyquistplot(Kp20*plant*leadBr,P);
    plot(rv,sqrt(r-rv.^2),'--r');
    plot(rv,-sqrt(r-rv.^2),'--r');
    plot(real(cmpx),imag(cmpx),'o','MarkerSize',6,...
        'MarkerEdgeColor','Red','MarkerFaceColor','Red')
    plot(real(cmpx(end)),imag(cmpx(end)),'o','MarkerSize',6,...
        'MarkerEdgeColor','Red','MarkerFaceColor','Red')
    line([0 real(cmpx(end))],[0 imag(cmpx(end))],'color','red','linestyle','--')%,'LineWidth',3)
    hold off;
    line([-5 5],[-5 5],'color','green','linestyle','--')%,'LineWidth',3)
    
    axis([-1.5 0.5 -2 .5]);
    hleg=legend('G0_{5%}','G0_{20%}');
    set(hleg,'FontSize',11)

%    return;
    
    %%%%%%%%%%%%%%%%%%%%
    % figure 2
    %%%%%%%%%%%%%%%%%%%%
    if exist('f2')==1
        figure(f2);
        
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    clf('reset');
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    end
    
    f2=figure(2);
    SUB=120;
    
    w=logspace(-2,1,250);
    %-------------
    % Bode
    %-------------
    clear mag ph wout ind wdv;
    i=1;
    [mag(i,:) ph(i,:) wout(i,:)]=bode(G05,w); i=2;
    [mag(i,:) ph(i,:) wout(i,:)]=bode(G020,w);
    
    % wd bestimmen
    ind=find(mag(1,:) <= 1);
    wdv(1)=wout(1,ind(1));
    phv(1)=ph(1,ind(1));
    ind=find(mag(2,:) <= 1);
    wdv(2)=wout(2,ind(1));
    phv(2)=ph(2,ind(1));
    
    sprintf('wd5=%.3f \t phi5=%.1f\nwd20=%.3f \t phi20=%.1f',...
        wdv(1),phv(1),wdv(2),phv(2))
    
    subplot(SUB+1);

    hold all;
    bode(G05,w);
    bode(G020,w);
    bode(G020*leadBr,w);

    col=hex2dec(['20';'96';'20'])'/256;
    childrenHnd = get(f2, 'Children');
    axes(childrenHnd(3))    % Magnitude
    line([wdv(1) wdv(1)],[-270 50],'color','blue','linestyle','--');
    line([wdv(2) wdv(2)],[-270 50],'color',col,'linestyle','--');

    str1=sprintf('deltaW_d=%.3f',abs(wdv(1)-wdv(2)));
    text(1.1*wdv(2),10,str1,...
            'FontSize',11,...
            'HorizontalAlignment','left',... 
            'BackgroundColor',TXTBGCOLOR);    
    str1=sprintf('W_{d 5%%}=%.3f',wdv(1));
    text(0.9*wdv(1),-55,str1,...
            'FontSize',11,...
            'HorizontalAlignment','right',... 
            'BackgroundColor', TXTBGCOLOR);    
    str1=sprintf('W_{d 20%%}=%.3f',wdv(2));
    text(1.1*wdv(2),-55,str1,...
            'FontSize',11,...
            'HorizontalAlignment','left',... 
            'BackgroundColor',TXTBGCOLOR);    

    axes(childrenHnd(1))    % Phase
    line([wdv(1) wdv(1)],[-270 50],'color','blue','linestyle','--');
    line([wdv(2) wdv(2)],[-270 50],'color',col,'linestyle','--');
    
    str1=sprintf('phi_1 = %.0fdeg',phv(1));
    str2=sprintf('phi_2 = %.0fdeg',phv(2));
    text(1.1*wdv(1),phv(1),str1,...
            'FontSize',11,...
            'FontName','Helvetica',...
            'HorizontalAlignment','left',... 
            'BackgroundColor',TXTBGCOLOR);    
    text(1.1*wdv(2),phv(2),str2,...
            'FontSize',11,...
            'HorizontalAlignment','left',... 
            'BackgroundColor',TXTBGCOLOR);    
    
    hold off;
    hleg=legend('G0_{5}','G0_{20}','G0_{20}*leadBr');
    set(hleg,'FontSize',11)
    grid on;

    
    %-------------
    % Bode 2
    %-------------
    subplot(SUB+2);

    hold all;
    bode(G05/(1+G05));
    bode(G020/(1+G020));
    
    wd=1;
    
    childrenHnd = get(f2, 'Children');
    axes(childrenHnd(3))    % Magnitude
    line([wd wd],[-200 50],'color','red','linestyle','--');
    axes(childrenHnd(1))    % Phase
    line([wd wd],[-270 50],'color','red','linestyle','--');

    hold off;
    hleg=legend('G0_{5}/(1+G0_{5})','G0_{20}/(1+G0_{20})');
    set(hleg,'FontSize',11)
    grid on;    
    
    set(gcf,'WindowButtonDownFcn',...
        @drag_select_Callback);
    
end    

%%%%%%%%%%%%%%%%%%%%
% figure 3
%%%%%%%%%%%%%%%%%%%%
%-------------
% Step
%-------------
f3=figure(3);
SUB=220;
SUBV=[2 2];
subplot(SUB+1);

hold all;
step(G05/(1+G05));
hold off;
hleg=legend('G0_{5}/(1+G0_{5})');
set(hleg,'FontSize',11)
grid on;    
%-------------
% Bode
%-------------
subplot(SUBV(1),SUBV(2),[2 4]);
hold all;
bode(G05/(1+G05));
bode(G05);

childrenHnd = get(f3, 'Children');
axes(childrenHnd(3))    % Magnitude
line([wd wd],[-200 50],'color','red','linestyle','--');
axes(childrenHnd(1))    % Phase
line([wd wd],[-270 50],'color','red','linestyle','--');

hold off;
hleg=legend('G0_{5}/(1+G0_{5})','G0_{5}');
%    set(hleg,'FontSize',9,'FontName',')
grid on;     

  
%%%%%%%%%%%%%%%%%%%%
% figure 4
%%%%%%%%%%%%%%%%%%%%
f4=figure(4);
SUB=120;
subplot(SUB+1);

%-------------
% Bode
%-------------
hold all;
bode(Kp20*leadBr);
bode(Kp20*leadBrF);
bode(Kp20*leadBrR);

childrenHnd = get(f4, 'Children');
axes(childrenHnd(3))    % Magnitude
line([wd wd],[-200 50],'color','red','linestyle','--');
axes(childrenHnd(1))    % Phase
line([wd wd],[-270 50],'color','red','linestyle','--');

hold off;
hleg=legend('leadBr','leadBrF','leadBrR');
%    set(hleg,'FontSize',9,'FontName',')
grid on;    

%-------------
% nyquist
%-------------
subplot(SUB+2);

hold all;
nyquistplot(Kp20*leadBr,P);
nyquistplot(Kp20*leadBrF,P);
nyquistplot(Kp20*leadBrR,P);
% plot(rv,sqrt(r-rv.^2),'--r');
% plot(rv,-sqrt(r-rv.^2),'--r');
% plot(real(cmpx),imag(cmpx),'o','MarkerSize',6,...
%     'MarkerEdgeColor','Red','MarkerFaceColor','Red')
% plot(real(cmpx(end)),imag(cmpx(end)),'o','MarkerSize',6,...
%     'MarkerEdgeColor','Red','MarkerFaceColor','Red')
% %line([0 real(cmpx(end))],[0 imag(cmpx(end))],'color','red','linestyle','--')%,'LineWidth',3)
% hold off;
% line([-5 5],[-5 5],'color','green','linestyle','--')%,'LineWidth',3)
hold off;

%axis([-1.5 0.5 -2 .5]);
hleg=legend('leadBr','leadBrF','leadBrR');
set(hleg,'FontSize',11)
  
%%%%%%%%%%%%%%%%%%%%
% figure 5
%%%%%%%%%%%%%%%%%%%%
f5=figure(5);
delete(findall(f5,'type','line'))

SUB=110;

wdZiel=2;

%-------------
% Bode 
%-------------
%subplot(1,3,[1 2])
subplot(SUB+1)
% leadSym=Kl*(1+T*p)/(1+a*T*p));
% wn=1/T;       % untere Eckfrequenz
% wp=1/(a*T);   % obere Eckfrequenz
% mh=wp/wn;      % Verhältniss der Von oberer zu unterer Eckfrequenz
syms wn wp;

leadSym=(1+p/wn)/(1+p/wp);
%-------------------------------------------
% phiLead(wn) mit mh als Parameter Plotten
%-------------------------------------------

win=logspace(-1,1,50);

MH_RANGE=[1:0.1:2];

K=1;

clear lead mh ii;
i=0;
for mh=MH_RANGE      
    i=i+1;
    
% mh=wp/wn = 1/alpha
% Weil der phasenverlauf für unterschiedlichen mh als parameter
% geplottet werden sollen, wird w auf untere Eckfrequenz wn normiert, 
% also der Phasenverlauf als funktion von w/wn mit mh als parameter.
    wn=1;
    wp=mh*wn;   % also wp=mh für diesen parameterplott
% als Gain nicht 1 sonder mh angeben weil laut formel leadSyms nicht 
% direkt die Pole parametriert werden sondern die laplacevariable
% Durchmultiplizieren mit mh=wp/wn... und der Gain von lead(mh) ist immer 1
    lead(i)=zpk([-wn],[-wp],[1],'DisplayFormat','frequency');

    %    lead(mh)=sym2tf(subs(leadSym,{'wn','wp'},{1,mh}));
end
% wn ist bei Lead Glied die UNTERE Eckfrequenz weil beim lead die
% Nullstelle vor dem Pol erreicht wird, bezogen auf die w- Achse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mh=12;     % aus parameterplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daraus können wn und wp für entsprechendes lead glied für wdZiel
% berechnet werden.
wn=wdZiel/sqrt(mh);     % !!!!!!!!!
wp=wn*mh;
%
wn=0.1*round(wn*10);
wp=0.1*round(wp*10);
lead12=zpk([-wn],[-wp],[12],'DisplayFormat','frequency');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FINDSTR = int2str(mh);

clear wn wp mh;

win=logspace(-1,2,50);

phimax=ones(1,length(MH_RANGE))*NaN;

legStr=[];
hold all;
i=0;
for mh=MH_RANGE
    i=i+1;
    hf2bod=bodeplot(lead(i),win);
    [~,phimax(i)]=bode(lead(i),sqrt(mh));
    legStr=[legStr sprintf('m_h=%.2f:',mh)];
    drawnow
end

resp=get(get(hf2bod,'Responses'));
i=0;
for mh=MH_RANGE
    i=i+1;

    currCol=resp( i ).Style.Colors{:};

    line([sqrt(mh*1) sqrt(mh*1) ],[-1 phimax(i)],'Color',currCol,...
        'LineStyle','--','Tag',sprintf('sqrt(wn*wp)[mh=%.0f]',mh));
    plot(sqrt(mh*1),phimax(i),'Marker','o','MarkerSize',5,'MarkerEdgeColor',...
        currCol,'MarkerFaceColor',currCol);    
end

grid on;
hold off;
hleg=legend(strsplit(legStr,':'),'Location','NorthEastOutside');


ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');
