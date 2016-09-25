% Programm korrelat1.m zur Untersuchung
% der Erzeugung der Kreuzkorrelation mit Hilfe der FFT

% -------- Eingangssignal
Nx = 256;
x1 = randn(1, Nx);

% -------- Verspätetes Signal
nd = 50;         % Verspätung
x2 = [randn(1, nd), x1(1:Nx-nd)];

% -------- Korrelation über die FFT
X1 = fft(x1, Nx);
X2 = fft(x2, Nx);

X1X2 = conj(X1).*(X2);

x1_x2 = real(ifft(X1X2));

figure(1);    clf;
subplot(311), plot(0:Nx-1, x1);
title('Sequenz x1');
grid;
subplot(312), plot(0:Nx-1, x2);
title('Sequenz x2');
grid;
subplot(313), plot(0:Nx-1, x1_x2);
title('iff(conj(X1).*X2)');
xlabel('n');     grid;


