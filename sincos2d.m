function sincos2d( min,max )
%MEXHAT Summary of this function goes here
%   Detailed explanation goes here

t=[min:0,1:max];
[x,y]=meshgrid(min:.03:max);
z=sin(x).*cos(2*y);
surf(x,y,z)
shading flat
hold on
xt=t;
yt=(3/2).*t;
zt=sin(xt).*cos(yt);
plot3(xt,yt,zt,'r')
% (1-t^2/2)exp(-t^2/2)
hold off
end
