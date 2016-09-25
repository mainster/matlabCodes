% Gradient bilden

[x y] = meshgrid (-5:0.2:5);
x0=2; y0=-1;
surf(x,y,f(x,y))
