% Processfile simulink modelle servo und servo_ctrl
% Übungsaufgabe RT 2013

% Lead glied versuch 3

delete(findall(0,'type','line'));

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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

G0KpSym=subs(G0Sym,{'psi','J','R','rho'},{psi, J, R, rho});
cLoopKpSym=subs(cLoopSym,{'psi','J','R','rho'},{psi, J, R, rho})

MODE=0;

if MODE==0
    
    % Kp ermitteln für Max 30% Overshoot
    y=[2];
    Kp=0.55;
    while max(y) > 1.3
        max(y);
        Kp=Kp-0.005;
        cLoop=sym2tf(subs(cLoopKpSym,'Kp',Kp));
        [y ~]=step(cLoop);    
    end
    Kp30=Kp

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
    
    sprintf('OS <= 0.3 für Kp=%f',Kp30)
    sprintf('OS <= 0.2 für Kp=%f',Kp20)
    
%    MODE=1;


cLoop1=sym2tf(subs(cLoopKpSym,'Kp',1));
cLoop20=sym2tf(subs(cLoopKpSym,'Kp',Kp20));
cLoop30=sym2tf(subs(cLoopKpSym,'Kp',Kp30));
G01=sym2tf(subs(G0KpSym,'Kp',1));
G020=sym2tf(subs(G0KpSym,'Kp',Kp20));
G030=sym2tf(subs(G0KpSym,'Kp',Kp30));

f1=figure(1);
SUB=110;
subplot(SUB+1);
hold all;
step(cLoop20);
step(cLoop30);
hold off;
grid on;
hleg=legend('cLoop_{20%}','cLoop_{30%}');
set(hleg,'FontSize',11)

[am(1) pm(1)]=margin(G020);
[am(2) pm(2)]=margin(G030);

[mag0(1,:) phase0(1,:) wout0(1,:)]=bode(G020);
[mag0(2,:) phase0(2,:) wout0(2,:)]=bode(G030);
[magL(1,:) phaseL(1,:) woutL(1,:)]=bode(cLoop20);
[magL(2,:) phaseL(2,:) woutL(2,:)]=bode(cLoop30);

f2=figure(2);
SUB=120;

pv=[max(mag0(1,:)), 20*log10(max(mag0(1,:))),...
    max(mag0(2,:)), 20*log10(max(mag0(2,:))),...
    max(magL(1,:)), 20*log10(max(magL(1,:))),...
    max(magL(2,:)), 20*log10(max(magL(2,:)))];

% sprintf('max(|mag(G020)|) = %.3f = %.3f dB \n',...
%         'max(|mag(G030)|) = %.3f = %.3f dB \n',...
%         'max(|mag(cLoop20)|) = %.3f = %.3f dB \n',...
%         'max(|mag(cLoop30)|) = %.3f = %.3f dB ',1,2,3,4,5,6,7,8)
sprintf('max(|mag(G020)|) \t= %.3f = %.3f dB \nmax(|mag(G030)|) \t= %.3f = %.3f dB\nmax(|mag(cLoop20)|) \t= %.3f = %.3f dB \nmax(|mag(cLoop30)|) \t= %.3f = %.3f dB ',pv)
dPhiRes20=60-pm(1);
sprintf('pmargin(G020) = %.2f°\npmargin(G030) = %.2f°\ndPhiRes20=60°-%.2f°=%.2f°',pm(1),pm(2),pm(1),dPhiRes20)    

% wn für schnitt mit nyquist- frequenz berechnen
re1=real(subs(tf2sym(G020),'p',j*w));
im1=imag(subs(tf2sym(G020),'p',j*w));
wny=max( eval(solve(sqrt( re1^2+im1^2 )==1,w)) );

subplot(SUB+1);
hold all;
bode(G020);
bode(G030);
hold off;
grid on;
hleg=legend('G0_{20%}','G0_{30%}');
set(hleg,'FontSize',11)

subplot(SUB+2);
hold all;
bode(cLoop20);
bode(cLoop30);
hold off;
grid on;
hleg=legend('cLoop_{20%}','cLoop_{30%}');
set(hleg,'FontSize',11)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lead glied um phasenreserve trotz 20% OS auf 60° zurückdrehen
syms Kl T2 alpha;
leadSym=Kl*(1+T2*p)/(1+alpha*T2*p);

syms alpha1 wp1 wn1
sol1=solve(atan( sqrt(wp1/wn1)*(1-alpha1)/(1+wp1*alpha1/wn1) )==dPhiRes20*pi/180,alpha1);
%%%%%%%%%%%%%%%%
wn=0.1;
%%%%%%%%%%%%%%%%
sub1=subs(sol1,'wp1',wny^2/wn1);
% Für phi_max=18° bei sqrt(wp*wn)=wny muss alpha=
alpha_calc=eval(subs(sub1,'wn1',wn))
%%%%%%%%%%%%%%%%
wp=wny^2/wn;
alpha=alpha_calc;

