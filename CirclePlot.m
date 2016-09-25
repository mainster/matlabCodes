%%%%%%%%%%%%%%
% Plot a Circle
%%%%%%%%%%%%%%

f99=figure(99);

r=1.5;              % radius
rv=[-r:0.005:r];    % absciss vektor
shift=-3;           % Shift on abscissa

hold all;
plot(rv,sqrt(r-rv.^2));
plot(rv+shift,sqrt(r-rv.^2));
hold off;
grid on;
set(gca,'DataAspectRatio',[1 1 1]);

