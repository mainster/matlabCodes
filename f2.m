function fun = f2(x,y)
%
%z=5.*cos(x)+x.^3-2.*x.^2-6.*x+10;
%fun=x.^2-2;
%fun=sin(x);
%fun=-1/5*x.^2-1/5*y.^2+3;
%fun=(2*x+y)./(1+x.*y);

% mx=[-10:0.3:10];
% my=[-10:0.3:10];
% xlim(LIM);ylim(LIM);zlim(LIM);
% fun=5*sin((x-1))./(x-1)+4*sin(y)./y;

% my=[-0.5:0.1:2.5];
% mx=[-3:0.1:3];
% ylim([-0.5 2.5]);xlim([-3 3]);zlim([-30 15]);
fun=3*x.^2.*y+4*y.^3-3*x.^2-12*y.^2+1;
%fun=1/sqrt(3)*sqrt(x.^2+2*x.^2-6);
end
