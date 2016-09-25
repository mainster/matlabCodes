% Processfile simulink modelle servo und servo_ctrl
% Übungsaufgabe RT 2013

% Man bestimme den Einfluss der Dämpfungskonstanten rho auf das Einschwingverhalten
% des geregelten Systems und stelle die Ergebnisse graphisch dar. Weshalb ist
% das System relativ unempfindlich gegenüber Schwankungen/Änderungen von rho ?

delete(findall(0,'type','line'));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

[A,b,c,d]=linmod('servo');
[num den]=ss2tf(A,b,c,0);
plantSim=tf(num,den);

% As=[0 1; 0 -(psi^2+R*rho)/(R*J)];
% bs=[0; psi/(J*R)];
% cs=[1;0]';
% [nums dens]=ss2tf(As,bs,cs,0);
% plantSS=tf(nums, dens);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Kp5=0.133;
Kp20=0.3050;        % Werte aus Zeile 78 bzw. 92 servo_proc.m

Kp=Kp5;

[A,b,c,d]=linmod('servo_ctrl');
[num den]=ss2tf(A,b,c,0);
loopSim=tf(num,den);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

syms p J psi rho R Kp w;
% Von hand berechneter ss
Ar2=[0 1; 0 -(psi^2+R*rho)/(R*J)];
br2=[0; psi/(J*R)];
cr2=[1;0]';

% tf des servos mit allen parametern als variable
plantSym=ss2sym(Ar2,br2,cr2,0);
% tf des Regelkreises mit allen parametern als variable
loopSym=(Kp*plantSym)/(1+Kp*plantSym);   
% tf der Kreisverstärkung mit allen parametern als variable
G0Sym=(Kp*plantSym);   

%clear J psi rho R Kp;
clear J psi rho R;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

plant=sym2tf(subs(plantSym,{'psi','J','R','rho'},...
    {psi, J, R, rho}));
loop=sym2tf(subs(loopSym,{'psi','J','R','rho','Kp'},...
    {psi, J, R, rho, Kp5}));

loopRhoSym=subs(loopSym,{'psi','J','R','Kp'},...
    {psi, J, R, Kp20});
G0RhoSym=subs(G0Sym,{'psi','J','R','Kp'},...
    {psi, J, R, Kp20});

% f5=figure(5);
% 
% hold all;
% for i=1:10
%     step(sym2tf(subs(loopRhoSym,'rho',i*rho)))
% end
% hold off;

rhov=linspace(2e-5,2e-3,10);    % Vektor für schritte des Dämpfungsmaß
t1=[0:0.1:30];     % Zeit

os=[];
for i=1:length(rhov)
    loop1=sym2tf(subs(loopRhoSym,'rho',rhov(i)));   % Rückgekoppeltes System
    [Y,TT,X]=step(loop1,t1);                        % Sprungantwort Rückgekoppeltes System
    os(i)=100*(max(Y)-1.0);                         % OS messen
    pvCtrl(i,:)=pole(loop1);
    G01=sym2tf(subs(G0RhoSym,'rho',rhov(i)));       % Kreisverstärkung G0
    [am,pm]=margin(G01);
%    phaseres(i)=pm;
end


f6=figure(6);
SUB=110;

