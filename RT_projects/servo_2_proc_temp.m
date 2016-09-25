f100=figure(100);

delete(findall(f100,'type','line'));

syms wpMH wnMH;
leadSymMH=Kl*(1+p/wnMH)/(1+p/wpMH);

wdMH=0.453;
mhMH=1.3;
wnMH=wdMH/sqrt(mhMH);
wpMH=mhMH*wnMH;

SUB=120;
subplot(SUB+1);

clear Kl;
syms Kl;
G020LeadMHklsym=subs(leadSymMH*Kp*plantSym,...
   {'psi','J','R','Kp','rho'},...
   {psi, J, R, 1, rho});

%sprintf('Lead Glied:    wd=%.3f    mh=%.3f    wn=%.3f    wp=%.3f    alpha=%.3f    Kp=%.3f=%.2fdB    Kp*mh=Kp/alpha=%.3f=%.2fdB',wdMH,mhMH,wnMH,wpMH,1/mhMH,Kp20,20*log10(Kp20),Kp20*mhMH,20*log10(Kp20*mhMH))

%G020L=sym2tf(subs(leadSymMH*Kp*plantSym,{'psi','J','R','Kp','rho','wpMH','wnMH','Kl'},{psi, J, R, 1, rho, wpMH, wnMH,1}));

%num=G020L.num{1};
%den=G020L.den{1};

MODE=1;

if MODE==0
    
    hold on;
    strf=[];
    for i=1:20
        wdMH=0.453;
        mhMH=1+0.25*i;
        wnMH=wdMH/sqrt(mhMH);
        wpMH=mhMH*wnMH;    
    %    G020LeadMH=tf(0.025*i*num,den);
    %    zpk(G020LeadMH)
        G020LeadMH=sym2tf(subs(G020LeadMHklsym,...
        {'Kl','wnMH','wpMH'},{0.305,wnMH,wpMH}));

        [am(i) pm(i)]=margin(G020LeadMH);
        [av pv]=bode(feedback(G020LeadMH,1));
        bodmax=max(av);
        strf=[strf sprintf('pm=%.4f \t am=%.4f \t bodmax=%.2f=%.2fdB\n',pm(i),am(i),bodmax,20*log10(bodmax))];
     %   bode(G020LeadMH);
        grid on;
    end

    i=2;
    G020LeadMH=tf(0.1*i*num,den);
    %bode(G020LeadMH);
    bode(feedback(G020LeadMH,1));
    bode(feedback(G020,1));
    grid on;

    [am(i) pm(i)]=margin(G020LeadMH);
    [av pv]=bode(feedback(G020LeadMH,1));
    bodmax=max(av);
    strf=[strf sprintf('\nund jetzt:\npm=%.4f \t am=%.4f \t bodmax=%.2f=%.2fdB\n',pm(i),am(i),bodmax,20*log10(bodmax))];


    hold off;
        sprintf(strf)
end

wdMH=0.453;
mhMH=1.3;
wnMH=wdMH/sqrt(mhMH);
wpMH=mhMH*wnMH;

bodmax=1;
Kl=0.1;
dKlIt=0.1;

wdMH=0.453;
dmh=0.25;

win=logspace(-2,1,100);

%xRng=[2:20];
%mhRng=xRng*dmh;
mh=1.3;
dmhIt=0.1;
hold all;
clear av pv maxav phires avMaxv pm;

%[av pv]=bode(feedback(G020LeadMH,1),win);

%avMaxv(h,inRel)=max(squeeze(av));
        
for h=1:10
%    for i=xRng
    for inRel=1:20
%        inRel=2-(xRng(1)-1);
%        inRel=inRel+1;
        mhMHIt=mh+dmhIt*inRel;
        wnMH=wdMH/sqrt(mhMH);
        wpMH=mhMH*wnMH;    

        G020LeadMH=sym2tf(subs(G020LeadMHklsym,...
        {'Kl','wnMH','wpMH'},{KlIt,wnMH,wpMH}));

        [am pm]=margin(G020LeadMH);
        [av pv]=bode(feedback(G020LeadMH,1),win);

        avMaxv(h,inRel)=max(squeeze(av));
        phires(h,inRel)=pm
        
        if phires(h,inRel)<45
            break
        end;
    end
    break;
    KlIt=Kl+h*dKlIt;
end    
hold off;

%subplot(SUB+2);
%semilogx(win,20*log10(av([1 4],:)))
subplot(SUB+1);
ph=plotyy(mhRng,avMaxv(1,:),mhRng,phires(1,:));
grid on;

subplot(SUB+2);
ph=plotyy(mhRng,avMaxv(:,:),mhRng,phires(:,:));
grid on;

xlabel('mh');
ylabel(ph(1),'max(magnitude)');
ylabel(ph(2),'phi_{res}');
    
    
    