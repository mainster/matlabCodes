% KardinalSinus test
%

delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten


fc=200;
Tc=1/fc;
fs=2000;
Ts=1/fs;
L=1000;

t=[-(L-1)/2:1:(L-1)/2]*Ts;
%t=[0:L-1]*Ts;

f1=fc*sinc(fc*t);

% f1 um x2 Interpolieren
%

f1Interpol=zeros(1,2*length(f1));
length(f1);
length(f1Interpol);

j=1;

for k=1:length(f1)-1
    f1Interpol(j)=f1(k);
    f1Interpol(j+1)=(f1(k+1)+f1(k))/2;
    j=j+2;
end

% 
f2=f1;

% fn=figure(33);
% plot(t,rec)

p2=figure(2);
subplot(221);
hold on;
plot(t(L/4:L*3/4),f1(L/4:L*3/4));grid on;
hold off;
legend('f1(t)');
title('f1(t)')
xlabel('Time s')
ylabel('f1(t)')

title(['fc =' num2str(fc,'%.2e') ' Hz'...
       '   fs =' num2str(fs,'%.2e') ' Hz'...
       '   Ts = ' num2str(1/fs,'%.5e') ' s'...
       '   fs/fc = ' num2str(fs/fc,'%.3f')...
       '   n Samples: ' num2str(length(t),'%i')...
       ])

subplot(223);
hold on;
plot(t,f1,'r');grid on;
%plot(t,rec);grid on;
hold off;
%ylim([min(sr) max(sr)]);
%set(gca,'XTick',(-10*fc:10*fc));
%set(gca,'YTick',(0:0.1:2));
legend('f2(t)');
title('f2(t)')
xlabel('Time s')
ylabel('f2(t)')



Fs = fs;                    % Sampling frequency
T = 1/Fs;                     % Sample time
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(f1,NFFT)/L;

f = Fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
subplot(222);
plot(f,2*abs(Y(1:NFFT/2+1)));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('|F1(f)|')

subplot(224);
ffull=Fs*linspace(0,1,NFFT);
% Plot single-sided amplitude spectrum.
plot(ffull,2*abs(Y));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('|F1(f)|')

% Plot Interpol. Spektrum
%

Fs = 2*Fs;                    % Sampling frequency
T = 1/Fs;                     % Sample time
Li=2*L;
NFFT = 2^nextpow2(Li); % Next power of 2 from length of y
Yint = fft(f1Interpol,NFFT)/Li;

pint=figure(3);
ffull=Fs*linspace(0,1,NFFT);
% Plot single-sided amplitude spectrum.
plot(ffull,10*log10(abs(Yint)));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('|F1(f)|')


% set(gca,'XTick',(0:1/fc:n*(1/fc))*UNIT);
% set(gca,'YTick',(-ymax3:(2*ymax3)/10:ymax3));
% xlabel('Periode n*Tc / ns');
% ylim([-ymax3 ymax3]);
