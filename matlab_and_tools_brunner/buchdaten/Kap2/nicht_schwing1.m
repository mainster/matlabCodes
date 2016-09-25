function nicht_schwing1(omega0, gamma0, x0, tfinal)
% Funktion nicht_schwing1.m, in der die Differentialgleichung
% eines nichtlinearen Schwingungssystem gelöst wird
%
% Testaufruf: nicht_schwing1(10,1, [0,-2], 10);

global omega gamma

omega = omega0;     gamma = gamma0;

tspan = [0 tfinal];
[t, x] = ode45(@ableit, tspan, x0);

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
function dxdt = ableit(t,x);
global omega gamma
dxdt = [x(2);...
    -(omega^2)*(x(1)-gamma*(x(1)^3))];


