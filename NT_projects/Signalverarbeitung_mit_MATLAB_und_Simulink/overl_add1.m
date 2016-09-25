% Programm overl_add1.m in dem die lineare Faltung
% über die mit Nullwerten erweiterte DFT ermittelt wird

N = 50;
M = 10;

x = randn(1,N); % Sequenz der LäŠnge N
h = ones(1,M);  % Einheitspulsantwort der LäŠnge M

yl = conv(x,h); % Lineare Faltung

L = M+N-1;

Xe = fft(x, L); % DFT der erweiterten Sequenz x
He = fft(h, L); % DFT der erweiterten Sequenz h

ylfft = real(ifft(Xe.*He)); % lineare Faltung Ÿber DFT

figure(2),   clf;
subplot(211), stem(0:length(yl)-1, yl);
title('Lineare Faltung mit conv');
xlabel('n');    grid on;

subplot(212), stem(0:length(ylfft)-1, ylfft);
title('Lineare Faltung ueber die DFT');
xlabel('n');    grid on;