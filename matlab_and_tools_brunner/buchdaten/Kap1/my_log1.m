% Experiment (my_log1.m) mit logarithmischen 
% Koordinaten

%------- Parameter des Quarzes
Cs = 20e-12;       Cp = 30e-12;
L = 10e-6;         Rs = 1;

%------- Frequenzbereich Bestimmung
f0 = 1/sqrt(Cs*L)/(2*pi);      % Reihenresonanz
amin = fix(log10(f0/10));      amax = ceil(log10(f0*10));

%f = linspace(10^amin, 10^amax, 200);
f = logspace(amin, amax, 200);
w = 2*pi*f;

%------- Impedanz
Z1 = 1./(j*w*Cs)+j*w*L+Rs;     Z2 = 1./(j*w*Cp);
Z = (Z1.*Z2)./(Z1+Z2);

%------- Darstellungen
figure(1);
subplot(221),  plot(f,abs(Z),'.','MarkerSize',12);
title('plot(x,y)');
xlabel('Hz');     ylabel('Ohm');     grid;
hold on;
plot(f,abs(Z));
hold off;

subplot(222),  semilogx(f,abs(Z),'.','MarkerSize',12);
title('semilogx(x,y)');
xlabel('Hz');     ylabel('Ohm');     grid;
hold on;
semilogx(f,abs(Z));
hold off;

subplot(223),  semilogy(f,abs(Z),'.','MarkerSize',12);
title('semilogy(x,y)');
xlabel('Hz');     ylabel('Ohm');     grid;
hold on;
semilogy(f,abs(Z));
hold off;

subplot(224),  loglog(f,abs(Z),'.','MarkerSize',12);
title('loglog(x,y)');
xlabel('Hz');     ylabel('Ohm');     grid;
hold on;
loglog(f,abs(Z));
hold off;
