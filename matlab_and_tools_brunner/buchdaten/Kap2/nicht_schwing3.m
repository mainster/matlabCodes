function nicht_schwing3(omega, s, h, x0, tfinal)
% Funktion nicht_schwing3.m, in der die Differentialgleichung
% eines nichtlinearen Schwingungssystem gelöst wird
%
% Testaufruf: nicht_schwing3(10, 1, 0.8, [0,-2], 20);

tspan = [0 tfinal];
my_option = odeset('Jacobian', @Jacob);
[t, x] = ode15s(@ableit, tspan, x0, my_option, omega, s, h);

figure(1);      clf;
subplot(121), plot(x(:,1), x(:,2));
title('Phasenkurve (x'' nach x)');
ylabel('x''');     xlabel('x');

subplot(222), plot(t, x(:,1));
title('Lage');

subplot(224), plot(t, x(:,2));
title('Geschwindigkeit');
xlabel('Zeit in s');

% --------- Nichtlineare Funktion
figure(2);      clf;
xq = -2:0.1:2;
fq = (omega^2)*xq.*(1-s./sqrt(h^2+xq.^2));
plot(xq, fq);
grid;
% -------------------------------
function dxdt = ableit(t, x, omega, s, h);
dxdt = [x(2);...
    -(omega^2)*x(1)*(1-s/sqrt(h^2+x(1)^2))];

% -------------------------------
function dfdx = Jacob(t, x, omega, s, h);
dfdx = [0, 1; ...
 -(omega^2)*(1-s/sqrt(h^2+x(1)^2))-(omega^2)*x(1)*(s*x(1)*(h^2+x(1)^2)^(-3/2)), 0];

