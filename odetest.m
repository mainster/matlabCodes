% http://www.gomatlab.de/dgl-system-loesen-t18928.html
%System von AWP 2 ordnung 
function [dx] = odetest(t,x); 
m1=1; 
m2=0.7; 
c1=1; 
c2=2; 
c3=3; 
k=0.01; 


dx = zeros(4,1); 
dx(1) = x(2); 
dx(2) = -k/m1*(x(4)-x(2))+c2/m1*(x(3)-x(1))-c1/m1*x(1); 
dx(3) = x(4); 
dx(4) = k/m2*(x(4)-x(2))-c2/m2*(x(3)-x(1))-c3/m2*x(3); 
end 