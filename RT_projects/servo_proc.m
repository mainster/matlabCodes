% Processfile simulink modelle servo und servo_ctrl
% Übungsaufgabe RT 2013

delete(findall(0,'type','line'));

J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

% Von hand berechneter ss
% Ar=[0 1; 0 -(R*rho+psi)/(R*J)];
% br=[0; 1/(R*J)]
Ar=[0 1; 0 -(R*rho+psi)/(J*R)];
br=[0; 1/(J*R)];
cr=[1;0]';
[num den]=ss2tf(Ar,br,cr,0);
plantr=tf(num,den);

Ar2=[0 1; 0 -(psi^2+R*rho)/(R*J)];
br2=[0; psi/(J*R)];
cr2=[1;0]';
[num den]=ss2tf(Ar2,br2,cr2,0);
plantr2=tf(num,den);

[A,b,c,d]=linmod('servo');
[num den]=ss2tf(A,b,c,0);
%plant=tf(round(num),den)
plant=tf(num,den);


f1=figure(1);
SUB=210;

subplot(SUB+1);
bode(plant);grid on;
title('Servo')

subplot(SUB+2);
pzmap(plant);
title('Servo')


% Regelkreis
%

Kp=1;
err=0;


[Al,bl,cl,dl]=linmod('servo_ctrl');
[numl denl]=ss2tf(Al,bl,cl,dl);
loop=tf(round(numl),denl);


f2=figure(2);
SUB=210;

subplot(SUB+1);
bode(loop);grid on;
title('Regelkreis')

subplot(SUB+2);
tend=30;
%pzmap(loop);
%title('Regelkreis')
hold all;

MODE=0;

if MODE==0
    % Kp ermitteln für Max 5% Overshoot
    y=[2];
    Kp=0.14;
    while max(y) > 1.05
        max(y);
        Kp=Kp-0.001;
        [Al,bl,cl,dl]=linmod('servo_ctrl');
        [numl denl]=ss2tf(Al,bl,cl,dl);
        loop=tf(numl,denl);
        [y ~]=step(loop,tend);    
    end
    Kp5=Kp;
    sprintf('OS <= 0.05 für Kp=%f',Kp5)

    % Kp ermitteln für Max 20% Overshoot
    y=[2];
    Kp=0.35;
    while max(y) > 1.2
        max(y);
        Kp=Kp-0.005;
        [Al,bl,cl,dl]=linmod('servo_ctrl');
        [numl denl]=ss2tf(Al,bl,cl,dl);
        loop=tf(numl,denl);
        [y ~]=step(loop,tend);    
    end
    Kp20=Kp
    sprintf('OS <= 0.2 für Kp=%f',Kp20)

    % Sprungantwort für beide Kps plotten
    Kps=[Kp5;Kp20];
    legstr=[];
    for i=1:2
        Kp=Kps(i);
        [Al,bl,cl,dl]=linmod('servo_ctrl');
        [numl denl]=ss2tf(Al,bl,cl,dl);
        loop=tf(numl,denl);
        step(loop,tend);
        legstr=[legstr sprintf('Kp=%.4f:',Kp)];
    end

    hold off;
    grid on;
    line([0 tend],[1.05 1.05],'color','red','linestyle','--','LineWidth',1)
    line([0 tend],[1.2 1.2],'color','red','linestyle','--','LineWidth',1)
    title('Regelkreis')
    legend(strsplit(legstr,':'));
    
    % Pollagen für untersch. Kps
    f3=figure(3);

    Kpv=linspace(0.1,0.5,9);
    Kpv(8)=Kp5;
    Kpv(9)=Kp20;
    SUB=330;
    legstr=[];
    for i=1:length(Kpv)
        Kp=Kpv(i);
        [numl denl]=linmod('servo_ctrl');
        loopv(i,:)=tf(numl,denl);    
        subplot(SUB+i);
        rlocus(loopv(i));
        legstr=[legstr sprintf('Kp=%.4f:',Kp)];
    end
end

% pzmap für untersch. Kps
f4=figure(4);
SUB=120;

subplot(SUB+1);
pzmap(loopv(1:end-2));
hold on;
pzmap(loopv(end-1),'*r');
pzmap(loopv(end),'g');
hold off

col=[hex2dec('A3') hex2dec('A3') hex2dec('A3')]/hex2dec('ff');
set(gca,'Color',col)

subplot(SUB+2);
hold all;

