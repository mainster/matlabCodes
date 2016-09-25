
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten


fc=1000;
Tc=1/fc;
fs=10e3;
Ts=1/fs;
L=80e6*Tc;
t=[0:1:L-1]*Ts;

s1=sin(2*pi*fc*t);
s2=chirp(t,500,L*Ts,2000);

s3=sin(2*pi*500*t);
for k=501:1:2000
    s3=s3+sin(2*pi*k*t);
end

s3x2=interp1(t,s3,[0:0.5:L-1]*Ts);

S1 = fft(s1,L);
S1amp = abs(S1);
S1ampshift=fftshift(S1amp/L);

S2 = fft(s2,L);
S2amp = abs(S2);
S2ampshift=fftshift(S2amp/L);

S3 = fft(s3,L);
S3amp = abs(S3);
S3ampshift=fftshift(S3amp/L);

S3x2 = fft(s3x2,L);
S3x2amp = abs(S3x2);
S3x2ampshift=fftshift(S3x2amp/L);

S3x2L2 = fft(s3x2,2*L);
S3x2L2amp = abs(S3x2L2);
S3x2L2ampshift=fftshift(S3x2L2amp/(2*L));

NFFT=2^nextpow2(length(s3x2));
S3x2pow2 = fft(s3x2,NFFT);
S3x2pow2amp = abs(S3x2pow2);
S3x2pow2ampshift=fftshift(S3x2pow2amp/(NFFT));

tickf = fs/2*linspace(-1,1,L);
tickfx2 = 2*fs/2*linspace(-1,1,L);
tickfx2L2 = 2*fs/2*linspace(-1,1,2*L);
tickfx2pow2 = 2*fs/2*linspace(-1,1,NFFT);

df=fs/L;
dfx2=2*fs/L;

f6=figure(6);


% h.f = figure; 
% plot(rand(1,10)); 
% grid on; 
% h.a=gca; 

subplot(321);
plot(tickf*1e-3,10*log10(S1ampshift));grid on; 
title('Spektrum der kompl. Schwingung mit nicht- idealem Verlauf')
xlabel('Frequenz (kHz)')
ylabel('| Fcmpx(f) | ')
title(['fc =' num2str(fc,'%.d') ' Hz'...
       '   fs = ' num2str(fs,'%.d') ...
       '   Ts = 0' ...
       '   length(vect) = ' num2str(length(s1),'%.3e')...
       ])
   
subplot(322);
plot([-fs:df:fs-df]*1e-3,10*log10([S3amp S3amp]));grid on; 
title('Spektrum der kompl. Schwingung mit nicht- idealem Verlauf')
xlabel('Frequenz (kHz)')
ylabel('| Fcmpx(f) | ')
title(['fc =' num2str(fc,'%.d') ' Hz'...
       '   fs = ' num2str(fs,'%.3e') ...
       '   Ts = ' num2str(1/fs,'%.3e')...
       '   length(vect) = ' num2str(length([S3amp S3amp]),'%.3e')...
       '   NFFT = ' num2str(length(S3),'%.3e')...
       ])
ylim([-150 0]); 
   
subplot(324);
plot(tickfx2*1e-3,10*log10(S3x2ampshift));grid on; 
title('Spektrum der kompl. Schwingung mit nicht- idealem Verlauf')
xlabel('Frequenz (kHz)')
ylabel('| Fcmpx(f) | ')
title(['fc =' num2str(fc,'%.d') ' Hz'...
       '   fs = ' num2str(2*fs,'%.3e') ...
       '   Ts = ' num2str(1/2/fs,'%.3e')...
       '   length(vect) = ' num2str(length(s3x2),'%.3e')...
       '   NFFT = ' num2str(length(S3x2),'%.3e')...
       ])
ylim([-150 0]); 

subplot(325);
plot(tickfx2pow2*1e-3,10*log10(S3x2pow2ampshift));grid on; 
title('Spektrum der kompl. Schwingung mit nicht- idealem Verlauf')
xlabel('Frequenz (kHz)')
ylabel('| Fcmpx(f) | ')
title(['fc =' num2str(fc,'%.d') ' Hz'...
       '   fs = ' num2str(2*fs,'%.3e') ...
       '   Ts = ' num2str(1/2/fs,'%.3e')...
       '   length(vect) = ' num2str(length(s3x2),'%.3e')...
       '   NFFT = ' num2str(length(S3x2pow2),'%.3e')...
       ])
%ylim([-150 0]); 

subplot(326);
plot(tickfx2L2*1e-3,10*log10(S3x2L2ampshift));grid on; 
title('Spektrum der kompl. Schwingung mit nicht- idealem Verlauf')
xlabel('Frequenz (kHz)')
ylabel('| Fcmpx(f) | ')
title(['fc =' num2str(fc,'%.d') ' Hz'...
       '   fs = ' num2str(2*fs,'%.3e') ...
       '   Ts = ' num2str(1/2/fs,'%.3e')...
       '   length(vect) = ' num2str(length(s3x2),'%.3e')...
       '   NFFT = ' num2str(length(S3x2L2),'%.3e')...
       ])
ylim([-150 0]); 
