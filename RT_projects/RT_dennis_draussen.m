delete(findall(0,'type','line'))
delete(findall(0,'type','text'))

syms p Kp;
Gsym=Kp*0.4*(p^2-2*p+10)/(p+2)^3;
% ... Bei eingangssignal rampe soll stationäre Regelabweichung
% eInf=1/20 gelten
% ... stationäres verhalten, Systemty i...

expand((p+2)^3);
Kp=4;
G01=tf(Kp*0.4*[1 -2 10],[1 6 12 8]);
%G01=tf(Kp*0.4*[1],[1 6 12 8]);

Kp=1;
G00=tf(Kp*0.4*[1],[1 6 12 8]);

Kp=3;
G02=tf(Kp*0.4*[1 -2 10],[1 6 12 8]);
    
MODE=4;

if MODE==0


    P=nyquistoptions;
    P.showFullContour='off';

    f1=figure(1);
    clf;
    hold on;
    nyquist(G01,P)
    %nyquist(G00,P)
    nyquist(G02,P)
    hold off;
    legend('Kp=1','Kp=3')
    syms w

    gsw=subs(Gsym,p,j*w);

    gsw

    f2=figure(2);
    SUB=310;
    clf;
    Cs=tf([0.5 1],[2 1]);
    Cs2=tf([0.5 1],[0.25 1]);

    subplot(SUB+1);
    rlocus(G01)
    legend('G01')

    subplot(SUB+2);
    rlocus(G01*Cs)
    legend('G01*Cs')

    subplot(SUB+3);
    rlocus(G01*Cs2)
    legend('G01*Cs2')



    f3=figure(3);
    SUB=210;
    clf;

    hold all;
    step(zpk([],[-1/5 -1/3 -2],1/7.5))
    step(tf([1],[19 8.5 1]),'--')
    hold off;
    legend('Ps','Ps approx')

    delete(findall(0,'type','line'))

    Kp=1;
    G01=tf(Kp*[1],[0.5 1 0]);

    Kp1=1.5396;
    G02=tf(Kp1*[1],[0.5 1 0]);

    P=nyquistoptions;
    P.showFullContour='off';

    f4=figure(4);
    clf;
    hold on;
    nyquist(G01,P)
    nyquist(G02,P)
    hold off;
    legend(sprintf('Kp=%.4f',Kp1),'Kp=4')

    f5=figure(5);

    hold all;
    step(feedback(G01,1));
    step(feedback(G02,1));
    hold off;
    legend(sprintf('Kp=%.4f',Kp1),'Kp=4')

    f6=figure(6);

    Kp=0.37;
    Kp=1;
    G01=tf(Kp*[11 55],[1 14 33 0]);
    %G01=tf(Kp*[1],[1 3 0]);
    G01zpk=zpk([]);

    hold all;
    rlocus(G01);
    hold off;
    %legend(sprintf('Kp=%.4f',Kp1),'Kp=4')

    f7=figure(7);
    k=50;
    Ps=tf([1 5],[1 3])
    Cs=tf(k*[1],[1 0])
    Ms=tf(11,[1 11])

    step(feedback(Cs*Ps,Ms))
    
    MODE=1;
end

if MODE==1

    % ss aus simulink und ss2tf in matlab
    [A1 b1 ct1 d1]=linmod('RT_Klausur_2010');
    [num den]=ss2tf(A1,b1,ct1,d1);
    sysss1=tf(num,den);

    % ss von hand und sst2f in matlab
    A=[-2 1;-1 0];
    b=[-2;1];
    ct=[1 0];
    d=1;
    [num den]=ss2tf(A,b,ct,d);
    sysss=tf(num,den);

    % ss von hand und sst2f formel in matlab
    syms p;
    I=[1 0;0 1];
    gtotSym=ct*inv(p*I-A)*b+d;
    gtot=sym2tf(gtotSym);

    % ss von hand und sst2f von hand
    systf=tf([1 0 2],[1 2 1]);

    f8=figure(8);
    SUB=210;
    clf

    y1=step(sysss1,[0:0.05:10]);
    y2=step(sysss,[0:0.05:10]);
    y3=step(gtot,[0:0.05:10]);
    y4=step(systf,[0:0.05:10]);

    hold all;
    plot(y1,'LineWidth',3);
    plot(y2,'--','LineWidth',3);
    plot(y3);
    plot(y4,'--');

    hold off;
    grid on;   

    legend('ss2tf simulink','ss2tf mat','ss2tf mat formel','ss2tf von hand')
    
    MODE=2;
