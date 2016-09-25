% Sinus Cardinalis Sinx/x

Fs = 1000;                    % Sampling frequency
Ts = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*Ts;                % Time vector

wind=0.5*(1+sign(t+1/50))-0.5*(1+sign(t-1/50));

p1=figure(1);
plot(t(1:100),wind(1:100))

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(wind,NFFT)/L;
Y2=20*log10(Y);
f = Fs/2*linspace(0,1,NFFT/2+1);
p2=figure(2);
% Plot single-sided amplitude spectrum.
subplot(211);
plot(f,2*abs(Y(1:NFFT/2+1)));grid 
title('Single-Sided Amplitude Spectrum window function')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
subplot(212);
plot(f,real(Y2(1:NFFT/2+1)));grid 
title('Single-Sided Amplitude Spectrum window function in dB')
xlabel('Frequency (Hz)')
ylabel('|Y(f)| [dB]')