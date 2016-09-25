%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bandpower Measure the Power of a Signal
% http://de.mathworks.com/help/signal/ug/measure-the-power-of-a-signal.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The power of a signal is the sum of the absolute squares of its time-domain
% samples divided by the signal length, or, equivalently, the square of its RMS
% level. The function bandpower allows you to estimate signal power in one step.
%
% Die Leistung eines Signals ist die Summe der absoluten Quadrate seiner
% Abtastwerte im Zeitbereich geteilt durch die Signallänge, oder äquivalent dem
% Quadrat seines Effektivwerts. Die Funktion Bandpower ermöglicht es Ihnen,
% Signalleistung in einem Schritt zu schätzen.

% Consider a unit chirp embedded in white Gaussian noise and sampled at 1 kHz
% for 1.2 seconds. The chirp's frequency increases in one second from an initial
% value of 100 Hz to 300 Hz. The noise has variance  $0.01^2$. Reset the random
% number generator for reproducible results.
%
% Betrachten Sie eine Einheit Chirp in weißes Gaußsches Rauschen eingebettet
% sind und bei 1 kHz für 1,2 Sekunden abgetastet. Das Chirpen der Frequenz
% zunimmt in einer Sekunde von einem Anfangswert von 100 Hz bis 300 Hz. Der Lärm
% hat Varianz 0,01 $ ^ 2 $. Setzen Sie den Zufallszahlengenerator für
% reproduzierbare Ergebnisse.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 1200;
Fs = 1000;
t = (0:N-1)/Fs;

f1 = figure(1);
SUBS=220;

sigma1 = 0.01;
sigma2 = 0;
%rng('default')

s = chirp(t,180,1,300) + sigma1*randn(size(t));
s2 = chirp(t,180,1,300) + sigma2*randn(size(t));
%s = chirp(t,100,1,300); 
%s = sinc(t);
subplot(SUBS+1);
plot(t,s);
subplot(SUBS+3);
plot(t,s2);
%% Verify that the power estimate given by bandpower is equivalent to the
% definition.
pRMS = rms(s)^2;
powbp = bandpower(s,Fs,[0 Fs/2]);

%% Use the obw function to estimate the width of the frequency band that contains
% 99% of the power of the signal, the lower and upper bounds of the band, and
% the power in the band. The function also plots the spectrum estimate and
% annotates the occupied bandwidth.
subplot(SUBS+2);
obw(s,Fs)
subplot(SUBS+4);
obw(s2,Fs)

[wd,lo,hi,power] = obw(s,Fs);
powtot = power/0.99

return
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% awgn() power spectral density
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));
%clear all; close all; startup

fs = 50e3;
Ts=1/fs;
tt = 0:Ts:3-Ts;

noise(:,1) = randn(size(tt));
noise(:,2) = rand(size(tt));
noise(:,3) = wgn(length(tt),1,0);
%%
x = cos(2*pi*tt*1.24e3)+ cos(2*pi*tt*10e3)+ randn(size(tt));

nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/fs;

% Create a single-sided spectrum
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',fs);  
f1=figure(1);
SUB=230;

bins=20;
subplot(SUB+1)
hist(noise(:,1),bins);
legend('randn(size(tt))')
title(sprintf('bandpower = \n%g', bandpower(noise(:,1))));

subplot(SUB+2)
hist(noise(:,2),bins)
legend('rand(size(tt))')

subplot(SUB+3)
hist(noise(:,3),bins)
legend('wgn(length(tt),1,0)')

subplot(SUB+4)
plot(Pxx)

subplot(SUB+5)
plot(Hpsd)

%%
% pwr specifies the power of nt in dB relative to a watt
pwr=0;
% 1e4 samples of white gausian noise
nt=wgn(1e4,1,pwr);   