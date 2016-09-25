% Richtungsableitung
% Skript S.95
%
delete(findall(0,'type','line'))    % Inhalte der letzten plots löschen, figure handle behalten
clc;

x0=1;
y0=2;

f1= @(x,y) x.^2-x.*y+y.^2;

[xl yl] = meshgrid (-5:0.1:5);

LIM=[-2 3];

fa=f1(xl,yl);

hold on;
surf(xl,yl,fa);
plot3(x0,y0,f(x0,y0),'ro','MarkerSize',10,'MarkerFaceColor','r')
hold off;
%axis equal;
%xlim(LIM);ylim(LIM);zlim(LIM);
