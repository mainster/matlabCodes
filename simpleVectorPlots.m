% Einfache Vektoren / Ebenen plotten
%
delete(findall(0,'type','line'))    % Inhalte der letzten plots löschen, figure handle behalten
delete(findall(0,'type','surface'))    % Inhalte der letzten plots löschen, figure handle behalten
clc;


% 3D- Ortsvektor:
% ersten Spalte x-Werte
% zweite Spalte y-Werte
% dritte Spalte z-Werte
v1=[0 0 0; 5 5 5];  
v2=[0 0 0; 5 0 5];  

% Ebene
%
%f1=@(x,y) -1/5*x.^2-1/5*y.^2+3;
my=[-0.5:0.1:2.5];
mx=[-3:0.1:3];
[x y] = meshgrid (mx,my);

x0=-2; y0=1;
teS=[2,2];  % x und y kantenlange der tangentialebene
mxt=[x0-teS(1)/2:0.1:x0+teS(1)/2];
myt=[y0-teS(2)/2:0.1:y0+teS(2)/2];
[xt yt] = meshgrid (mxt,myt);

f0=f2(x0,y0);
[fx fy]=gradientSelf(@f2, x0,y0);
te=f0+fx*(xt-x0)+fy*(yt-y0);

fig1=figure(1);
hold on
surf(x,y,f2(x,y));
colormap hsv;
freezeColors;

surf(xt,yt,te);
colormap gray;


plot3(x0,y0,f2(x0,y0),'ro','MarkerSize',10,'MarkerFaceColor','r')
hold off;
view(3)
grid on;
%axis equal;
LIM=[-10 10];
ylim([-0.5 2.5]);xlim([-3 3]);zlim([-30 15]);
xlabel('x --->');
ylabel('y --->');
zlabel('z --->');


LIM2=[0 5];
p1=[1 0.5 0];
p2=[3 2 4];
fig2=figure(2);
plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)],'-r<');grid on;
axis equal;
xlim(LIM2);ylim(LIM2);zlim(LIM2);

arr=sort(findall(0,'type','figure'));
delete(arr(2:end))

% x=0:0.1:1;
% y=0:0.1:1;
% [X,Y]=meshgrid(x,y);
% Z=3-x+5*y;
% Z2 = repmat(Z,length(y),1);
% fig3=figure(3);
% surf(X,Y,Z);

