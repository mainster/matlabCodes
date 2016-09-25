% RT Klausurvorbereitung
% Klausur SS2011 A4

delete(findall(0,'type','line'))
clf

qs=tf(10,[1 20]);
ps=tf(1,[1 1 0]);

Ps=zpk([],[0 -1 -20],10);

Kr=1;
cs1=Kr;
cs2=zpk([-7],[],Kr);
cs3=zpk([-1],[-1/3],Kr);

MODE=3;

if MODE==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=330;
tt=[0:0.05:20];

subplot(SUB+1);
rlocus(cs1*Ps)
legend('cs1')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+2);
pzmap(cs1*Ps)
legend('cs1*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+3);
step(feedback(cs1*qs*ps,1),tt); grid on;

subplot(SUB+4);
rlocus(cs2*Ps)
legend('cs2*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+5);
pzmap(cs2*Ps)
legend('cs2*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+6);
step(feedback(cs2*qs*ps,1),tt); grid on;

subplot(SUB+7);
rlocus(cs3*Ps)
legend('cs3*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+8);
pzmap(cs3*Ps)
legend('cs3*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+9);
step(feedback(cs3*Ps,1),tt); grid on;

MODE=2;
end

if MODE==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
S=[4,3];
tt=[0:0.05:20];

Kr=1;
cs2v(1)=zpk([-3],[],Kr);
cs2v(2)=zpk([-5],[],Kr);
cs2v(3)=zpk([-7],[],Kr);
cs2v(4)=zpk([-9],[],Kr);

k=1;
for i=1:4
    subplot(S(1),S(2),k); k=k+1;
    rlocus(cs2v(i)*qs*ps)
    xlabel(''); ylabel(''); title('');

    %    legend(sprintf('cs2v(%i)',i));
    xlim([-30 5])
    ylim([-10 10])

    subplot(S(1),S(2),k); k=k+1;
    pzmap(cs2v(i)*qs*ps)
    xlabel(''); ylabel(''); title('');
    xlim([-30 5])
    ylim([-10 10])

    subplot(S(1),S(2),k); k=k+1;
    step(feedback(cs2v(i)*qs*ps,1),tt); grid on;
    xlabel(''); ylabel(''); title('');
    legend(sprintf('cs2v(%i)*qs*ps',i));

end
    MODE=3;

end


if MODE==3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 3 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
SUB=230;
% SS2012 A3
clear c1 q1 p1;
tt=[0:0.05:20];

lightGray=[1 1 1]*0.7;

%c1=tf([-3],[-3])
c1=zpk([-1],[-1],3);
c2=zpk([-4],[-11],6);
q1=zpk([],[-20],10);
p1=zpk([],[0 -1],1);

g01=c1*q1*p1;
g02=c2*q1*p1;
G0(1)=g01;
G0(2)=g02;
Cv(1)=c1;
Cv(2)=c2;

pq1=q1*p1;

clear m n rs phi hl
m=length(pq1.z{:})
n=length(pq1.p{:})
rs=1/(m-n)*(sum(real(pq1.z{:}))-sum(real(pq1.p{:})));
phi=round( (2*[0:1:n-m-1]+1)*pi/(n-m)*180/pi);

%rs2=1/(m-n)*(sum( abs(real(g01.p{:})) ) - sum( abs(real(g01.z{:}))) )

subplot(SUB+1);;

for i=1:length(phi)
    lh(i)=line([rs 10],[0 0],'LineStyle','-.',...
        'Color',lightGray,'LineWidth',0.2);
    rotate(lh(i),[0 0 1],phi(i),[rs 0 0]);
end
hold all;

rlocus(q1*p1);
legend('q1*p1');
xlim([-22 3]);
ylim([-10 10]);


subplot(SUB+2);
hold all;
%pzmap(c1,'r');
pzmap(q1*p1,'b');
legend('q1*p1')
xlim([-22 3])
ylim([-10 10])

subplot(SUB+3);
step(feedback(q1*p1,1),tt); grid on;

subplot(SUB+4);

for l=1:2
    clear m n rs phi hl
    m=length(g01.z{:});
    n=length(g01.p{:});
    rs=1/(m-n)*(sum(real(G0(l).z{:}))-sum(real(G0(l).p{:})));
    phi=round( (2*[0:1:n-m-1]+1)*pi/(n-m)*180/pi);

    for i=1:length(phi)
        lh(i)=line([rs 10],[0 0],'LineStyle','-.',...
            'Color',lightGray-(l-1)*.25,'LineWidth',0.2);
        rotate(lh(i),[0 0 1],phi(i),[rs 0 0]);
    end
end

hold all;
rlocus(G0(2))
hold off;
title('c2*q1*p1')

xlim([-22 3])
ylim([-10 10])

su5=subplot(SUB+5);
su6=subplot(SUB+6);

col=[[1 0 0],[0 1 0],[0 0 1]];
for l=1:2
    subplot(su5);
    hold all;
    pzmap(Cv(l),'r');
    pzmap(q1*p1,'b');
    hold off;
    legend('cx','q1*p1')
    xlim([-22 3])
    ylim([-10 10])

    subplot(su6);
    hold all;
    step(feedback(G0(l),1),tt); grid on;
    hold off;
end
legend('c1*q1*p1','c2*q1*p1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 4 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f4=figure(4);
SUB=230;
% SS2012 A3

tt=[0:0.05:20];

rl(1)=q1*p1;
rl(2)=feedback(q1*p1,1);

for z=1:2
    clear m n rs phi hl
    m=length(pq1.z{:})
    n=length(pq1.p{:})
    rs=1/(m-n)*(sum(real(pq1.z{:}))-sum(real(pq1.p{:})));
    phi=round( (2*[0:1:n-m-1]+1)*pi/(n-m)*180/pi);

    subplot(SUB+z);

    for i=1:length(phi)
        lh(i)=line([rs 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
        rotate(lh(i),[0 0 1],phi(i),[rs 0 0]);
    end
    hold all;

    rlocus(rl(z));
    xlim([-22 3]);
    ylim([-10 10]);
end


rl0(1)=G0(2);
rl0(2)=feedback(G0(2),1);

for z=1:2
    clear m n rs phi hl
    m=length(pq1.z{:})
    n=length(pq1.p{:})
    rs=1/(m-n)*(sum(real(pq1.z{:}))-sum(real(pq1.p{:})));
    phi=round( (2*[0:1:n-m-1]+1)*pi/(n-m)*180/pi);

    subplot(SUB+z+3);

    for i=1:length(phi)
        lh(i)=line([rs 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
        rotate(lh(i),[0 0 1],phi(i),[rs 0 0]);
    end
    hold all;

    rlocus(rl0(z));
    xlim([-22 3]);
    ylim([-10 10]);
end



end

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');
return 







% RT Klausurvorbereitung
% Klausur SS2011 A4

delete(findall(0,'type','line'))
clf

qs=tf(1,[0.05 1]);
ps=tf(1,[1 1 0]);

Kr=1;
cs1=Kr;
cs2=zpk([-3-j*6 -3+j*6],[-10],Kr);
cs3=zpk([-1.1-j*3 -1.1+j*3],[-5],Kr);

MODE=3;

if MODE==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=330;
tt=[0:0.05:20];

subplot(SUB+1);
rlocus(cs1*qs*ps)
legend('cs1')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+2);
pzmap(cs1*qs*ps)
legend('cs1*qs*ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+3);
step(feedback(cs1*qs*ps,1),tt); grid on;

subplot(SUB+4);
rlocus(cs2*qs*ps)
legend('cs2')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+5);
pzmap(cs2*qs*ps)
legend('cs2*qs*ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+6);
step(feedback(cs2*qs*ps,1),tt); grid on;

subplot(SUB+7);
rlocus(cs3*qs*ps)
legend('cs3')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+8);
pzmap(cs3*qs*ps)
legend('cs3*qs*ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+9);
step(feedback(cs3*qs*ps,1),tt); grid on;

MODE=2;
end

if MODE==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=320;

subplot(SUB+1);
rlocus(feedback(cs1*qs*ps,1))
legend('cs1'); title('feedback')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+3);
rlocus(feedback(cs2*qs*ps,1))
legend('cs2'); title('feedback')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+5);
rlocus(feedback(cs3*qs*ps,1))
legend('cs3'); title('feedback')
xlim([-30 5])
ylim([-10 10])

MODE=3;
end

if MODE==3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 3 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
SUB=220;

ClosedLoop=0;
[num den]=linmod('RT_ss2011_A4');
g0Simu=tf(num,den);

P=nyquistoptions;
P.ShowFullContour='off';

subplot(SUB+1);
step(feedback(g0Simu,1))
legend('fb(g0Simu)'); 
grid on;

subplot(SUB+2);
pzmap(g0Simu)
legend('g0Simu'); 
xlim([-30 5])
ylim([-10 10])

subplot(SUB+3);
nyquist(g0Simu,P)
legend('g0Simu'); 
xlim([-20 5])
ylim([-20 5])

subplot(SUB+4);
rlocus(g0Simu)
legend('g0Simu'); 
xlim([-22 5])
ylim([-10 10])

MODE=3;
end

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');


return 
% RT Klausurvorbereitung
% Klausur SS2011 A3 woking

delete(findall(0,'type','line'))
clf

syms kr Tn
ps=tf(1,[5 11 2]);
psApp=tf(0.5,[5.5 1]);

kr=1;
Tn=5;
cs=tf(kr*[Tn 1],[Tn 0]);

clear hn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=320;

subplot(SUB+1);
hold all;
step(ps);
step(psApp);
hold off;
grid on;
legend('ps','psApp')

subplot(SUB+2);
hold all;
pzmap(ps);
pzmap(cs);
hold off;
legend('ps','cs')

g0=cs*ps;

subplot(SUB+3);
hold all;
pzmap(g0);
hold off;
legend('cs*ps')

[r p k]=residue(g0.num{1},g0.den{1});

ps=pole(g0);
[zs gain]=zero(g0);

g0Zpk=zpk(zs,ps,gain);
g0Sh=zpk([],[0 -2],1/5);

subplot(SUB+4);
hold all;
step(feedback(g0,1));
step(feedback(g0Zpk,1));
step(feedback(g0Sh,1));
hold off;
legend('fb(g0)','fb(g0Zpk)','fb(g0Sh)')


subplot(3,2,[3 5]);
hold all;
hn(1)=nyquistplot(g0Sh*28.3);
legend('g0Sh, Kr=28.3')

for i=1:length(hn)
%    set(hn(i),'ShowFullContour','off');
    hn(i).ShowFullContour='off';
    hop=getoptions(hn(i));
    hop.XLim=[-2 0.5];
    hop.YLim=[-2 0.5];
    setoptions(hn(i),hop);
end

clear hn

subplot(3,2,[4 6]);

g0ShDel=g0Sh;
set(g0ShDel,'InputDelay',0.1);

hold all;
hn(1)=nyquistplot(g0Sh*28.3);
hn(2)=nyquistplot(g0ShDel*28.3);
legend('g0Sh','g0ShDel')

for i=1:length(hn)
    hn(i).ShowFullContour='off';
    hop=getoptions(hn(i));
    hop.XLim=[-2 0.5];
    hop.YLim=[-2 0.5];
    setoptions(hn(i),hop);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=220;

subplot(SUB+1);
hold all;
step(feedback(g0Sh,1))
step(feedback(g0ShDel,1))
hold off;
grid on;
legend('fb(g0Sh)','fb(g0ShDel)')


ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');


return







% RT Klausurvorbereitung
% Klausur SS2011 A1 woking

delete(findall(0,'type','line'))
clf

k=1;

g1=tf(k,[1 0]);
g2=feedback(k*g1,1);
g3=feedback(k*g1*g1,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=240;

clear ps zs;

subplot(SUB+1);
rlocus(g1-g2+g3)
legend('g1-g2+g3')

subplot(SUB+2);
rlocus(g1-g2)
legend('g1-g2')

subplot(SUB+3);
rlocus(g1+g3)
legend('g1+g3')

syms p

REzero=-0.6;
REpole=-0.05;

gsym=k*((p-REzero+j*0.66)*(p-REzero-j*0.66))/(p*(p-REpole+j)*(p-REpole-j)*(p+1));
gtry1=sym2tf(gsym);
subplot(SUB+1);
rlocus(gtry1)
legend('gtry')

clear a b ps zs

[a b]=pzmap(gtry1);
ps(1,:)=a';
zs(1,:)=b';

REzero=-0.25;
REpole=0;
gsym=k*((p-REzero+j*0.66)*(p-REzero-j*0.66))/(  (p-REpole+j)*(p-REpole-j)*(p+1));
gtry2=sym2tf(gsym);
subplot(SUB+2);
rlocus(gtry2)
legend('gtry2')

[a b]=pzmap(gtry2);
ps(2,1:length(a))=a';
zs(2,1:length(b))=b';

REzero=-1/4;
REpole=0;
gsym=k*((p-REzero+j*0.66)*(p-REzero-j*0.66))/(p*(p-REpole+j)*(p-REpole-j)*(p+1));
gtry3=sym2tf(gsym);
subplot(SUB+3);
rlocus(gtry3)
legend('gtry3')
[a b]=pzmap(gtry3);
ps(3,:)=a';
zs(3,:)=b';

REzero=-0.1;
REpole=-0.05;
gsym=k*((p-REzero+j*0.66)*(p-REzero-j*0.66))/(p*(p+1));
gtry4=sym2tf(gsym);
subplot(SUB+4);
rlocus(gtry4)
legend('gtry4')
[a b]=pzmap(gtry4);
ps(4,1:length(a))=a';
zs(4,1:length(a))=b';

gtrys(1)=gtry1;
gtrys(2)=gtry2;
gtrys(3)=gtry3;
gtrys(4)=gtry4;

P=nyquistoptions;
P.ShowFullContour='off';

%%%%%% K bestimmen wenn w abgelesen wurde
syms w
zv=abs(j*w-zs(2,:));
pv=abs(j*w-ps(2,:));
kformel=prod(abs(pv))/prod(abs(zv));

kcalc=eval(subs(kformel,'w',1.5))

for i=1:4
    subplot(SUB+4+i);
    rlocus(feedback(gtrys(i),1));
    legend(sprintf('fb(gtry%i, Kr=1)',i));
end

% for i=1:3
%     subplot(SUB+3+i);
%     hold all;
%     nyquist(gtrys(i)*1,P)
%     nyquist(gtrys(i)*0.8,P)
%     nyquist(gtrys(i)*0.4,P)
%     hold off
%     legend(sprintf('gtry%i, Kr=1',i),sprintf('gtry%i, Kr=0.8',i),sprintf('gtry%i, Kr=0.4',i));
% %    xlim([-1 0.5]);
%     ylim([-10 10]);
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=230;

Kr(1)=eval(subs(kformel,'w',1.11));
Kr(2)=eval(subs(kformel,'w',4));
Kr(3)=eval(subs(kformel,'w',4));

for i=1:3
    subplot(SUB+i);
    hold all;
%    impulse(gtrys(2)*Kr(i))
    step(feedback(gtrys(i)*Kr(i),1))
    hold off;
    grid on;
end


ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');


return
% RT Klausurvorbereitung
% Klausur SS2011 A1

delete(findall(0,'type','line'))
clf


k=1;

% ss aus simulink und ss2tf in matlab
[A1 b1 ct1 d1]=linmod('RT_Klausur_2011_A1');
[num den]=ss2tf(A1,b1,ct1,d1);
sys1a=tf(num,den);

[A1 b1 ct1 d1]=linmod('RT_Klausur_2011_A1_ori');
[num den]=ss2tf(A1,b1,ct1,d1);
sys1b=tf(num,den);

% ss von hand und sst2f in matlab
A=[0 0 0 0; 0 -1 0 0; 0 0 0 -1; 0 0 1 0];
b=[1 1 1 0]';
ct=[1 -1 0 1];
% A=[-1 0 0 0; 0 0 0 0; 0 0 0 1; 0 0 -1 0];
% b=[1 1 0 1]';
% ct=[-1 1 1 0];
d=0;

[num den]=ss2tf(A,b,ct,d);
sys2a=tf(num,den);                      

A2=[0 1 0 0; -1 0 0 0 ; 0 0 -1 0; 0 0 0 0];
b2=[0 1 1 1]';
ct2=[1 0 -1 1];
d2=0;
[num den]=ss2tf(A2,b2,ct2,d2);
sys2b=tf(num,den);


% ss von hand und sst2f formel in matlab
syms p;
I=eye(4);

sys3aSym=ct*inv(p*I-A)*b+d;
sys3a=sym2tf(sys3aSym);                 

sys3bSym=ct2*inv(p*I-A2)*b2+d2;
sys3b=sym2tf(sys3bSym);

% ss von hand und sst2f von hand
sys4aSym=(2*p^2+p+1)/(p*(p^2+1)*(p+1));
sys4a=sym2tf(sys4aSym);                 %%% BAD %%%%%

sys4bSym=(2*p^2+p+1)/(p^2*(p^2+1)*(p+1));
sys4b=sym2tf(sys4bSym);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=220;

subplot(SUB+1);
hold all;
step(feedback(sys1a,1));
step(feedback(sys1b,1));
hold off;
legend('step(feedback(sys1a)','step(feedback(sys1b)')
grid on;

subplot(SUB+2);
hold all;
step(feedback(sys2a,1));
step(feedback(sys2b,1));
hold off;
legend('step(feedback(sys2a)','step(feedback(sys2b)')
grid on;

subplot(SUB+3);
hold all;
step(feedback(sys3a,1));
step(feedback(sys3b,1));
hold off;
legend('step(feedback(sys3a)','step(feedback(sys3b)')
grid on;

subplot(SUB+4);
hold all;
step(feedback(sys4a,1));
step(feedback(sys4b,1));
hold off;
legend('step(feedback(sys4a)','step(feedback(sys4b)')
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=220;

sysTFs(1)=sys1a;
sysTFs(2)=sys1b;

sysTFs(3)=sys2a;
sysTFs(4)=sys2b;

sysTFs(5)=sys3a;
sysTFs(6)=sys3b;

sysTFs(7)=sys4a;
sysTFs(8)=sys4b;

for i=1:8
    [zs ps ks]=tf2zpk(sysTFs.num{i},sysTFs.den{i});
    syss(i)=zpk(zs,ps,ks);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear zRE zIM pRE pIM zC izz izc zhc pC ipp ipc phc

for i=1:length(syss.z)
    [a(i) b(i)]=size(syss.z{i});
end
maxDim=[length(syss.z) max(max(a),max(b))];

zRE=zeros(maxDim(1),maxDim(2));
zIM=zeros(maxDim(1),maxDim(2));
zC=zeros(maxDim(1),maxDim(2));
izz=zeros(maxDim(1),maxDim(2));
izc=zeros(maxDim(1),maxDim(2));

for i=1:length(syss.p)
    [a(i) b(i)]=size(syss.p{i});
end
maxDim=[length(syss.p) max(max(a),max(b))];

pRE=zeros(maxDim(1),maxDim(2));
pIM=zeros(maxDim(1),maxDim(2));
pC=zeros(maxDim(1),maxDim(2));
ipp=zeros(maxDim(1),maxDim(2));
ipc=zeros(maxDim(1),maxDim(2));
phc=zeros(maxDim(1),maxDim(2));

for i=1:length(syss.z)
    N=length(syss.z{i});
    zRE(i,1:N)=real(syss.z{i});
    zIM(i,1:N)=imag(syss.z{i});
%     [zC(i,1:N) izz(i,1:N) izc(i,1:N)]=unique(syss.z{i});
%     if sum(abs(imag(syss.z{i}))) == 0
%         zhc(i,1:N)=histc(syss.z{i},zC(i,:));
%     else
%         zhc(i,1:N)=histc(angle(syss.z{i}),sort( angle(zC(i,1:N)) ));
%     end
end

for i=1:length(syss.p)
    N=length(syss.p{i});
    pRE(i,1:N)=real(syss.p{i});
    pIM(i,1:N)=imag(syss.p{i});
%     [pC(i,1:N) ipp(i,1:N) ipc(i,1:N)]=unique(syss.p{i});
% %    phc(i,1:N)=histc(syss.p{i},pC(i,1:N));
%     if sum(abs(imag(syss.p{i}))) == 0
%         phc(i,1:N)=histc(syss.p{i},pC(i,:));
%     else
%         phc(i,1:N)=histc(angle(syss.p{i}),sort( angle(pC(i,1:N)) ));
%     end

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

%     for k=1:length(zC(i,:))
%         if zhc(i,k)>1           % NS- ordnung erst bei grad größer 1
%             text(zC(i,k),textPosY,sprintf('(%d)',zhc(i,k)),...
%                 'HorizontalAlignment','center',...
%                 'VerticalAlignment','bottom')
%         end
%     end
% 
%     for k=1:length(pC(i,:))
%         if phc(i,k)>1           % Polordnung erst bei grad größer 1
%             text(pC(i,k),-textPosY,sprintf('(%d)',phc(i,k)),...
%                 'HorizontalAlignment','center',...
%                 'VerticalAlignment','top')
%         end
%     end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 3 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
SUB=220;

subplot(SUB+1);
hold all;
hn(1)=nyquistplot(sys1a,'b',sys1b,'g');
legend('sys1a','sys1b')

subplot(SUB+2);
hn(2)=nyquistplot(sys2a,'b',sys2b,'g');
legend('sys2a','sys2b')

subplot(SUB+3);
hn(3)=nyquistplot(sys3a,'b',sys3b,'g');
legend('sys3a','sys3b')

subplot(SUB+4);
hn(4)=nyquistplot(sys4a,'b',sys4b,'g');
legend('sys4a','sys4b')


for i=1:length(hn)
    set(hn(i),'ShowFullContour','off');
    hop=getoptions(hn(i));
    hop.XLim=[-20 20];
    hop.YLim=[-3 3];
    setoptions(hn(i),hop);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 4 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f4=figure(4);
SUB=330;


ms=7;lw=2;
gray1=[1 1 1]*hex2dec('63')/255;

for i=1:8
    subplot(SUB+i);
    hold on;
    plot(real(syss.z{i}),imag(syss.z{i}),'o','MarkerSize',ms,'LineWidth',lw);
    plot(real(syss.p{i}),imag(syss.p{i}),'X','MarkerSize',ms,'LineWidth',lw);
    legend(sprintf('zero syss(%i)',i),sprintf('pole syss(%i)',i) );
    hold off;
    grid on;
    xlim(reAx*1.2)
    ylim(imAx*1.2)
    line(reAx*1.2,[0 0],'Color', gray1);
    line([0,0],imAx*1.2,'Color', gray1);

end


ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return






% RT Klausurvorbereitung
% Uebung 2013-14

p1=tf([0.67],[0.33 1 0])
p2=tf([0.67],[0.33 1])

syms k;

MODE=1;

if MODE==0;
    f1=figure(1);
    SUB=220;

    % subplot(SUB+1);
    % hold all;
    % pzmap(p1)
    % pzmap(p2)
    % hold off;

    xticks=[0:.25:5];

    subplot(SUB+1);
    hold all;
    impulse(p1)
    step(p2)
    hold off;
    grid on;
    set(gca,'XTick',xticks);
    legend('p1');

    subplot(SUB+2);
    hold all;
    step(p1)
    hold off;
    grid on;
    set(gca,'XTick',xticks);
    legend('p1');


    subplot(SUB+3);
    hold all;
    impulse(p2)
    hold off;
    grid on;
    set(gca,'XTick',xticks);
    legend('p2');

    subplot(SUB+4);
    hold all;
    step(p2)
    hold off;
    grid on;
    set(gca,'XTick',xticks);
    legend('p2');

    %%%%%%%%%%%%%%%%%%%%%%%
    A=[0 0; 1 -3];
    b=[1;0];
    c=[0 3*.65];
    [p1a_num p1a_den]=ss2tf(A,b,c,0);
    p1a=tf(p1a_num,p1a_den);

    [A2,b2,c,~]=tf2ss(p1.num{1},p1.den{1})

    f2=figure(2);
    SUB=130;

    xticks=[0:.25:5];
    subplot(SUB+1);

    hold all;
    impulse(p1);
    impulse(p1a);
    hold off;
    grid on
    set(gca,'XTick',xticks);
    legend('p1','p1a');

    %%% mehrfachpole ohne dominierenden pol

    g1=zpk([],[-1+j*3 -1-j*3 -1],1)

    subplot(SUB+2);
    hold all;
    step(g1);
    hold off;
    grid on
    %set(gca,'XTick',xticks);
    legend('g1');


    syms k;
    k=0.2;
    c1=tf(k*[5 1],[1 0]);

    subplot(SUB+3);
    hold all;
    P=nyquistoptions;
    P.showFullContour='off';
    nyquist(c1*p1,P)
    hold off;
    legend('c1*p1');
    axis([-2 2 -2 2]);
end


f3=figure(3);
SUB=120;

xticks=[0:.25:5];
subplot(SUB+1);

hold all;
step(feedback(c1*p1,1))
hold off;
grid on

[num den]=ss2tf([0 0;3 -3],[1;0],[0 0.67],0);
p1ss=tf(num,den);

k=0.2;

%%%% ss von hand erstellt:
As=[0 0 -.67*k; 1 0 -5*k*0.67; 0 3 -3];
bs=[k; 5*k; 0];
cs=[0 0 0.67];

[num den]=ss2tf(As,bs,cs,0);
sstot=tf(num,den);

eig(As)
pole(feedback(c1*p1ss,1))

subplot(SUB+2);
hold all;
step(feedback(c1*p1,1))
step(feedback(c1*p1ss,1))
step(sstot)
hold off;
grid on
legend('fb(c1*p1)','fb(c1*p1ss)','sstot');




ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');








