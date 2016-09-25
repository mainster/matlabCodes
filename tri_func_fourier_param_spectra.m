%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tri function - Fourier parameters | Transformation Spectra        14-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
T0=1e-3;
SPACE = 0.2;

% Start Zeitpunkt ab dem das Signal definiert ist
initialTime = -1;
funcPeriode = T0;
numberOfFreq = 10;
ptsPerPeriode = 100;
methode = 2;
res = 0;

% [freq,coeff,APspec] = fourier_coeff ('10*cos(2*pi*3*t-pi/4)', initialTime, funcPeriode);

[freq,coeff,APspec] = fourier_coeff( 'sin(2*pi*1*t)', initialTime, funcPeriode,...
                                     numberOfFreq, ptsPerPeriode,...
                                     methode, res);

                                  
f2 = figure(2);
SUB=320;
s(1) = subplot(SUB+1)
stem(APspec(:,1));
title('Amplitude spectra')
ycur=ylim;
%ylim( [ycur(1) ycur(2)]+[-1 1]*SPACE*diff(ycur) );
tx(1) = text(length(APspec(:,1))/2, ycur(2), funcStr{fsidx});

                                  
clear f1 tt ax
syms t
wh=whos('rect');
if isempty(wh)
   rect= @(x) heaviside(x+0.5) - heaviside(x-0.5)
end

f1=figure(1); clf;
SUB=120;

ax(1)=subplot(SUB+1);


tt=linspace(-T0, T0,200);

r=@(t, T0) rect((t+T0/4)/T0);
m1=@(t) 4/T0*(t+T0/4)
m2=@(t) -4/T0*(t-T0/4)

p(1) = plot(tt,r(tt, T0).*m1(tt),'b','linewidth',2); hold all;
p(2) = plot(tt,r(tt,-T0).*m2(tt),'r','linewidth',2); hold off;
p(3) = line([-T0/2, T0/2], [0.5, 0.5],'color','black');
%%

xl=get(ax(1),'XtickLabel');
normXl=sprintf('%.2g T \n',[str2num(xl)]'/T0);
%set(ax(1),'XTickLabel', normXl);
%%
ylim([ylim]*1.1);
xl1=xlim;
%%

ax(2)=subplot(SUB+2);
pp(1) = ezplot(r(t, T0).*m1(t),[xl1(1), xl1(2)]); hold all;
pp(2) = ezplot(r(t,-T0).*m2(t),[xl1(1), xl1(2)]); hold off;
%p(3) = line([-T0/2, T0/2], [0.5, 0.5],'color','black');


