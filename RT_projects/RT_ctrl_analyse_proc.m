% Nyquist, stabilität und pole
% Kreisverstärkung
%
delete(findall(0,'type','line'))
SIM_MODEL='RT_ctrl_analyse';

fb=0;       % -> linmod gibt kreisverstärkung zurück
SUB=130;
% zpk plant:
z=8;
p=[1 1];
k=4;

gain=1;
zero=[];
legStr=[];
plantMod=tf(zpk(z,p,k));
for i=1:5
    poles=[-i];
    [num den]=linmod(SIM_MODEL);    % get closed loop linear model
    g0(i)=tf(num,den);
    g0zpk(i)=zpk(g0(i));
    legStr=[' P(s)*1/(s+' int2str(-poles) ')' legStr]; 
end


f1=figure(1);
cla reset;
origCO=get(gcf,'DefaultAxesColorOrder');
SUB=110;

subplot(SUB+1);

hold all;

win = linspace(0,10*pi,512);
tin=linspace(0,10,256);
re=zeros(5,512);
im=zeros(5,512);
ys=zeros(5,256);
t=zeros(5,256);
clear w;

for i=1:5
    [re(i,:),im(i,:),w(i,:),~,~]=nyquist(g0zpk(i),win);
    [ys(i,:),t(i,:)]=step(g0zpk(i),tin);
    plot(re(i,:),im(i,:),'-o','MarkerSize',1.6)
end
%[re1 im1]=nyquist(g0zpk(i),0.219);
%plot(20,-5, 'MarkerFaceColor','g',...
%                'MarkerSize',10)

