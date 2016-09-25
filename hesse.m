function A=hesse(g,x,y)
h=0.0001;
fx1=(g(x+h,y+h)-g(x,y+h))./h;
fx2=(g(x+h,y)-g(x,y))./h;

fxx=(g(x+h,y)-2*g(x,y)+g(x-h,y))./h^2;
fyy=(g(x,y+h)-2*g(x,y)+g(x,y-h))./h^2;
fxy=(fx1-fx2)./h;
A=[fxx fxy; fxy fyy];
end