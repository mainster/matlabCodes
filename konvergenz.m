%
% Konvergenz
%
clear all;
h=[1e-1 1e-4 1e-6 sqrt(eps) eps]
x=1;
y=5cos(x)+x.^3-2*x.^2-6*x+10;
ys=-5*sin(x)+3*x.^2-4*x-5;
yss=-5*cos(x)+6*x-4;

for i=1:length(h)
    dt=h(i);
    y_plus=5*cos(x+dt)+(x+dt).^3-2*(x+dt).^2-6