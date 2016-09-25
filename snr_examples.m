%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SNR computation examples from MATLAB help      @@@MDB 24-06-2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Signal-to-Noise Ratio for Rectangular Pulse with Gaussian Noise 
% Compute the signal-to-noise ratio (SNR) of a 20 ms rectangular pulse
% sampled for 2 s at 10 kHz in the presence of Gaussian noise. Set the
% random number generator to the default settings for reproducible results.

rng default
Tpulse = 20e-3;
Fs = 10e3;
t = -1:1/Fs:1;
x = rectpuls(t,Tpulse);
y = 0.00001*randn(size(x));
s = x + y;
pulseSNR = snr(x,s-x)


%% Compare SNR with THD and SINAD
% Compute and compare the signal-to-noise ratio (SNR), the total harmonic
% distortion (THD), and the signal to noise and distortion ratio (SINAD) of
% a signal.
% 
% Create a sinusoidal signal sampled at 48 kHz. The signal has a
% fundamental of frequency 1 kHz and unit amplitude. It additionally
% contains a 2 kHz harmonic with half the amplitude and additive noise with
% variance 0.12. Set the random number generator to the default settings
% for reproducible results.

rng default
fs = 48e3;
t = 0:1/fs:1-1/fs;
A = 1.0; powfund = A^2/2;
a = 0.4; powharm = a^2/2;
s = 0.1; varnoise = s^2;
x = A*cos(2*pi*1000*t) + ...
    a*sin(2*pi*2000*t) + s*randn(size(t));
 
% Verify that SNR, THD, and SINAD agree with their definitions.

SNR = snr(x);
defSNR = 10*log10(powfund/varnoise);
SN = [SNR defSNR]

THD = thd(x);
defTHD = 10*log10(powharm/powfund);
TH = [THD defTHD]

SINAD = sinad(x);
defSINAD = 10*log10(powfund/(powharm+varnoise));
SI = [SINAD defSINAD]

%% Noise Power
% Compute the noise power in the sinusoid from the preceding example.
% Verify that it agrees with the definition. Set the random number
% generator to the default settings for reproducible results.

rng default
fs = 48e3;
t = 0:1/fs:1-1/fs;
A = 1.0; powfund = A^2/2;
a = 0.4; powharm = a^2/2;
s = 0.1; varnoise = s^2;
x = A*cos(2*pi*1000*t) + ...
    a*sin(2*pi*2000*t) + s*randn(size(t));
[SNR, npow]=snr(x,fs);
[10*log10(powfund)-npow SNR]

%% Signal-to-Noise Ratio of a Sinusoid
% Compute the SNR of a 2.5 kHz sinusoid sampled at 48 kHz. Add white noise
% with standard deviation 0.001. Set the random number generator to the
% default settings for reproducible results.

rng default
Fi = 2500; Fs = 48e3; N = 1024;
x = sin(2*pi*Fi/Fs*(1:N)) + 0.001*randn(1,N);
SNR = snr(x,Fs)


%% SNR of a Sinusoid Using the PSD
% Obtain the periodogram power spectral density (PSD) estimate of a 2.5 kHz
% sinusoid sampled at 48 kHz. Add white noise with standard deviation
% 0.00001. Use this value as input to determine the SNR. Set the random
% number generator to the default settings for reproducible results.

rng default
Fi = 2500; Fs = 48e3; N = 1024;
x = sin(2*pi*Fi/Fs*(1:N)) + 0.00001*randn(1,N);
w = kaiser(numel(x),38);
[Pxx, F] = periodogram(x,w,numel(x),Fs);
SNR = snr(Pxx,F,'psd')

%% SNR of a Sinusoid Using the Power Spectrum
% Compute the SNR of the sinusoid from the preceding example, using the
% power spectrum. Set the random number generator to the default settings
% for reproducible results.

rng default
Fi = 2500; Fs = 48e3; N = 1024;
x = sin(2*pi*Fi/Fs*(1:N)) + 0.00001*randn(1,N);
w = kaiser(numel(x),38);
[Sxx, F] = periodogram(x,w,numel(x),Fs,'power');
rbw = enbw(w,Fs);
SNR = snr(Sxx,F,rbw,'power')

%% SNR of Amplified Signal
% Generate a sinusoid of frequency 2.5 kHz sampled at 50 kHz. Reset the
% random number generator. Add Gaussian white noise with standard deviation
% 0.00005 to the signal. Pass the result through a weakly nonlinear
% amplifier. Plot the SNR.

rng default

fs = 5e4;
f0 = 2.5e3;
N = 1024;
t = (0:N-1)/fs;

ct = cos(2*pi*f0*t);
cd = ct + 0.00005*randn(size(ct));

amp = [1e-5 5e-6 -1e-3 6e-5 1 25e-3];
sgn = polyval(amp,cd);

snr(sgn,fs);