P = nyquistoptions;
P.ShowFullContour = 'off'; 
[r c]=size(loopv);
for i=1:r
    nyquist(loopv(i),P);
end
legend(strsplit(legstr,':'));
hold off;


    ar=sort(findall(0,'type','figure'));
    set(ar,'WindowStyle','docked');


return



% Verschoben in servo_2_proc.m


% Man bestimme den Einfluss der Dämpfungskonstanten rho auf das Einschwingverhalten
% des geregelten Systems und stelle die Ergebnisse graphisch dar. Weshalb ist
% das System relativ unempfindlich gegenüber Schwankungen/Änderungen von rho ?

% J=0.05;         % Trägheitsmoment Rotor
% psi=0.5;        % Flussverkettung
% rho=2e-4;       % Mech. Dämpfungskonstante
% R=10;           % R Spule

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

Kp=0.133;

[A,b,c,d]=linmod('servo_ctrl');
[num den]=ss2tf(A,b,c,0);
%plant=tf(round(num),den)
loopSim=tf(num,den);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear J psi rho R Kp;
syms p J psi rho R Kp;

Ar2=[0 1; 0 -(psi^2+R*rho)/(R*J)];
br2=[0; psi/(J*R)];
cr2=[1;0]';
plant=ss2sym(Ar2,br2,cr2,0);

% tf des servos mit rho als variable
plantRoh=subs(plant,[psi, J, R],[0.5, 0.05, 10]);  
% tf des regelkreises mit rho und Kp als variablen
loop=(Kp*plantRoh)/(1+Kp*plantRoh);   
% tf der Kreisverstärkung mit Kp und rho als variablen
G0=Kp*plantRoh;

Kp5=0.133;
Kp20=0.3050;        % Werte aus Zeile 78 bzw. 92

%return;

f5=figure(5);
hold all;
%rho=2e-4;       % Mech. Dämpfungskonstante

rohv=linspace(1e-5,1e-3,5);    % Vektor für schritte des Dämpfungsmaß
t1=[0:0.1:200];     % Zeit

os=[];
for i=1:length(rohv)
    for k=1:1
        loop1=sym2tf(subs(loop,[rho, Kp],...
            [Kp5, rohv(i)]));                   % Rückgekoppeltes System
        [Y,TT,X]=step(loop1,t1);                % Sprungantwort Rückgekoppeltes System
        plot(TT,Y);
        
        os(i,k)=100*(max(Y)-1.0);               % OS messen
        G01=sym2tf(subs(G0,[rho, Kp],...
            [Kp5, rohv(i)]));                   % Kreisverstärkung G0
        [am,pm]=margin(G01);
        phaseres(i,k)=pm;
    end
end



for i=1:length(D)
    for k=1:length(T)
        sys1=sym2tf(subs(plantRoh,'rho',0.33))
        [Y,TT,X]=step(sys1,tt);
        os(i,k)=100*(max(Y)-1.0);
        go=tf([1],[T(k)^2 2*T(k)*D(i) 0]);
        [am,pm]=margin(go);
        phaseres(i,k)=pm;
    end
end

cla;
ph=plotyy(D,os(:,1),D,phaseres(:,1));
hold all;
plot(D,os(:,1)+phaseres(:,1),'color','red');
plot(D([5:15]),os(5:15,1)+phaseres(5:15,1),'color','red','lineWidth',3);
axis(ph,[0.1 0.9 0 100]);
grid on;
hold off;
xlabel('Dämpfungsmaß D')
ylabel(ph(1),'Overshoot [%]')
ylabel(ph(2),'Phasenreserve[deg]')
legend('%os','%os+phiRes','phiRes');


line([0.3 0.3],[0 100],'color','black','linestyle','--','LineWidth',3)
line([0.8 0.8],[0 100],'color','black','linestyle','--','LineWidth',3)
line([0.3 0.8],[70 70],'color','red','linestyle','--','LineWidth',1)

text(0.3+abs(0.3-0.8)/2,85,'Quasi linearer Bereich',...
    'FontSize',14,...
    'HorizontalAlignment','center',... 
    'BackgroundColor',[.7 .9 .7]);    
text(0.3+abs(0.3-0.8)/2,75,'Faustformel: %OS+phiRes=70 %deg',...
    'FontSize',12,...
    'HorizontalAlignment','center',... 
    'BackgroundColor',[.7 .9 .7]);    






