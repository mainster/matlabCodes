% Shanon Nyquist Abtasttheorem
%

Fsam = 1000;                   % Sampling frequency, timevector ticks/s
Tsam = 1/Fsam;                 % Sample time
L=Fsam*10;                     % Length of Signal is 100samples * 10sec

%t=(0:L-1)*Tsam;
t=(1:L)*Tsam;

x = 0.7*sin(2*pi*50*t) + 0.1*sin(2*pi*120*t); 
%y = x ;%+ 2*randn(size(t));     % Sinusoids plus noise

t0 = 2;     % um 2sec!!! verschieben
y=x;
y=sinc(2*pi*30*(t-t0));

p1=figure(1);
%plot(Fsam*t(0.5:2.5),Fsam*y(0.5:2.5))
plot(t(1800:2200),y(1800:2200));
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')
grid on;
% It is difficult to identify the frequency components by looking 
% at the original signal. Converting to the frequency domain, the ubu
% discrete Fourier transform of the noisy signal y is found by 
% taking the fast Fourier transform (FFT):
window = blackman(L);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
fsing = Fsam/2*linspace(0,1,NFFT/2+1);
fdual = Fsam/2*linspace(-1,1,NFFT);

Y = fft(y.'.*window,NFFT)/(L);
Y = Y/max(abs(Y)); % Normierung
Y_dB = 10*log10(abs([Y(end/2:end);Y(1:end/2-1)]).^2);


p2=figure(2);
% Plot single-sided amplitude spectrum.
plot(fsing,2*abs(Y(1:NFFT/2+1))) 
grid on;
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

p3=figure(3);
% Plot double-sided amplitude spectrum.
plot(fdual,2*abs(Y(1:NFFT))) 
grid on;
title('Double-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

p4=figure(4);
% Plot double-sided amplitude spectrum normiert, in db.
plot(fdual,Y_dB) 
grid on;
title('normiertes Leistungsdichtespektrum \phi(f)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Fsam = 1000;                   % Sampling frequency, timevector ticks/s
% Tsam = 1/Fsam;                 % Sample time
% L=Fsam*10;                     % Length of Signal is 100samples * 10sec
% 
% %t=(0:L-1)*Tsam;
% t=(1:L)*Tsam;
% 
% window = blackman(L);
% 
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% fsing = Fsam/2*linspace(0,1,NFFT/2+1);
% fdual = Fsam/2*linspace(-1,1,NFFT);
% 

%rc=[1:length(t)];
%rc=RaisedCosShaper(t-5,0.3,0.1,'time');
rc=RaisedCosShaper(t-3,0.1,0.05,'time')+RaisedCosShaper(t-6,0.1,0.05,'time');
rc = rc.';

RC = fft(rc.*window,NFFT)/(L);
RC = RC/max(abs(RC)); % Normierung
RC_dB = 10*log10(abs([RC(end/2:end);RC(1:end/2-1)]).^2);

p5=figure(5);
subplot(2,1,1);
plot(t,rc)
grid on
subplot(2,1,2);
grid on
plot(fdual,RC_dB)
grid on
xlim([-20,20]);

