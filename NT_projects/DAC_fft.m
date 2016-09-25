Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid 
x = 3*sin(2*pi*50*t);% + sin(2*pi*120*t); 
y=x;

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generierung von csv files im LTSpice PWL- Format
%

t=[0:1000-1].';     % 100ms funktion mit 100us Ts
f=sin(2*pi*10*t/1000);
tf=[t f];

% Weil LTSpice die werte zwischen zwei Zeitschritten Interpoliert,
% ist im Plot von LTSpice keine Treppenfunktion sichtbar

% Um eine Treppe zu erhalten, musst du die Sprünge mit einem zweiten Punkt 
% kontrollieren.
% 
% 0.0000ms 0.0000V
% 0.024499ms 0.0000V
% 0.0245ms 0.1227V
% 0.049099ms 0.1227V
% 0.0491ms 0.2453V
% 0.073599ms 0.2453V
% 0.0736ms 0.3678V

t2=[0:0.5:1000-0.5].';     
t2k=[0:0.5:1000-0.5];
t2k=t2k*0.999999;

t2k=t2k.';

for k=2:2:length(t2)-2
    t2(k)=t2k(k+1);
end


f2=[0:length(t2)-1].';

j=1;
for k=1:length(f)-1
    f2(j)=f(k);
    j=j+1;
    f2(j)=f2(j-1);
    j=j+1;
end

t2=t2/1e3;     % Zeitvektor auf 1sec normieren
f2(end-1)=0;
f2(end)=0;
tf2=[t2 f2];

p4=figure(4);
plot(t2,f2);

wind=0.5*(1+sign(t+20*T/2))-0.5*(1+sign(t-20*T/2));
%p3=figure(3);
%plot(t(1:50),wind(1:50))
%con=conv(y,wind);
%p4=figure(4);

Fs = 2000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 2000;                     % Length of signal
t = (0:L-2)*T;                % Time vector

wind=0.5*(1+sign(t+100*T/2))-0.5*(1+sign(t-100*T/2));

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(wind,NFFT)/L;
Y2=20*log10(Y);
f = Fs/2*linspace(0,1,NFFT/2+1);
p5=figure(5);
% Plot single-sided amplitude spectrum.
subplot(211);
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum window function')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
subplot(212);
plot(f,real(Y2(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum window function in dB')
xlabel('Frequency (Hz)')
ylabel('|Y(f)| [dB]')

