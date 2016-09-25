% AD- DA- Wandlung
%
% Unterscheidung zwischen:
% ideal AD -> ideal DA
% real AD -> ideal DA
% ideal AD -> real DA
% real AD -> real DA

delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten


Ta=100e-3;
fa=1/Ta;
n=1024;   % Anzahl Samples
t1=[0:1:n-1]*Ta;

f0=1;
T0=1/f0;
ys1=sin(2*pi*f0*t1);

p1=figure(1);
subplot(321);
hold on;
plot(t1(1:T0/Ta+1),ys1(1:T0/Ta+1));grid on;
stem(t1(1:T0/Ta+1),ys1(1:T0/Ta+1));grid on;
hold off;

% Plot Spektrum
%
Fs = fa;                    % Sampling frequency
L=n;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Ys1 = fft(ys1,NFFT)/L;

subplot(322);
f = Fs/2*linspace(0,1,NFFT/2+1);
fifull=Fs*linspace(0,1,NFFT);
plot(fifull,10*log10(abs(Ys1)/max(abs(Ys1))),'r');grid on; 
%plot(fifull,(abs(Ys1)/max(abs(Ys1))),'r');grid on; 
title('Spectrum s1(t)')
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['f0 =' num2str(f0,'%.2f') ' Hz'...
       '   fa =' num2str(fa,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta,'%.5f') ' s'...
       '   fa/f0 = ' num2str(fa/f0,'%.3f')...
       '   n Samples: ' num2str(length(t1),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
   
subplot(323);

