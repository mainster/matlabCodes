% Programm lagrange_int1.m zur Interpolation mit 
% Lagrange-FIR-Filter und Simulation mit
% Modell lagrange_int_1.mdl

% -------- Interpolation mit Lagrange-Polynome
L = 10;
N = 5;
b = intfilt(L, N, 'Lagrange'); % Lagrange-FIR-Filter
nb = length(b);
 
figure(1),    clf;
subplot(211), stem(0:nb-1,b);
title('Einheitspulsantwort des Filters');
grid;   xlabel('n');

nfft = 1024;
Hb = fft(b, nfft);
subplot(212), plot((0:nfft-1)/nfft, 20*log10(abs(Hb)));
title('Amplitudengang des Filters');
grid;   xlabel('f/fs');

% --------- Interpolation einer bandbegrenzten Sequenz
% Bandbegrenzte Sequenz
ns = 100;
randn('state', 12567);
hTP = fir1(40, 0.5);

x = filter(hTP,1,randn(ns, 1)); % Sequenz
nx = length(x);
 
% Expandierung mit Nullstellen
xr = zeros(nx*L,1);
xr(1:L:end) = x;      % oder
% xr = reshape([x, zeros(length(x), L-1)]', L*length(x), 1); 

% Interpolation
y = filter(b,1,xr);
ny = length(y);
 
figure(2);     clf;
ndelayx = 1 + round((N+1)/2);
ndelayy = 11;      % Muss man einstellen

x = [zeros(ndelayx,1); x];
y = [zeros(ndelayy,1); y];
nx = length(x);
ny = length(y);

subplot(211), 
plot((0:nx-1)*L, x, 'o',0:ny-1,y);
title('Ursprüngliches und interpoliertes Signal');
xlabel('n*L'); grid;  axis tight;

% ------- Parameter füŸr das Modell lagrange_int_1.mdl
fs = 1000;
fb = 200;
Ts = 1/fs;

% ------- Aufruf der Simulation
sim('lagrange_int_1',[0,1]);


