syms t f w T0 f0 w0 real;
assumeAlso([T0 f0 w0] > 0);
f1=figure(1);
delete(findall(0,'type','line'))

T0=0.1;
a=0.25;

d1=@(tau) a * (rect((tau+T0)/(T0/4)) + rect((tau-T0)/(T0/4)))+rect(tau/(T0/4)); 
f1=@(tau) a * (tri((tau+T0)/(T0/4)) + tri((tau-T0)/(T0/4)))+tri(tau/(T0/4)); 

rng3=[-1 1]*2*T0;
ezplot(f1(t), rng3); hold all;
ezplot(d1(t), rng3); 
ylim([-.1,1.1]);
line([-3*T0:T0:3*T0]'*[1 1],[-0.2 1],'color','r','linestyle','--'); 
hold off;
%%
f2=figure(2);
delete(findall(0,'type','line'))
SUB=310;

subplot(SUB+1);
dd1=@(tau)subs(d1(tau),'T0',T0);
tt=ls(-2*T0,2*T0,250);
vdd1=double(dd1(tt));

stem(tt,vdd1)
%%
subplot(SUB+2);
tt2=ls(-4*T0,4*T0,2*250-1);
stem(tt2,T0/4*conv(vdd1,vdd1)); hold all;
stem(tt,vdd1); hold off;

%%
subplot(SUB+3);
tt2=ls(-4*T0,4*T0,2*250-1);
stem(tt2,xcorr(T0/4*vdd1)); 

return
%%
if (0)
   clear all; close all; startup
   disp(' ')
   syms t f w T0 f0 w0 real;
   assumptions
   assumeAlso([T0 f0 w0] > 0);
end
dgreen=[0 .7 0.2];

ls = @linspace;
syms t f w T0 f0 w0 k real
assumeAlso([T0, f0,w0] > 0 );
assumeAlso(k, 'rational' );

f0=1/T0;
f1=figure(1);
delete(findall(0,'type','line'))
SUB=320;
%% well known
T0=1;
f1 = @(t) rect(t); 
g1 = @(t) triangularPulse(t); 
RECT=@(f) simplify(fourier(f1(t),t,2.*pi.*f));
RECT(f)
TRI=@(f) simplify(fourier(g1(t),t,2*pi*f));
TRIs=strrep(func2str(TRI),'*','.*')

TRI(f)

%%

clear ez*
s(1)=subplot(SUB+1);
ez1=ezplot(f1(t),ls(-2,2,200)); hold all;
ez2=ezplot(g1(t),ls(-2,2,200)); hold off;
set(ez1, 'color', 'blue');
set(ez2, 'color', dgreen);

ff=ls(-10e3,10e3,250);
clear ez*
s(2)=subplot(SUB+2);


ez1=ezplot(RECT(f),ls(-4,4,200)); hold all;
ez2=ezplot(TRI(f),ls(-4/T0,4/T0,200)); hold off;
set(ez1, 'color', 'blue');
set(ez2, 'color', dgreen);
line([-3:1:3]'*[1 1],[-0.2 1],'color','r','linestyle','--')
%% different T0
T0=0.1;
f2 = @(t) rect(t/T0); 
g2 = @(t) triangularPulse(t/T0); 
RECT2=@(f) simplify(fourier(f2(t),t,2*pi*f));
RECT2(f)
TRI2=@(f) simplify(fourier(g2(t),t,2*pi*f));
TRI2(f)

clear ez*
s2(3)=subplot(SUB+3);
ez1=ezplot(f2(t),ls(-2*T0, 2*T0, 200)); hold all
ez2=ezplot(g2(t),ls(-2*T0, 2*T0,200)); hold off;
set(ez1, 'color', 'blue');
set(ez2, 'color', dgreen);

clear ez*
s(4)=subplot(SUB+4);
ez1=ezplot(RECT2(f),ls(-4/T0, 4/T0, 200)); hold all;
ez2=ezplot(TRI2(f),ls(-4/T0, 4/T0, 200)); hold off;
set(ez1, 'color', 'blue');
set(ez2, 'color', dgreen);
line([[-3:1:3]*1/T0]'*[1 1],[-0.2 1],'color','r','linestyle','--')

%% Fourier series
syms T0 real;
assumeAlso(T0 > 0);

af2=@(k,T0) 2/T0*int(f2(t)*cos(k*2*pi/T0*t),t,-T0/4,T0/4);
bf2=@(k,T0) 2/T0*int(f2(t)*cos(k*2*pi/T0*t),t,-T0/4,T0/4);

ag2=@(k,T0) 2/T0*int(f2(t)*sin(k*2*pi/T0*t),t,-T0/2,T0/2);
bg2=@(k,T0) 2/T0*int(f2(t)*sin(k*2*pi/T0*t),t,-T0/2,T0/2);
%%
T0=1e-3;
f0=1/T0;
rng=linspace(-3*f0,3*f0,20);
af2d=double(af2(rng,T0))'
stem(rng, af2d)
%%
af2g=double(ag2(rng,T0))'
stem(rng, af2g)
return
%%
if (1)
   clear all; close all; startup
   disp(' ')
   syms t f w T0 f0 w0 real;
   assumptions
   assumeAlso([T0 f0 w0] > 0);
end

assumptions

T0=1e-3;
f0=1/T0;

csigma = @(x)heaviside(x);
tri = @(x)(x+1).*csigma(x+1)-2.*x.*csigma(x)+(x-1).*csigma(x-1);

r=@(t) rect(t/(T0/8));
tt=linspace(-2*T0/8, 2*T0/8, 200);
ff=linspace(-3/(2*T0/8),3/(2*T0/8),200); 

%% Plots
f1=figure(1);
SUB=210;
s(1)=subplot(SUB+1);
ezplot(r(t),tt);
ylim(ylim*1.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
transKern = (2*pi*f);
fprintf('%s\n%s\nTransformations-Kern: %s\n%s\n%s\n',...
   ds,ds,char(transKern),ds,ds)
R=@(f) eval( fourier(r(t), t, transKern) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R(t)

s(2)=subplot(SUB+2);
%ezplot(R(f),-100000,100000)
ezplot(R(f),ff)
return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Kardinalsinus mal wieder....                             13-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear re* freq coeff APspec
syms t T f;
clf
Tz = 1e-3;
T0=Tz;
w=2*pi/T0;
f0=1/T0;
% Space between highest/lowest plot sample and outer axis
SPACE = 0.2;

funcStr = { ['heaviside(t+' num2str(T0) '/2)-heaviside(t-' num2str(T0) '/2)'],... 
            'sin(2*pi*1e3*t)',...
            'cos(2*pi*f0*(t+f0/4))+cos(2*pi*f0*(t-f0/4))',...
            ['cos(2*pi/' num2str(Tz) '*t)'],...
            ['sin(pi*t*' num2str(Tz) ')/(pi*t*' num2str(Tz) ')'],...
            ['sinc(pi*t*' num2str(Tz) ' )'],...
            'sin(2*pi*2*t)+sin(2*pi*4*t)+sin(2*pi*5*t)',...
            '0.2*sin(2*pi*2*t).*0.4.*sin(2*pi*4*t)*.6.*sin(2*pi*5*t)',...
            'tri(t)'
            };

fsidx = length(funcStr);
fsidx = 2;

% Start Zeitpunkt ab dem das Signal definiert ist
initialTime = -1;
funcPeriode = T0;
numberOfFreq = 10;
ptsPerPeriode = 200;
methode = 2;
res = 0;

ff=subs(funcStr{fsidx},'f0',f0);
[freq,coeff,APspec] = fourier_coeff( char(ff), initialTime, funcPeriode,...
                                     numberOfFreq, ptsPerPeriode,...
                                     methode, res);
%% PLOTS
f99=figure(99);
SUB=320;

s(1) = subplot(SUB+1);
stem(APspec(:,1));
title('Amplitude spectra')

s(2) = subplot(SUB+2);
stem(APspec(:,2));
title('Phase spectra');

s(3) = subplot(SUB+3);
stem(abs(coeff)*T0);
title('Fourier coeffs |c_n|');
% ycur=ylim;
% ylim( [ycur(1) ycur(2)]+[-1 1]*SPACE*diff(ycur) );
set(gca,'yscal','log')

s(4) = subplot(SUB+4);
%stem(abs(coeff)); hold all;
stem(angle(coeff)); 
hold off;
title('arg( c_n )');



return
%%
ff=[-fliplr(freq(2:end))' freq'];                                 
f1 = figure(1);
SUB=320;

s(1) = subplot(SUB+1)
stem(APspec(:,1));
title('Amplitude spectra')
ycur=ylim;
ylim( [ycur(1) ycur(2)]+[-1 1]*SPACE*diff(ycur) );
tx(1) = text(length(APspec(:,1))/2, ycur(2), funcStr{fsidx});

s(2) = subplot(SUB+2)
stem(APspec(:,2));
title('Phase spectra')
ycur=ylim;
ylim( [ycur(1) ycur(2)]+[-1 1]*SPACE*diff(ycur) );

s(3) = subplot(SUB+3)
stem(ff, coeff);
title('Fourier coeffs |c_n|')
ycur=ylim;
ylim( [ycur(1) ycur(2)]+[-1 1]*SPACE*diff(ycur) );

s(4) = subplot(SUB+4)
%stem(abs(coeff)); hold all;
stem(angle(coeff)); 
hold off;
title('arg( c_n )');
tx(2) = text(length(APspec(:,1))/2, ycur(2), funcStr{fsidx});

s(5) = subplot(SUB+5)
gg=@(t) eval(funcStr{fsidx})
ezplot(gg,[-1,1]); 
title('Function')

FT=fourier(eval(funcStr{fsidx}),t,f)
FTh=@(f) eval(FT);
%%
s(6) = subplot(SUB+6)
%gg=@(t) eval(funcStr{fsidx})
% ezplot(abs(FT(f)),[-1,1]*1e9); 
title('Function')

return;
%%
figure(10);
SUB=220;

s(1)=subplot(SUB+1);
stem(coeff) 

s(2)=subplot(SUB+2);
stem(abs(coeff)); 

return;

%% pulse width 1ms
T0=1e-3;  
Ts=T0/15;
%% Sample rate / resolution

% TSAMP = 4*25;
% TSAMP4 =TSAMP / 4;
% tt=linspace(-T0/2, T0/2, TSAMP);

in = [0 0 0 1 1 0 0 0]';
inCo=[0 1 1 0 0 0 0 0]';

re=rectpulse(in, T0/Ts);
reCo=rectpulse(inCo, T0/Ts);

tt=linspace(-T0/2,T0/2,length(in)*T0/Ts)*1e3;
tt2=linspace(-T0,T0,2*length(in)*T0/Ts-1)*1e3;

%% Plot time domain
f10 = figure(10);
delete(findall(0,'type','line'));
SUBS=220;
%%
su(1)=subplot(SUBS+1);
stem(tt, re, 'b'); hold all;
stem(tt, reCo, 'r'); hold off;
xlabel('t/T_o')
ylim([ylim]*1.2);
%%
su(2)=subplot(SUBS+3);
nSampCo = length(inCo)*T0/Ts;
re_conv=conv(re,re)/nSampCo;
re_corr=xcorr(re,re)/nSampCo;
%stem(tt2, re_conv)

%line(x1,y1,'Color','r')

% axL(1,1).pos;

xlabel('t/T_o')
ylim([ylim]*1.2);

%%
axL(2) = subplot(SUBS+2);               % std left+lower axes
nSampCo = length(inCo)*T0/Ts;
re_conv=conv(re,re)/nSampCo;
re_corr=xcorr(re,re)/nSampCo;

% ctr=0;
% while (strcmpi(char(get(axR(2),'YAxisLocation')), 'left'))
%     set(axR(2),'YAxisLocation', 'right');
%     if (ctr > 1e3)
%         fprintf('break!!\n')
%         break;
%     end
% end

pos=get(axL(2), 'Position');

set(axL(2), 'XColor','black');
set(axL(2), 'YColor','red');

axR(2) = axes('Position',pos);
set(axR(2),'YAxisLocation', 'right');
% set(axR(2),'XAxisLocation',')

stem(tt, re_corr(round(end/4:3/4*end)),'g'); hold all;
stem(tt, re_conv(round(end/4:3/4*end)),'color','magenta'); 
stem(tt, re, 'b'); 
stem(tt, reCo, 'r'); hold off;

xlabel('t/T_o')
% ylim([ylim]*1.2);
%%

    
return


%%
syms t T f;

%% pulse width 1ms
T=.2;                    
%% Sample rate / resolution
Ts=.01;

r1 = heaviside(t+T)-heaviside(t-T);
tt=linspace(-2*T,2*T,200);

%% convolve function r1 with f2
r1f = @(t) heaviside(t+T)-heaviside(t-T);

%% Fourier transform symbolic expression of r1
R1 = fourier(r1,t,f);
disp(['R1(f)=' char(R1)])

%% cpx = [abs angle] vector of spectra R1
cpx=[abs(R1), angle(R1)*180/pi];
ff=[-10/T:Ts:10/T-Ts];
%%
y.abs=eval(subs(cpx(1,1), 'f', 'ff'));
y.arg=eval(subs(cpx(1,2), 'f', 'ff'));
%% find zeros 
% zero cross inaccuracy
zci=3;

idx=find( (y.abs >= -zci/length(y.abs)) & (y.abs<=zci/length(y.abs)));

%% Plot time domain
f1 = figure(1);
delete(findall(0,'type','line'));
SUBS=220;

su(1)=subplot(SUBS+1);
plot(tt,(heaviside(tt+T/2)-heaviside(tt-T/2)));
ymin = min(ylim);   ymax = max(ylim);
scal=abs(diff(double([ymin, ymax])))/2;
ylim([ymin, ymax]+0.2*[-scal scal])
grid minor;

%% Plot frequency domain
su(2)=subplot(SUBS+2);
[l1 l2]=plotyy(ff, y.abs, ff, y.arg);
grid minor;
a=[1:3]';
lins=line([a./T a./T],[0 0.5])

legend(su(1),sprintf('r1(t)=rect(t/%g)\nT=%gs',T,T))
legend(su(2),'abs(R1)','angle(R1)*180/pi')

%% Complex fourier coeffs
r1 = rect(t+T)-heaviside(t-T);
f0=1e3;
%%
cn=@(n) 1/T*int(r1*exp(-i*2*pi*f0*n*t))
cn(0)
cn(1)

simplify(cn(-2:1:2))
