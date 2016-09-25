% Experiment (my_cont1.m) zur Funktion contour

%------- 3D-Funktion mit zwei Höcker
x = -2:0.2:2;                y = -2:0.2:2;
[X,Y] = meshgrid(x,y);
Z = X.*exp(-X.^2 -Y.^2);

%------- Verschiedene Darstellungen
figure(1);     clf;
subplot(221), surfc(X,Y,Z);
title('surfc-Funktion');
xlabel('x');   ylabel('y');   zlabel('z');

subplot(222), surfl(X,Y,Z,[-45, 30]);
title('surfl-Funktion');
xlabel('x');   ylabel('y');   zlabel('z');

subplot(223), 
C = contour(X,Y,Z,4,'-');
clabel(C);
title('contour-Funktion');
xlabel('x');   ylabel('y');   zlabel('z');

subplot(224), 
C = contour(X,Y,Z,[-0.5:0.1:0.5],'-');
clabel(C);
title('contour-Funktion [-0.5:0.1:0.5]');
xlabel('x');   ylabel('y');   zlabel('z');
