function  y = piecewise3(x)
% first range
y(find(x <= -4)) = 3; 

% second range
x2 = x(-4 < x & x <= -3);
y(find(-4 < x & x <= -3)) = -4*x2 - 13; 

% third range
x3 = x(-3 < x & x <= 0);
y(find(-3 < x & x <= 0)) = x3.^2 + 6*x3 + 8; 

% fourth range
y(find(0 < x)) = 8;
