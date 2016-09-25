% Skript fft_objekt1.m, in dem die FFT als Objekt angewandt 
% wird
clear;
% ------- Signal 
Fs = 800; L = 1000; 
t = (0:L-1)'/Fs; 
x = sin(2*pi*250*t) + 0.75*cos(2*pi*340*t); % Deterministischer Teil
y = x + .5*randn(size(x)); % noisy signal
% ------- FFT-Objekt 
hfft = dsp.FFT('FFTImplementation','Radix-2','FFTLengthSource',...
    'Property', 'FFTLength', 1024);
Y = step(hfft, y);   % Hier wird die FFT berechnet

% Plot the single-sided amplitude spectrum
figure(1);     clf;
plot(Fs/2*linspace(0,1,512), 2*abs(Y(1:512)/1024));
title('Single-sided amplitude spectrum of noisy signal y(t)');
xlabel('Frequency (Hz)'); ylabel('|Y(f)|');

% ------- Klassische Art
Ykl = fft(y, 1024);
figure(2);     clf;
plot(Fs/2*linspace(0,1,512), 2*abs(Ykl(1:512)/1024));
title('Single-sided amplitude spectrum of noisy signal y(t)');
xlabel('Frequency (Hz)'); ylabel('|Y(f)|');

% ------ Matrix-Signal
xk = zeros(L,4);
yk = xk;
for k = 1:4
     xk(:,k) = sin(2*pi*k*50*t) + 0.75*cos(2*pi*k*40*t); % Deterministischer Teil
     yk(:,k) = xk(:,k) + .5*randn(L,1); % noisy signal
end;
hfft = dsp.FFT;
Yk = step(hfft, [yk; zeros(24,4)]);  % Die Länge der Sequenzen 
% muss eine 2. Potenz sein
figure(3);     clf;
plot(Fs/2*linspace(0,1,512), 2*abs(Yk(1:512,:)/1024));
title('Single-sided amplitude spectrum of noisy signal y(t)');
xlabel('Frequency (Hz)'); ylabel('|Y(f)|');
