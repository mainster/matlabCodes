% A common use of Fourier transforms is to find the frequency 
% components of a signal buried in a noisy time domain signal. 
% Consider data sampled at 1000 Hz. Form a signal containing a 
% 50 Hz sinusoid of amplitude 0.7 and 120 Hz sinusoid of amplitude 
% 1 and corrupt it with some zero-mean random noise:

% chirp
Fs=1000;
L=1000;
t=[0:1:L-1]*1e-3;
f0=50; f1=100;
y1=chirp(t,f0,1,f1);

p21=figure(21);
plot(t,y1)
title('Chirp Signal time domain')

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y1 = fft(y1,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

p22=figure(22);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y1(1:NFFT/2+1))) 
title('Chirp Signal frequency domain')




Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid

x = 3*sin(2*pi*50*t);% + sin(2*pi*120*t); 
y = x + 2*randn(size(t));     % Sinusoids plus noise

p1=figure(1);
plot(Fs*t(1:50),y(1:50))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')

% It is difficult to identify the frequency components by looking 
% at the original signal. Converting to the frequency domain, the 
% discrete Fourier transform of the noisy signal y is found by 
% taking the fast Fourier transform (FFT):

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

p2=figure(2);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')