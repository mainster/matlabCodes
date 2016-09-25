% Programm zirkul_falt1.m zur Untersuchung
% der Erzeugung einer linearen Faltung �ber die 
% zirkul�re Faltung mit Hilfe der FFT

% --------- Eingangssequenz x
Ny = 12;
y = randn(1, Ny);

% --------- Impulsantwort h des Filters
Nx = 8;                      % Nh <= Nx
x = fir1(Nx-1, 0.4/2);

% --------- Faltung �ber conv
cxy = conv(x,y);

figure(1);      clf;
subplot(221), stem(0:Ny-1, y);
title('Sequenz y');
subplot(222), stem(0:Nx-1, x);
title('Sequenz x');
subplot(212), stem(0:length(cxy)-1, cxy);
title('Korrekte lineare Faltung y*x mit conv');

% -------- Faltung �ber die FFT
Nfft = Nx + Ny - 1;
X = fft(x, Nfft);
Y = fft(y, Nfft);       

XY = X.*Y;
cxy_dft = real(ifft(XY));

figure(2);      clf;
subplot(211), stem(0:length(cxy)-1, cxy);
title('Korrekte lineare Faltung mit conv');
subplot(212), stem(0:length(cxy_dft)-1, cxy_dft);
title('Faltung ueber DFT');

% -------- Die L�nge eine ganze Potenz von 2
Nfft = Nx + Ny - 1;
Nfft = 2^(nextpow2(Nfft));

X = fft(x, Nfft);
Y = fft(y, Nfft);       

XY = X.*Y;
cxy_dft = real(ifft(XY));

figure(3);      clf;
subplot(211), stem(0:length(cxy)-1, cxy);
title('Korrekte lineare Faltung mit conv');
subplot(212), stem(0:length(cxy_dft)-1, cxy_dft);
title('Faltung ueber DFT');

