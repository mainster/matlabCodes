Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time 
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector 

% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid

x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
y = x + 2*randn(size(t));     % Sinusoids plus noise
plot(Fs*t(1:50),y(1:50)) 
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)') 

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L; 
f = Fs/2*linspace(0,1,NFFT/2+1);

fe=figure(66);

subplot(311)
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sinus sweep
Fs=1000;
T=1/Fs;
L=1000;
time=[0:L-1]*T;
f0=0; f1=50;
yChirp=chirp(time,f0,L*T,f1);
ysi=1000*sinc((time-length(time)/4)*100);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Ychirp = fft(yChirp,NFFT)/L; 
Ysi = fft(ysi,NFFT)/L; 
f = Fs/2*linspace(0,1,NFFT/2+1);

subplot(312);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Ychirp(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

subplot(313);
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Ysi(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')


