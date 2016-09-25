% Transformation Polar- Kartesisch
%

x=[-5:0.1:5];
y1=x.^2+2*x-x.^3;

theta = 0:0.01:2*pi;
rho = sin(2*theta).*cos(2*theta);

[th, r]=cart2pol(x,y1)

ls1=linspace(-pi/2,pi/2,50);
th1=ones(1,50)*pi/4;

p1=figure(1);
polar(ls1,cos(ls1),'r')

xs=linspace(-5,5);
ys=linspace(-5,5);
[X,Y] = meshgrid(xs,ys);

f1=@(x,y) x.*y.^2
p2=figure(2);
%surf(X,Y,f1(X,Y))
plot(cos(xs),sin(ys))
grid on;
axis equal;

%view(3)