end

if MODE==2
    % ------------------------------------------------------------------
    % ------------ Nyquist konstruieren --------------------------------
    % ------------------------------------------------------------------
    % Wie zählen die argumente von komplexen polen/Nullstellen bei der 
    % Zerlegung des phasengangs arg(G0(jw))???
    % Klausur RT 2010 A2
    % ------------------------------------------------------------------
    syms p w;
    G0sym=0.4*(p^2-2*p+10)/(p+2)^3;
    G0iw=subs(G0sym,'p',i*w);
    G0=sym2tf(G0sym);
    
    [ps zs]=pzmap(G0);
    
    f9=figure(9);
    SUB=330;
    clf;
    
    s1=subplot(SUB+1);
    pzmap(G0)
    
    s2=subplot(SUB+2);
    P=nyquistoptions;
    P.showFullContour='off';
    nyquist(G0,P)

    s3=subplot(SUB+3);
    rlocus(G0)


    f10=figure(10);
    SUB=330;
    clf;
    wv=[0:0.1:20];
    
    argZ1=angle(i*wv-zs(1));
    argZ2=angle(i*wv-zs(2));
    argP1=angle(i*wv-ps(1));
    argP2=angle(i*wv-ps(2));
    argP3=angle(i*wv-ps(3));

    % Zähler argumente
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(SUB+1);
    hold all;
    plot(wv,unwrap(argZ1)*180/pi)
    hold off;
    grid on;
    legend(sprintf('arg( s%s )',addSign(-zs(1),'adjust')))

    subplot(SUB+2);
    hold all;
    plot(wv,unwrap(argZ2)*180/pi)
    hold off;
    grid on;
    legend(sprintf('arg( s%s )',addSign(-zs(2),'adjust')))

    subplot(SUB+3);
    hold all;
    plot(wv,( unwrap(argZ1)+unwrap(argZ2) )*180/pi)
    hold off;
    grid on;
    legend('arg(z1)+arg(z2)')

    % Nenner argumente
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(SUB+4);
    hold all;
    plot(wv,unwrap(argP1)*180/pi)
    hold off;
    grid on;
    legend(sprintf('arg( s%s )',addSign(-ps(1),'adjust')))

    subplot(SUB+5);
    hold all;
    plot(wv,3*unwrap(argP1)*180/pi)
    hold off;
    grid on;
    legend(sprintf('3*arg( s%s )',addSign(-ps(1),'adjust')))

    subplot(SUB+6);
    hold all;
    plot(wv,( unwrap(argP1)+unwrap(argP2)+unwrap(argP3) )*180/pi)
    hold off;
    grid on;
    legend('arg(p1)+arg(p2)+arg(p3)')
    
    % Zähler-Nenner argumente
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(3,3,[7 8]);
    hold all;
    plot(wv,( unwrap(argZ1)+unwrap(argZ2)-(unwrap(argP1)+unwrap(argP2)+unwrap(argP3)) )*180/pi)
    hold off;
    grid on;
    legend('arg(G0(s))')
    title('Winkelsumme Zaehler - Winkelsumme Nenner')
    
    subplot(SUB+9);
    P=nyquistoptions;
    P.showFullContour='off';
    nyquist(G0,P)

    xlim([-0.2 0.6]);
    ylim([-0.4 0.15]);
    
    MODE=3;

end

if MODE==3
    wv=[-20:0.1:20];
    
    f12=figure(12);
    SUB=210;
    clf;
    
    subplot(SUB+1);
    hold all;
    plot(wv,angle(i*wv-zs(1))*180/pi);
    plot(wv,angle(i*wv-zs(2))*180/pi);
    hold off;
    grid minor;
    legend('angle(i*wv-zs(1))','angle(i*wv-zs(2))')

    subplot(SUB+2);
    hold all;
    plot(wv,(angle(i*wv-zs(2))+angle(i*wv-zs(1)))*180/pi);
    plot(wv,unwrap(angle(i*wv-zs(2))+angle(i*wv-zs(1)))*180/pi);
    hold off;
    grid minor;
    legend('angle(i*wv-zs(1))','angle(i*wv-zs(2))')