subplot(SUB+1);
[hx,hos,hpole]=plotyy(rhov,os,rhov,real(pvCtrl(:,1)'));
set(hpole,'Marker','x','MarkerSize',15,'MarkerEdgeColor','Red')
grid on;
legend('loop');
xlabel('Mech. Dämpfungskonstante rho')
ylabel(hx(1),'Overshoot [%]')
ylabel(hx(2),'Realteil der Pole')

po=poles(loopRhoSym,p);
TeXStrpp = texlabel(subs(po(1),'rho','p'));
TeXStrpm = texlabel(subs(po(2),'rho','p'));
yl=get(hx(1),'YLim');
xl=get(hx(1),'XLim');
text(xl(2)-(1/3*abs(xl(2)-xl(1))),yl(2)-(1/3*abs(yl(2)-yl(1))),...
    ['p1=' TeXStrpp],...
    'FontSize',14,...
    'HorizontalAlignment','center',... 
    'BackgroundColor',[.7 .9 .7]); 

% subplot(SUB+2);
% hold all;
% for i=1:max(length(pv),length(zv))
%     plot(real(pv(i)),imag(pv(i,:)),'X','MarkerSize',10);
%     if length(zv)>0
%         plot(real(zv(i)),imag(zv(i)),'o');
%     end
% end
% hold off;


% Man entwerfe ein zusätzliches Lead-Glied, sodass auch für die schnelle Regelung
% von Teilaufgabe 5.2 (20% OS) eine Phasenreserve von 60° resultiert. Man simuliere die
% Schrittantwort des resultierenden Systems.

f7=figure(7);
SUB=120;

G05=sym2tf(subs(G0Sym,{'psi','J','R','Kp','rho'},{psi,J,R,Kp5,rho}));
G020=sym2tf(subs(G0Sym,{'psi','J','R','Kp','rho'},{psi,J,R,Kp20,rho}));

[am(1) pm(1)]=margin(G05);
[am(2) pm(2)]=margin(G020);

cmpx(1)=exp(j*(pm(1)*pi/180-pi));
cmpx(2)=exp(j*(pm(2)*pi/180-pi));
cmpx(3)=exp(j*(60*pi/180-pi));   % Ziel- Phasenreserve mit Lead


P = nyquistoptions;
P.ShowFullContour = 'off'; 

%%%%%%%%%%%%%%
% Plot a Circle
%%%%%%%%%%%%%%
r=1;              % radius
rv=[-r:0.005:r];    % absciss vektor

subplot(SUB+1);

hold all;
nyquistplot(G05,P);
nyquistplot(G020,P);
plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(end)),imag(cmpx(end)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(end))],[0 imag(cmpx(end))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]);
hleg=legend('G0_{5%}','G0_{20%}');
set(hleg,'FontSize',14)

% wn für schnitt mit nyquist- frequenz berechnen
re1=real(subs(tf2sym(G020),'p',j*w));
im1=imag(subs(tf2sym(G020),'p',j*w));
wny=max( eval(solve(sqrt( re1^2+im1^2 )==1,w)) );

