% Gradient bilden
clear all;
[x y] = meshgrid (-5:0.2:5);
x0=0; y0=-2;

f0=f(x0,y0);
[fx fy]=gradientSelf(@f, x0,y0);
H=hesse(@f, x0,y0);
yt=f0+fx*(x-x0)+fy*(y-y0);
yp=yt+0.5*H(1,1)*(x-x0).^2+H(1,2)*(x-x0).*(y-y0)+0.5*H(2,2)*(y-y0).^2;

surf(x,y,f(x,y));
%colormap([1 1 0])
%freezecolors;
hold on;

surf(x,y,yt)
%colormap([1 1 0])
%freezecolors;

surf(x,y,yp)
%colormap([1 1 0])

plot3(x0,y0,f(x0,y0),'ro','MarkerSize',10,'MarkerFaceColor','r')

hold off;