ce=strsplit(legStr(2:end),' ');
nyquist(tf(-1),win);
legend(ce,'Location','NorthEast');
%axis([-2 9 -6 1])
%set(gca,'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[1,1,1])
set(gca,'DataAspectRatio',[1,1,1])


f2=figure(2);
%subplot(SUB+2);
hold all 
set(gcf,'DefaultAxesColorOrder',origCO);
    
P = nyquistoptions;
P.ShowFullContour = 'off'; 
P.MagUnits='abs';

for i=1:5
    nyquist(g0zpk(i),P,win)
end
nyquist(tf(-1),P,'+r');

%set(gca,'NegativeFrequencies','Off')
%axis([-2 9 -6 1])
set(gca,'DataAspectRatio',[1,1,1])

f3=figure(3);
cla reset;

hold all;
for i=1:5
    plot(t(i,:),ys(i,:))
end
legend(ce,'Location','NorthEast');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getting handles from children
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f5=figure(5);
g1=zpk([],[-1+j -1-j],10);
g2=zpk([],[-1 -2],[10]);    % g2!!!

orange=[1 156/256 0];
lightGreen=[1 104/256 0];
nyquist(g1,g2,0.2*g1*g2,P);

legStr=['G1(p)=' char(tf2sym(g1)),...+
        ':G2(p)=' char(tf2sym(g2)),...
        ':G12(p)=0.2*' char(tf2sym(g1*g2))]; 
    
ce=strsplit(legStr(1:end),':');
legend(ce,'Location','NorthEast');

% 
% get(gca);       % list handle properties
% ch=get(gca,'Children');
% get(ch(2));
% chch=get(ch(2),'Children');
% get(chch(1));
% set(chch(1),'Color',orange);
% set(chch(2),'Color',lightGreen);
% 
% hLeg=legend('g1','g2','show');
% hh=get(hLeg(1),'Children');
% get(hh(1));
% hchLeg=get(hLeg);
% gcol=chLeg.ColorOrder;
% gcol(1,:)=orange;
% gcol(2,:)=lightGreen;
% set(chLeg.ColorOrder=gcol);
logrange=[1e-2;1e2;4000];

wlin = linspace(logrange(1),logrange(2),logrange(3));
wlog = logspace(-1,1,500);
tin=linspace(0,10,500);
re=zeros(5,logrange(3));
im=zeros(5,logrange(3));
ys=zeros(5,256);
t=zeros(5,256);

clear w;

zp1=zpk([],[-1],1);
zp2=zpk([],[-2],1);
zp2=zpk([],[-0.5+0.5*j -0.5-0.5*j],1);

[re(1,:),im(1,:),w,~,~]=nyquist(zp1,wlin);
[re(2,:),im(2,:),w,~,~]=nyquist(zp2,wlin);
[re(3,:),im(3,:),w,~,~]=nyquist(zp1*zp2,wlin);


SUB=330;
f6=figure(6);
hold all;
cla reset;
angG1(1,:)=angle(re(1,:)+j*im(1,:));
angG1(2,:)=angle(re(2,:)+j*im(2,:));
angG1(3,:)=angle(re(3,:)+j*im(3,:));

cla reset;
subplot(3,3,[1 2]);
%ls1=linspace(1e-2,1e2,500);
semilogx(wlin,angG1*180/pi);
grid on;
legend('G1p1','G1p2','G1_tot')

subplot(3,3,[4 5 7 8]);
nyquist(zp1*3,zp2*3,9*zp1*zp2,P);

% axis([  -1,...
%         1.2*max(re(:)),...
%         1.2*min(im(:)),...
%         1.2*max(im(:))])
h=axis(gca);
%h(1)=-1.5;
%h(4)=.5;
%axis(h);
%set(gca,'DataAspectRatio',[1,1,1])

legend('zp1','zp2','zp12')

%axis([1e-1 10 -90 90])
%f7=figure(7);

subplot(3,3,[6 9]);
pzmap(zp1,zp2,zp1*zp2);
sgrid
%se=abs(min([zp1.p{:};zp2.p{:};zp1.p{:}*zp1.p{:}]));
h=axis;
axis([h(1) h(2) h(3) h(4)]*1.2);
axis=(h);

%legend('zp1','zp2','zp12','Location','NorthOutside')

subplot(3,3,[3]);
rlocus(zp1,zp2,zp1*zp2);
sgrid
legend('zp1','zp2','zp12','Location','NorthEast')

% Bandpass design
% wc_u=0.5
% wc_o=20

G1=tf(1,[20 1]);
G2=tf([2 0],[2 1]);

bode(G1*G2); grid on;

fhs=sort(findall(0,'type','figure'));
delete(sort(fhs([1:end-3])));

return
 
re=zeros(5,512);
im=zeros(5,512);
[re(1,:), im(1,:), w]=nyquist(zpk([],g1.p{1}(1),1),win);
[re(2,:), im(2,:), w]=nyquist(zpk([],g1.p{1}(2),1),win);

angG1p1(1,:)=angle(re(1,:)+j*im(1,:));
angG1p2(1,:)=angle(re(2,:)+j*im(2,:));
angG1p1(2,:)=w(1,:);
angG1p2(2,:)=w(2,:);

subplot(SUB+1);
plot(angG1(2,:),angG1(1,:)); grid on;

subplot(SUB+2);
hold all;
plot(angG1p1(1,:),angG1p1(2,:)); grid on;
plot(angG1p2(1,:),angG1p2(2,:)); grid on;
plot((angG1p1(1,:)+angG1p2(1,:)),angG1p1(2,:)); grid on;

return

subplot(SUB+2);
nyquist(g0_0);
legend('G0 C=off');

subplot(SUB+3);
nyquist(g0_1);
legend('G0 C=on');
%set(h3,'Position',[0.05 0.25 0.05 0.05])

SUB=230;

f2=figure(2);
subplot(SUB+1);
pzmap(g0_0,g0_1);
legend('G0 C=off','G0 C=on');

subplot(SUB+2);
pzmap(g0_0);
legend('G0 C=off');

subplot(SUB+3);
pzmap(g0_1);
legend('G0 C=on');

subplot(SUB+4);
rlocus(g0_0,g0_1);
legend('G0 C=off','G0 C=on');

subplot(SUB+5);
rlocus(g0_0);
legend('G0 C=off');

subplot(SUB+6);
rlocus(g0_1);
legend('G0 C=on');

return;

% PT1
SIM_MODEL='RT_PT1_blocks';

SUB=220;

f3=figure(3);

T=0.1;
k=5;
sel=1;
[num den]=linmod(SIM_MODEL);
sys1=tf(num,den);

sel=2;
[num den]=linmod(SIM_MODEL);
sys2=tf(num,den);

sel=3;
[num den]=linmod(SIM_MODEL);
sys3=tf(num,den);

subplot(SUB+1);
nyquist(sys1,sys2,sys3);
legend('PT1a','PT1b','PT1c');

subplot(SUB+2);
pzmap(sys1,sys2,sys3);
legend('PT1a','PT1b','PT1c');


% DT1
SIM_MODEL='RT_DT1_blocks';

T=0.1;
k=5;
sel=1;
[num den]=linmod(SIM_MODEL);
sys1=tf(num,den);

sel=2;
[num den]=linmod(SIM_MODEL);
sys2=tf(num,den);

sel=3;
[num den]=linmod(SIM_MODEL);
sys3=tf(num,den);

subplot(SUB+3);
nyquist(sys1,sys2,sys3);
legend('DT1a','DT1b','DT1c');

subplot(SUB+4);
pzmap(sys1,sys2,sys3);
legend('DT1a','DT1b','DT1c');
