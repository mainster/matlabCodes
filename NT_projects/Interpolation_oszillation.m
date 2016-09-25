% Interpolieren von Polynomen

% x=[1 2 3 4 5 6];
% y=[2 4 1 6 7 3];
% n=length(x);
% p_int=poly

h=0.5;
x=0:h:5;
xp=0:0.01:5;
y=2.*x+1


yp=polyval(y,xp);


plot(xp,yp,'*',xp,yp,'b')