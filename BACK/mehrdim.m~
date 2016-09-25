function [ output_args ] = mehrdim( min,max )
%MEHRDIM Summary of this function goes here
%  function sincos2d( min,max )

x0=1;
y0=2;
t=[min:0,1:max];
%[x,y]=(x-1)^2+(y-2)^2+sin(x);
[x,y]=meshgrid(-5:0.1:5,-5:0.1:5);
f=(x-1).^2+(y-2).^2+sin(x);
z0=(x0-1).^2+(y0-2).^2+sin(x0);

surf(x,y,f)
hold on 
scatter(x0,y0,500,'.','r')

z=sin(sin(1)+cos(1).*(x-1);
surf(x,y,z);

z2=sin(1)+cos(1).*(x-1)+0.5*(

zx=2.*(x-1)+cos(x);
zx0=2.*(x0-1)+cos(x0);

zy=2.*(y-2)+cos(y);
zy0=2.*(y0-2)+cos(y0);
ze=z0+zx0.*(x-x0)+zy0.*(y-y0);
surf(x,y,z)
shading flat
hold on
surf(x,y,ze)
z2e=z0+zx0.*(x-x0)-4
%xt=t;
%yt=(3/2).*t;
%zt=sin(xt).*cos(yt);
%plot3(xt,yt,zt,'r')
% (1-t^2/2)exp(-t^2/2)
hold off
end

