% Programm detrend_1.m in dem gezeigt wird, was die 
% Funktionen detrend bewirken

% -------- Daten mit Trendwert und Mittelwert verschieden von null
N = 500;
n = 0:N-1;
noise = 1;

u = sin(2*pi*n/N) + sqrt(noise)*randn(1,N); % Eingangssignal mit Sinus-Mittelwert 
nf = 20;
y = filter(ones(1,nf)/nf,1,u);      % Ausgangssignal als gleitender Mittelwert

u = u';
y = y';
z = [y, u];

% ------- Die Funktion detrend, um lineare Trends zu entfernen
u_d = detrend(u);
y_d = detrend(y);

% ------- Ermittlung des linearen Trends mit der Funktion regress
x = [ones(N,1), n'];
bu = regress(u, x);
by = regress(y, x);

ul = bu(1) + bu(2)*n;
yl = by(1) + by(2)*n;

figure(1);      clf;
subplot(221), plot(n, [u, ul']);
title('u mit und ohne Trend');
La = axis;     axis([0, N-1, La(3:4)]);
subplot(223), plot(n, u_d');
La = axis;     axis([0, N-1, La(3:4)]);

subplot(222), plot(n, [y, yl']);
title('y mit und ohne Trend');
La = axis;     axis([0, N-1, La(3:4)]);
subplot(224), plot(n, y_d);
La = axis;     axis([0, N-1, La(3:4)]);

% ------- Die Funktion detrend mit Stützpunkten
u_d = detrend(u,'linear',[1, fix(N/4), 2*fix(N/4), 3*fix(N/4), N]);
y_d = detrend(y,'linear',[1, fix(N/4), 2*fix(N/4), 3*fix(N/4), N]);

figure(2);      clf;
subplot(221), plot(n, u);
title('u mit und ohne Trend');
La = axis;     axis([0, N-1, La(3:4)]);
subplot(223), plot(n,u_d);
La = axis;     axis([0, N-1, La(3:4)]);

subplot(222), plot(n, y);
title('y mit und ohne Trend');
La = axis;     axis([0, N-1, La(3:4)]);
subplot(224), plot(n,y_d);
La = axis;     axis([0, N-1, La(3:4)]);

