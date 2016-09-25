%% DC-Centered Power Spectrum
% Create a signal consisting of a 100 Hz sinusoid in additive  $N(0,1/4)$
% white noise. Reset the random number generator for reproducible results.
% The sample rate is 1 kHz and the signal is 5 seconds in duration.

rng default

fs = 1000;
t = 0:1/fs:5-1/fs;

noisevar = 1/4;
x = cos(2*pi*100*t)+sqrt(noisevar)*randn(size(t)); 
% Obtain the DC-centered power spectrum using Welch's method. Use a segment
% length of 500 samples with 300 overlapped samples and a DFT length of 500
% points. Plot the result.

[pxx,f] = pwelch(x,500,300,500,fs,'centered','power');

f1=figure(1);
SUB=310;

su(1) = subplot(SUB+1);
plot(f,10*log10(pxx));
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
%%

FMMOD = comm.FMModulator % FM modulate
FMDEMOD = comm.FMDemodulator  % FM demodulate
load handel % Load a snippet of Handel's Hallelujah Chorus.
yFM = step(FMMOD,y);
yDemod = step(FMDEMOD,yFM );

[pxx2,f2] = pwelch(yFM);
[pxx3,f3] = pwelch(y);

su(2) = subplot(SUB+2);
%plot(f,10*log10(pxx)); hold all;
plot(f2,10*log10(pxx2)); hold all;
plot(f3,10*log10(pxx3)); hold off;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
legend('pxx sin...','pwelch(yFM)','pwelch(y)')