subplot(SUB+2);
hold all;
bode(G05);
bode(G020);
plot(wny,-180+pm,'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
hold off
grid on;
hleg=legend('G0_{5%}','G0_{20%}');
set(hleg,'FontSize',14)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lead glied um phasenreserve trotz 20% OS auf 60° zurückdrehen
cLoop20=sym2tf(subs(Kp*plantSym/(1+Kp*plantSym) ,...
    {'psi','J','R','Kp','rho'},...
    {psi, J, R, Kp20, rho}));

[mag phase w]=bode(cLoop20,logspace(-2,2,1000));
[val ind]=max(mag);
sprintf('max Amplitude: abs( cLoop20(j*%.3f) ) = %.3f dB',w(ind),20*log10(val))

ampl_wny=20*log10( abs(eval(subs(tf2sym(G020),'p',j*wny))) );
sprintf('wny Amplitude: abs( G020(j*%.3f) ) = %.3f dB',wny,ampl_wny)
presL=60-pm(2);
sprintf('Zusätzliche Phasenreserve: presL = 60°-%.1f° = %.1f°',pm(2),presL)



syms Kl T2 alpha;
leadSym=Kl*(1+T2*p)/(1+alpha*T2*p);




syms alpha1 wp1 wn1
sol1=solve(atan( sqrt(wp1/wn1)*(1-alpha1)/(1+wp1*alpha1/wn1) )==0.5*18*pi/180,alpha1);
%%%%%%%%%%%%%%%%
wn=0.5;
%%%%%%%%%%%%%%%%
sub1=subs(sol1,'wp1',wny^2/wn1);
% Für phi_max=18° bei sqrt(wp*wn)=wny muss alpha=
alpha_calc=eval(subs(sub1,'wn1',wn))
%%%%%%%%%%%%%%%%
wp=wny^2/wn;
alpha=alpha_calc;

cLoop20=sym2tf(subs(Kp*plantSym/(1+Kp*plantSym) ,...
    {'psi','J','R','Kp','rho'},...
    {psi, J, R, Kp20, rho}));

Kl=1;
for i=1:10
    cLoopL(i)=sym2tf(subs(leadSym*Kp*plantSym/(1+leadSym*Kp*plantSym) ,...
        {'psi','J','R','Kp','rho','Kl','T2','alpha'},...
        {psi, J, R, Kp20, rho, Kl*i, 1/wn, alpha}));
    G0L(i)=sym2tf(subs(leadSym*Kp*plantSym,...
        {'psi','J','R','Kp','rho','Kl','T2','alpha'},...
        {psi, J, R, Kp20, rho, Kl*i, 1/wn, alpha}));
    lead(i)=sym2tf(subs(leadSym,{'Kl','T2','alpha'},{Kl*i, 1/wn, alpha}));

end





%%%%%%%%%% Plot lead Zwichenrein%%%%%%%%%%%
%%%%  mh methode statt alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 88 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f88=figure(88);
SUB=120;
subplot(SUB+1);

syms wpMH wnMH;
leadSymMH=Kl*(1+p/wnMH)/(1+p/wpMH);

mhMH=1.3;
wnMH=0.397;
wpMH=mhMH*wnMH;

%wdMH=0.453;
wdMH=0.422;

G020LeadMH=sym2tf(subs(leadSymMH*Kp*plantSym,...
    {'psi','J','R','Kp','rho','Kl','wpMH','wnMH'},...
    {psi, J, R, Kp20, rho, 5, wpMH, wnMH}));

sprintf('Lead Glied:    wd=%.3f    mh=%.3f    wn=%.3f    wp=%.3f    alpha=%.3f    Kp=%.3f=%.2fdB    Kp*mh=Kp/alpha=%.3f=%.2fdB',wdMH,mhMH,wnMH,wpMH,1/mhMH,Kp20,20*log10(Kp20),Kp20*mhMH,20*log10(Kp20*mhMH))

[amMH(1) pmMH(1)]=margin(G05);
[amMH(2) pmMH(2)]=margin(G020);
[amMH(3) pmMH(3)]=margin(G020LeadMH);

cmpxMH(1)=exp(j*(pmMH(1)*pi/180-pi));
cmpxMH(2)=exp(j*(pmMH(2)*pi/180-pi));
cmpxMH(3)=exp(j*(pmMH(3)*pi/180-pi));
cmpxMH(4)=exp(j*(60*pi/180-pi));   % Ziel- Phasenreserve mit Lead


P = nyquistoptions;
P.ShowFullContour = 'off';

%%%%%%%%%%%%%%
% Plot a Circle
%%%%%%%%%%%%%%
r=1;              % radius
rv=[-r:0.005:r];    % absciss vektor

subplot(SUB+1);

hold all;
nyquistplot(G05,P);
nyquistplot(G020,P);
nyquistplot(G020LeadMH,P);
plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpxMH),imag(cmpxMH),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpxMH(end)),imag(cmpxMH(end)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpxMH(end))],[0 imag(cmpxMH(end))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;

axis([-1.5 0.5 -2 .5]);
hleg=legend('G0_{5%}','G0_{20%}','G0_{20% LEAD m_h}');
set(hleg,'FontSize',14)


subplot(SUB+2);
hold all;
step(feedback(G05,1));
step(feedback(G020,1));
step(feedback(G020LeadMH,1));

hold off;
hleg=legend('G0_{5%}','G0_{20%}','G0_{20% LEAD m_h}');
grid on;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 89 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f89=figure(89);
SUB=110;
subplot(SUB+1);

hold all;
bodeplot(G05);
bode(G020);
bode(G020LeadMH);
%plot(wny,-180+pm,'o','MarkerSize',4,...
%    'MarkerEdgeColor','Red','MarkerFaceColor','Red')

hTexts=findall(f89,'type','text');
inc{1}=strfind(get(hTexts(:),'String'),'Magnitude');        % indexiere Childes vom type 'axes'
inc{1}=strfind(get(hTexts(:),'String'),'Phase');        % indexiere Childes vom type 'axes'
ind(1)=find(~cellfun(@isempty,inc{1}));            % take all children handles of all axes handle into structure
ind(2)=find(~cellfun(@isempty,inc{1}));            % take all children handles of all axes handle into structure
% 
% AtextParent=get(hTexts(:),'Parent')';
% textParent=get(hTexts(ind),'Parent')';


childHkk = get(f89, 'Children');
axes(childHkk(1));    % Magnitude
line([wdMH wdMH],[-150 100],'color','red','linestyle','--');
axes(childHkk(3));    % Phase
line([wdMH wdMH],[-270 50],'color','red','linestyle','--');


hold off
grid on;
hleg=legend('G0_{5%}','G0_{20%}','G0_{20% LEAD m_h}');
set(hleg,'FontSize',14)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 90 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f90=figure(90);
SUB=110;
subplot(SUB+1);

wran2={1e-2,2e0};

hold all;
bodeplot(feedback(G05,1),wran2);
bodeplot(feedback(G020,1),wran2);
bodeplot(feedback(G020LeadMH,1),wran2);
%plot(wny,-180+pm,'o','MarkerSize',4,...
%    'MarkerEdgeColor','Red','MarkerFaceColor','Red')

childHkk2 = get(f90, 'Children');
axes(childHkk2(1));    % Magnitude
line([wdMH wdMH],[-150 100],'color','red','linestyle','--');
axes(childHkk2(3));    % Phase
line([wdMH wdMH],[-270 50],'color','red','linestyle','--');


hold off
grid on;
hleg=legend('fb(G0_{5%})','fb(G0_{20%})','fb(G0_{20% LEAD m_h})');
set(hleg,'FontSize',14)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 91 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f91=figure(91);
SUB=110;
subplot(SUB+1);

wran2={1e-2,1e1};

hold all;
bodeplot(G020LeadMH,wran2);
bodeplot(feedback(G020LeadMH,1),wran2);
%plot(wny,-180+pm,'o','MarkerSize',4,...
%    'MarkerEdgeColor','Red','MarkerFaceColor','Red')

childHkks2 = get(f91, 'Children');
axes(childHkks2(1));    % Magnitude
line([wdMH wdMH],[-150 100],'color','red','linestyle','--');
axes(childHkks2(3));    % Phase
line([wdMH wdMH],[-270 50],'color','red','linestyle','--');


hold off
grid on;
hleg=legend('G0_{20% LEAD m_h}','fb(G0_{20% LEAD m_h})');
set(hleg,'FontSize',14)





%%%%%%%% Plot lead %%%%%%%%%%%
f8=figure(8);
SUB=120;
subplot(SUB+1);
hold all;
bode(G020);

bode(G0L(1));

bode(cLoop20);
%bode(cLoopL);


%plot(wny,-180+pm,'o','MarkerSize',4,...
%    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
hold off
grid on;
hleg=legend('G0_{20%}','G0_{lead}','cLoop_{20%}','cLoop_{lead}');
set(hleg,'FontSize',11)

subplot(SUB+2);
bode(lead(1));
grid on;
hleg=legend('Lead');
set(hleg,'FontSize',11)


%%%%%%%% Plot sys %%%%%%%%%%%
f9=figure(9);
SUB=230;
subplot(SUB+1);

hold all;
step(cLoop20);
step(cLoopL(1));

hold off;
grid on;
legend('cLoop20','cLoopLead');

%%%%%%%%%%
% bode
%%%%%%%%%%
subplot(2,3,[2 5]);
hold all;
wrange={1e-2,1e1};
%bode(cLoop20);
%bode(cLoopL);
bode(G020,wrange);


bode(G0L(1),wrange);


%plot(wny,-180+pm,'o','MarkerSize',4,...
%    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
hold off
grid on;
%hleg=legend('cLoop_{20%}','cLoop_{20% Lead}','G0_{20%}','G0_{lead}');
hleg=legend('G0_{20%}','G0_{lead}');
set(hleg,'FontSize',11)

subplot(2,3,[2 5]+1);
hold all;
bode(cLoop20,wrange);
bode(cLoopL(1),wrange);
%bode(G020);
%bode(G0L);
%plot(wny,-180+pm,'o','MarkerSize',4,...
%    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
hold off
grid on;
hleg=legend('cLoop_{20%}','cLoop_{20% Lead}');
set(hleg,'FontSize',11)

%%%%%%%%%%
% nyquist
%%%%%%%%%%
subplot(SUB+4);
hold all;
nyquistplot(G020,P);
nyquistplot(G0L(1),P);
plot(rv,sqrt(r-rv.^2),'--r');
plot(rv,-sqrt(r-rv.^2),'--r');
plot(real(cmpx),imag(cmpx),'o','MarkerSize',4,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
plot(real(cmpx(end)),imag(cmpx(end)),'o','MarkerSize',6,...
    'MarkerEdgeColor','Red','MarkerFaceColor','Red')
line([0 real(cmpx(end))],[0 imag(cmpx(end))],'color','red','linestyle','--')%,'LineWidth',3)
hold off;
axis([-1.5 0.5 -2 .5]);
hleg=legend('G0_{20%}','G0_{lead}');
set(hleg,'FontSize',11)

%%%%%%%%%%%%%%%%%%%%%
f10=figure(10);
hold all;
for i=1:10
    step(cLoopL(i));
    [amv(i) pmv(i)]=margin(G0L(i));
end
hold off;
pmv

f11=figure(11);
subplot(121);
hold all;
for i=1:10
    nyquist(lead(i),P);
end
hold off;

subplot(122);
hold all;
for i=1:10
    nyquist(G0L(i),P);
end
axis([-8 0.5 -15 1]);
hold off;

t1 = timer;
set(t1,'ExecutionMode','SingleShot','Period',10, 'StartDelay',1);
t1.StartFcn = {@my_callback_fcn, 'My start message'};
t1.StopFcn = {@my_callback_fcn, 'My stop message'};
t1.TimerFcn = @(x,y)disp('Hello World!');

start(t1);
    
return