Kl=0.0;
for i=1:10
    Kl=i/50;
    lead(i)=sym2tf(subs(leadSym,{'Kl','T2','alpha'},{Kl, 1/wn, alpha}));
end

%%%%%%%%%%%%%%%%%%%%%
P = nyquistoptions;
P.ShowFullContour = 'off'; 

f3=figure(3);
hold all;
for i=1:10
    step(G01*lead(i)/(1+G01*lead(i)));
end
hold off;

f4=figure(4);
SUB=120;
subplot(SUB+1);
hold all;
for i=1:10
    nyquist(lead(i),P);
end
hold off;

% suche Kl für pmargin=60°
subplot(SUB+2);
hold all;
for i=1:10
    nyquist(G01*lead(i),P);
    [amKl(i,:) pmKl(i,:)]=margin(G01*lead(i));
    if round(pmKl(i))==60
        Kl60=i/50;
        indKl60=i
        lead60Sym=subs(leadSym,{'Kl','alpha'},{Kl60, alpha});
    end
end
axis([-2 0.2 -2 0.2]);
hold off;

pmKl

Kl60

f5=figure(5);
SUB=110;
subplot(SUB+1);
hold all;
for i=1:10
    bode(G01*lead(i)/(1+G01*lead(i)));
end
hold off;
grid on;
hleg=legend('G0_{20%}*lead(Kl)');
set(hleg,'FontSize',11)

% als funktion von wn
%%%%%%%%%%%%%%%%
Kl=Kl60;
%%%%%%%%%%%%%%%%
sub1=subs(sol1,'wp1',wny^2/wn1);
% Für phi_max=18° bei sqrt(wp*wn)=wny muss alpha=

wn=1;
tt=[0:0.05:100];
clear Y TT;
for i=1:30
    wn=wn+i*0.1;
    alpha_calc=eval(subs(sub1,'wn1',wn));

    wp=wny^2/wn;
    alpha=alpha_calc;

 %   leadWn(i)=sym2tf(subs(leadSym,{'Kl','T2','alpha'},{Kl, 1/wn, alpha}));
    leadWn(i)=sym2tf(subs(lead60Sym,{'T2'},{1/wn}));
    [Y(:,i) TT(:,i)]=step(G01*leadWn(i)/(1+G01*leadWn(i)),tt);
    
    max(Y(:,i));
    
    if max(Y(:,i)) >= 1.2
        wn20=wn
        lead6020Sym=subs(lead60Sym,{'T2'},{wn20});
        ind=i
        break;
    end
end

if ~exist('lead6020')
    sprintf('Itteration für 60° und 20% OS nicht erfolgreich!!!');
    ind=i;
else
    lead6020=sym2tf(lead6020Sym);
end

f6=figure(6);
SUB=110;
subplot(SUB+1);
hold all;
for i=1:5:ind
    bode(G01*leadWn(i)/(1+G01*leadWn(i)));
end
hold off;
grid on;
hleg=legend('G0_{20%}*leadWn(Wn)');
set(hleg,'FontSize',11)


%%%%%%%%%%%%%%%%%%%%
% figure 7
%%%%%%%%%%%%%%%%%%%%
f7=figure(7);
delete(findall(f7,'type','line'))

SUB=110;

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

win=logspace(-1,2,50);

clear lead mh;
for mh10=2:18
    lead(mh10)=sym2tf(subs(leadSym,{'wn','wp'},{1,mh10/10}));
end

legStr=[];


win=logspace(-1,2,50);

MH_RANGE=[4:18];
phimax=ones(1,MH_RANGE(end))*NaN;

hold all;
for mh10=MH_RANGE
    hf2bod=bodeplot(lead(mh10),win);
    [~,phimax(mh10)]=bode(lead(mh10),sqrt(mh10));
    legStr=[legStr sprintf('m_h=%.2f:',mh10/10)];
    drawnow
end

resp=get(get(hf2bod,'Responses'));
for mh10=MH_RANGE
    currCol=resp( mh10-abs(diff([MH_RANGE(end),length(MH_RANGE)])) ).Style.Colors{:};

    line([sqrt(mh10*1) sqrt(mh10*1) ],[-1 phimax(mh10)],'Color',currCol,...
        'LineStyle','--','Tag',sprintf('sqrt(wn*wp)[mh=%.0f]',mh10));
    plot(sqrt(mh10*1),phimax(mh10),'Marker','o','MarkerSize',5,'MarkerEdgeColor',...
        currCol,'MarkerFaceColor',currCol);    
end

grid on;
hold off;

legend(strsplit(legStr,':'));



ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return






