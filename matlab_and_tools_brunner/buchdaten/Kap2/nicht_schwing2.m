function nicht_schwing2(omega, gamma, x0, tfinal)
% Funktion nicht_schwing2.m, in der die Differentialgleichung
% eines nichtlinearen Schwingungssystem gelöst wird
%
% Testaufruf: nicht_schwing2(10, 1, [0,-2], 10);

tspan = [0 tfinal];
my_option = odeset('Jacobian', @Jacob);
[t, x] = ode15s(@ableit, tspan, x0, my_option, omega, gamma);

figure(1);      clf;
subplot(121), plot(x(:,1), x(:,2));
title('Phasenkurve (x'' nach x)');
ylabel('x''');     xlabel('x');

subplot(222), plot(t, x(:,1));
title('Lage');

subplot(224), plot(t, x(:,2));
title('Geschwindigkeit');
xlabel('Zeit in s');

% -------------------------------
function dxdt = ableit(t, x, omega, gamma);
dxdt = [x(2);...
    -(omega^2)*(x(1)-gamma*(x(1)^3))];

% -------------------------------
function dfdx = Jacob(t, x, omega, gamma);
dfdx = [0, 1; -(omega^2)*(1+gamma*3*(x(1)^2)), 0];

