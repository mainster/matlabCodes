% M-File  DSV21.M      Version für MATLAB 4.0

%

% Bild 2.1 zu DSV Kap. 2.1

%

% 3 Signale darstellen



clear, close, clc



% Rechteckpuls

T1=.001; t1=-1:T1:1;		% T1: Abtastintervall

y=zeros(1,2001); y(993:1007)=100*ones(1,15);

subplot(2,1,1),plot(t1,y),axis([-1 1 -20 120]),grid

xlabel('t   [s]'),ylabel('u(t)   [V]')

title('Kurzzeitiges Einschalten einer Gleichspannungsquelle')

set(gcf,'Units','normal','Position',[0 0 1 1]),pause



% Einschwingvorgang eines Bandpassfilters

[b,a]=cheby1(2,6,[.03 .2]);   

x=[zeros(1,51) ones(1,200)];

T2=.01;	t2=-.5:T2:2;	% T2: Abtastintervall

y=2*filter(b,a,x);

clf,subplot(2,1,1),plot(t2,y),axis([-0.5 2 -1 1]),grid

xlabel('t   [s]'),ylabel('u(t)   [V]')

title('Einschwingvorgang eines Bandpassfilters'), pause





% "Ah"-Laut

load dsv21				% "Ah"-Laut laden

N3=2048; T3=.04/N3; t3=0:T3:.04-T3;	% T3: Abtastintervall

clf,subplot(2,1,1),plot(1000*t3,Ah),axis([0 40 -2.5 2.5]),grid

xlabel('t   [ms]'),ylabel('u(t)   [V]')

title('Verstaerktes Mikrofonsignal des Lautes "Ah"')