end

if MODE==4
    wv=[-20:0.1:20];

    f13=figure(13);
    SUB=340;
    clf;

    tf1=zpk([1-3*j 1+3*j],[-2 -2 -2],1); 
    tf2=zpk([-1-3*j -1+3*j],[-2 -2 -2],1);
    tf3=zpk([-1.5 -1.5],[-2 -2 -2],1);
    tf4=zpk([1 1],[-2 -2 -2],1);
    
    G0s(1)=tf1;
    G0s(2)=tf2;
    G0s(3)=tf3;
    G0s(4)=tf4;
    
    clear zRE zIM pRE pIM zC izz izc zhc pC ipp ipc phc
    
    for i=1:length(G0s.z)
        zRE(i,:)=real(G0s.z{i});
        zIM(i,:)=imag(G0s.z{i});
        [zC(i,:) izz(i,:) izc(i,:)]=unique(G0s.z{i});
        if sum(abs(imag(G0s.z{i}))) == 0
            zhc(i,:)=histc(G0s.z{i},zC(i,:));
        else
            zhc(i,:)=histc(angle(G0s.z{i}),angle(zC(i,:)));
        end
    end
    
    for i=1:length(G0s.p)
        pRE(i,:)=real(G0s.p{i});
        pIM(i,:)=imag(G0s.p{i});
        [pC(i,:) ipp(i,:) ipc(i,:)]=unique(G0s.p{i});
        phc(i,:)=histc(G0s.p{i},pC(i,:));
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle pzmaps gleich skalieren, suche max und min für Re- und Im-Achse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    reAx=[min([min(zRE) min(pRE)]) max([max(zRE) max(pRE)])];
    imAx=[min([min(zIM) min(pIM)]) max([max(zIM) max(pIM)])];

    if (diff(reAx)==0 | diff(imAx)==0)
        if diff(reAx)==0
            reAx=[-1 1];
        else
            imAx=[-1 1];
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relativer systemgrad, systemtyp, Grenzübergänge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [a b]=size(G0s);
    
    for i=1:max(a,b)
        startPoint(i)=limit( subs(tf2sym(G0s(i)),'p','j*w') ,'hw',0);
        endPoint(i)=limit( subs(tf2sym(G0s(i)),'p','j*w') ,'w',1e6);
    end

    textPosY=abs(imAx(1)*1/10);
    
    for i=1:4
        subplot(SUB+i);
        hold on;
        ms=8;lw=2;
        plot(zRE(i,:),zIM(i,:),'ro','MarkerSize',ms,'LineWidth',lw);
        plot(pRE(i,:),pIM(i,:),'bx','MarkerSize',ms,'LineWidth',lw);
%        pzmap(G0s(i))
%        pzmap(feedback(G0s(i),1))
        hold off;
        xlim(reAx*1.2)
        ylim(imAx*1.2)
        grid on;
        gray1=[1 1 1]*hex2dec('63')/255;
        line(reAx*1.2,[0 0],'Color', gray1);
        line([0,0],imAx*1.2,'Color', gray1);
        
        for k=1:length(zC(i,:))
            if zhc(i,k)>1           % NS- ordnung erst bei grad größer 1
                text(zC(i,k),textPosY,sprintf('(%d)',zhc(i,k)),...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom')
            end
        end
        
        for k=1:length(pC(i,:))
            if phc(i,k)>1           % Polordnung erst bei grad größer 1
                text(pC(i,k),-textPosY,sprintf('(%d)',phc(i,k)),...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','top')
            end
        end
        
        
    end
    
    
    subplot(SUB+5);
    hn(1)=nyquistplot(G0s(1));
    legend('G0s(1)')

    subplot(SUB+6);
    hn(2)=nyquistplot(G0s(2));
    legend('G0s(2)')

    subplot(SUB+7);
    hn(3)=nyquistplot(G0s(3));
    legend('G0s(3)')
    
    subplot(SUB+8);
    hn(4)=nyquistplot(G0s(4));
    legend('G0s(4)')
    
    for i=1:length(hn)
        set(hn(i),'ShowFullContour','off');
    end
    
    for i=1:length(hn)
        subplot(3,4,8+i);
        rlocus(G0s(i))
    end
    

end

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

