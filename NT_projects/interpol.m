% Interpolieren von Polynomen

clear all
hold off

%x=[1 2 3 4 5 6];
%y=[2 4 1 6 7 3];

h=0.2;
x=0:h:5;
y=sin(x)+rand(size(x));

n=length(x);
%p=[1 0 -30 30];
%p_int=polyfit(x,y,n-1);

%xp=linespace(0,5,500);
xp=0:0.01:6;
yp=polyval(p_int,xp);


plot(x,y,'r*',xp,yp,'b')

yps=spline(x,y,xp);

hold on;
plot(xp,yps,'s')

ylim([-10 10])
