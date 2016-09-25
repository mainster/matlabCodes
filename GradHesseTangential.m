% Gradient, Hesse, Tangentialebene
%
delete(findall(0,'type','line'))    % Inhalte der letzten plots löschen, figure handle behalten
clc;

% Kugel
f1= @(x,y) real(sqrt(4^2-x.^2-y.^2)); 
% Ableitung nach x
f1x= @(x,y) real(-x./sqrt(4^2-x.^2-y.^2));
% Ableitung nach y
f1y= @(x,y) real(-y./sqrt(4^2-x.^2-y.^2));

x0=1;
y0=2;

f1grad= [f1x(x0,y0);f1y(x0,y0)]; 

[x y] = meshgrid (-5:0.1:5);


fa=f1(x,y);
surf(x,y,fa);
% Tangentialebene
% te=f(x0,y0)+transpose(grad(x0,y0))*(x-[x0;y0])
te=f1(x0,y0)+f1grad'*x;
axis equal;