% Tangentialebenen
%
fh=@(x,y) sin(x)+cos(y);
delete(findall(0,'type','line'))    % Inhalte der letzten plots löschen, figure handle behalten
delete(findall(0,'type','surface'))    % Inhalte der letzten plots löschen, figure handle behalten
clc;

mx=[-4.9:0.2:4.9];
my=[-4.9:0.2:4.9];
[xma yma] = meshgrid (mx,my);

%my=[-0.5:0.1:2.5];
%mx=[-3:0.1:3];
[xm ym zm] = meshgrid ([0:10],[0:10],[0:10]);
x0=2; y0=3;
teS=[5,5];  % x und y kantenlange der tangentialebene
mxt=[x0-teS(1)/2:0.1:x0+teS(1)/2];
myt=[y0-teS(2)/2:0.1:y0+teS(2)/2];
[xt yt] = meshgrid (mxt,myt);

u=[0:0.01:150];
v=[0:0.01:150];

R=1;
c=2;

% fig1=figure(1);
% hold on;
% %ezplot3('sin(2*pi*t)','cos(2*pi*t)','t',[0,3*pi])
% ezplot3('-sin(2*pi*3)','cos(2*pi*6.1)','3',[0,3*pi],'r')
% 
% hold off;
%ezsurf('u+v+u^2+v^2');
%view(3)
% 
% 
% 
fig1=figure(1);
%plot3(sin(u),cos(v),v);
hold on;
ezsurf('sqrt(49-x^2-y^2)');
ezsurf('-sqrt(49-x^2-y^2)');
ezsurf('(49-2*x-3*y)/6');
hold off;
axis equal;
grid on;
%ezsurf('sin(x)+cos(y)+z')
view(3)


fig5=figure(5);
hold on
surf(xma,yma,sqrt(49-xma.^2-yma.^2));
axis equal;
grid on;
colormap hsv;
freezeColors;

surf(xt,yt,(49-2*xt-3*yt)/6);
colormap gray;
hold off;
xlim([-6 6]);ylim([-6 6]);zlim([0 13]);
view(3);
% 
% fig3=figure(3);
% ezsurf('real(atan(x+i*y))')












