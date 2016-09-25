% Experiment (my_mesh1.m) zur Funktion mesh

x = -10:10;                      y = -15:15;
[X,Y] = meshgrid(x,y);
R = sqrt(X.^2+Y.^2)+eps;         Z = sin(R)./R;

figure(1);      clf;
subplot(221), mesh(X,Y,Z);
xlabel('x');     ylabel('y');      zlabel('z');
title('3D-Sinc (mesh)');
view(-40, 15);

subplot(222), surf(X,Y,Z);
xlabel('x');     ylabel('y');      zlabel('z');
title('3D-Sinc (surf)');
view(-40, 15);

subplot(223), surf(X,Y,Z);
xlabel('x');     ylabel('y');      zlabel('z');
title('3D-Sinc (surf & shadig flat)');
view(-40, 15);
shading flat

subplot(224), surf(X,Y,Z);
xlabel('x');     ylabel('y');      zlabel('z');
title('3D-Sinc (surf & shading interp)');
view(-40, 15);
shading interp
