% Experiment (my_log3.m) für plot3 mit logarithmischer
% z-Achse

%------- 3D-Funktion
t = 0.01:0.002:1;

x = cos(2*pi*t/0.15).*exp(-t/0.5);
y = sin(2*pi*t/0.15).*exp(-t/0.5);
z = t;

subplot(121), plot3(x,y,z);
view([125, 7]);        grid;
title('Lineare z-Achse');
xlabel('x');    ylabel('y');     zlabel('z');
set(gca,'ZScale','linear');

subplot(122), plot3(x,y,z);
view([125, 7]);        grid;
title('Logarithmische z-Achse');
xlabel('x');    ylabel('y');     zlabel('z');
set(gca,'ZScale','log');



