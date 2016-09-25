% configureable complex IQ vector generator
% 
% -komplexwertige harmonische Schwingung
% -Frequenz: fc
% -Amplitude Re: Are
% -Amplitude Im: Aim
% -Phase zwischen Re und Im: phi
% -Gleichanteile Re: DCre
% -Gleichanteile Im: DCim
%
% lenth(t)=(n*Tc)/Ts-1 mit k element aus {Integer+}
% (n*Tc) % 32=0
%
delete(findall(0,'type','line'))    % Inhalte der letzten plots löschen, figure handle behalten

fileout='/media/storage/data_notebook/HS_Karlsruhe/N5B/Nachrichtentechnik_1/Labor/Versuch_sig/';
syms fc Are Aim phi DCre DCim

Are=1.3;
Aim=1;
phi=-30; % [phi]=°
DCre=0;
DCim=0;
n=4;
fc=10e6;
fs=160e6;f
% RE=DCre+Are*cos(2*pi*fc*t);
% IM=DCim+Aim*sin(2*pi*fc*t+phi);
% sig= @(t) DCre+Are*cos(2*pi*fc*t) + i*(DCim+Aim*sin(2*pi*fc*t+phi));

genComplSin(fc,n,Are,Aim,phi,DCre,DCim)

% Matlab1
% [t,fs,s1] = genComplSin(fc, n, 0.5, 0.5, 0, 0, 0);       
% [t,fs,s2] = genComplSin(fc, n, 0.5, 0.4, 15, 0, 0);      
% [t,fs,s3] = genComplSin(fc, n, 0.4, 0.3, 0, 0, 0.15);      

[t,fs,s1] = genComplSin(fc, n, 0.5, 0.5, 0, 0, 0);       
[t,fs,s2] = genComplSin(fc, n, 0.5, 0.4, 0, 0, 0);      
[t,fs,s3] = genComplSin(fc, n, 0.4, 0.5, 0, 0, 0);      

%s3=real(s3);
% [t,s1] = genComplSin(fc, fs, 0.3, 0.4, 0, 0, 0);      
% [t,s2] = genComplSin(fc, fs, 1, 1.1, 20, 0.2, 0);      
% [t,s3] = genComplSin(fc, fs, 1, 0.4, 20, 0.2, 0.1);      

if mod(length(t),32)
    warndlg('length(t) mod 32 != 0') 
end;

p1=figure(1);
UNIT=1/1e-9;        % Einheit für Zeitachse: us
UNIT_PHI=180/pi;    % Einheit für Phase: deg

% Skalierung:
% Ladeprogramm TSW3100 geht vermutlich von FullRange=1.0 =^ 2^16 aus
% --> S-peak-peak = 1.0
ymax1=max(max(abs(real(s1))),max(abs(imag(s1))));   % Für skalierung des ausgangs- vektors 
ymax2=max(max(abs(real(s2))),max(abs(imag(s2))));
ymax3=max(max(abs(real(s3))),max(abs(imag(s3))));

s1=s1/(2*ymax1);
s2=s2/(2*ymax2);
s3=s3/(2*ymax3);

ymax1=0.5;
ymax2=0.5;
ymax3=0.5;

% FFT
NFFT = 2^nextpow2(length(t));       % Next power of 2 from length of s1
S1 = fft(s1,NFFT)/length(t);
S2 = fft(s2,NFFT)/length(t);
S3 = fft(s3,NFFT)/length(t);
f = fs/2*linspace(0,1,NFFT/2+1);

% Plot Re und Im
subplot(321);
ReAvg=mean(real(s3));
ImAvg=mean(imag(s3));
hold on;
plot(t*UNIT,real(s3),'b');grid on;
plot(t*UNIT,imag(s3),'r');grid on;
hold off;
legend(['Re(s3) DC=' num2str(ReAvg,'%.3f')],...
    ['Im(s3) DC=' num2str(ImAvg,'%.3f')]);
set(gca,'XTick',(0:1/fc:n*(1/fc))*UNIT);
set(gca,'YTick',(-ymax3:(2*ymax3)/10:ymax3));
xlabel('Periode n*Tc / ns');
ylim([-ymax3*1.1 ymax3*1.1]);
ylabel('Amplitude');

title(['fc =' num2str(fc,'%.2e') ' Hz'...
       '   fs =' num2str(fs,'%.2e') ' Hz'...
       '   Ts = ' num2str(1/fs,'%.5e') ' s'...
       '   fs/fc = ' num2str(fs/fc,'%.3f')...
       '   n Samples: ' num2str(length(t),'%i')...
       ])

line([0 (length(t)-1)*(1/fs)*UNIT],[ReAvg ReAvg],...
    'color','b','linestyle','--')
line([0 (length(t)-1)*(1/fs)*UNIT],[ImAvg ImAvg],...
    'color','r','linestyle','--')

% phi(t)
subplot(323);
hold on;
plot(t*UNIT,angle(s1)*UNIT_PHI,'g');grid on;
plot(t*UNIT,angle(s2)*UNIT_PHI,'b');grid on;
plot(t*UNIT,angle(s3)*UNIT_PHI,'r');grid on;
hold off;
xlabel('Periode n*Tc / ns');
ylabel('Phi/deg');
legend('phi(s1)','phi(s2)','phi(s3)');
set(gca,'YTick',(-pi:pi/5:pi)*UNIT_PHI);

maxh=[max(abs(s1)) max(abs(s2)) max(abs(s3))];
% Plot Einhüllende von s1
sp=subplot(325);
hold on;
plot(t*UNIT,abs(s1),'g');grid on;
plot(t*UNIT,abs(s2),'b');grid on;
plot(t*UNIT,abs(s3),'r');grid on;
hold off;
ylim([0 max(maxh)*1.1]);
xlabel('Periode n*Tc / ns');
ylabel('Amplitude');
legend('|s1(t)|','|s2(t)|','|s3(t)|');

% Plot Spektrum
% subplot(322);
% plot(f*1e-3,2*abs(S1(1:NFFT/2+1)));grid on;       % Plot single-sided amplitude spectrum.
% set(gca,'XTick',(0:fs/10:f(end))*1e-3);
% legend('Spektrum von s1(t)')
% xlabel('f / kHz')
% ylabel('| S1(f) |')

% Plot Spektrum (dB)
subplot(322);
hold on;
plot(f(1:end/2)*1e-6,10*log10(2*abs(S1(1:NFFT/4))),'g');grid on;       % Plot single-sided amplitude spectrum.
plot(f(1:end/2)*1e-6,10*log10(2*abs(S2(1:NFFT/4))),'b');grid on;       % Plot single-sided amplitude spectrum.
plot(f(1:end/2)*1e-6,10*log10(2*abs(S3(1:NFFT/4))),'r');grid on;       % Plot single-sided amplitude spectrum.
% plot(f*1e-6,10*log10(2*abs(S3(1:NFFT/2+1))),'r');grid on;       % Plot single-sided amplitude spectrum.
% plot(f*1e-6,10*log10(2*abs(S3(1:NFFT/2+1))),'r');grid on;       % Plot single-sided amplitude spectrum.
% plot(f*1e-6,10*log10(2*abs(S3(1:NFFT/2+1))),'r');grid on;       % Plot single-sided amplitude spectrum.
hold off;
set(gca,'XTick',(0:fc*1e-6:(f(end)*1e-6)/2));
%set(gca,'XTick',(0:f(end)/5:f(end))*1e-6);
legend('S1(f) in dB','S2(f) in dB','S3(f) in dB')
xlabel('f / MHz')
ylabel('|S1(f)| in dB')
title(['NFFT =' num2str(NFFT,'%i')]);
    
% Ortskurve: Für den Befehl nyquist(G) wird übertragungsfunktion
% G=tf([a],[b c d])nenötigt....
% Ortskurve über plot(re,im) ist einfacher:
subplot(3,2,[4 6]);
LIM=0.6;
hold on;
plot(real(s1),imag(s1),'g');grid on;       % Plot single-sided amplitude spectrum.
plot(real(s2),imag(s2),'b');grid on;       % Plot single-sided amplitude spectrum.
plot(real(s3),imag(s3),'r');grid on;       % Plot single-sided amplitude spectrum.
hold off;
ylim([-LIM LIM]);
xlim([-LIM LIM]);
pbaspect([1 1 1]);
xlabel('Real')
ylabel('Imag')
legend('V1(f)','V2(f)','V3(f)')
line([-LIM LIM],[0 0],'color','k','linestyle','--')
line([0 0],[-LIM LIM],'color','k','linestyle','--')

%  pspec=figure(6);
%  Hs=spectrum.periodogram;
%  psd(Hs,s1,'Fs',fs)

sout=[real(s1) imag(s1)];

save([fileout 'file1.csv'], 'sout', '-ascii', '-tabs');

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% FIR Interpolation und inverser sinc filter
%

pfil=figure(3);
% Fs=1000;
% L=1000;
% t=[0:1:L-1]*1e-3;
% % sinc freq
% fc=1;
% Tc=1/fc;



%Ordnung n: 
n = 87; % Anzahl der Nullstellen in der kompl. Ebene 
fa = 4800; % Abtastfrequenz in Hz passend zur Signalverarbeitungs-Hardware wählen 
fn = fa/2; % Nyquistfrequenz 
%Wn = 4000/fn; % -6 dB – Grenzfrequenz in Hz 
%FIRkoeff = fir1(n, Wn, 'low'); % TP-Filter 

fa = fs;
fn=fs/2;

% Alternativ der Entwurf eines Bandpasses: 
pass1 = 1; % -6 dB – Grenzfrequenz in Hz 
pass2 = 1000; % -6 dB – Grenzfrequenz in Hz 
Wn = [pass1/fn pass2/fn]; 

FIR0koeffL = [6 0 -19 0 47 0 -100 0 192 0 -342 0 572 0 -914 0 1409 0 -2119 0 3152 0 -4729 0 7420 0 -13334 0 41527];
FIR0koeff = [FIR0koeffL 65536 fliplr(FIR0koeffL)];

FIR1koeffL = [-12 0 84 0 -336 0 1006 0 -2691 0 10141];
FIR1koeff = [FIR1koeffL 16384 fliplr(FIR1koeffL)];

FIR2koeffL = [29 0 -214 0 1209];
FIR2koeff = [FIR2koeffL 2048 fliplr(FIR2koeffL)];

FIR3koeffL = [3 0 -25 0 150];
FIR3koeff = [FIR3koeffL 256 fliplr(FIR3koeffL)];

FIR4koeffL = [1 -4 13 -50];
FIR4koeff = [FIR4koeffL 592 fliplr(FIR4koeffL)];


% Darstellung der Koeffizienten: 
subplot(223);
hold all; 
plot(FIR0koeff, '--') 
plot(FIR0koeff, '.');grid on; 
plot(FIR1koeff, '--') 
plot(FIR1koeff, '.');grid on; 
plot(FIR2koeff, '--') 
plot(FIR2koeff, '.');grid on; 
plot(FIR3koeff, '--') 
plot(FIR3koeff, '.');grid on; 
plot(FIR4koeff, '--') 
plot(FIR4koeff, '.');grid on; 
hold off 
title('Koeffizienten (Impulsantwort) der FIR Filter') 
legend('FIR0','FIR1','FIR2','FIR3','FIR4');
% Zunächst den Nennerkoeffizientenvektor erstellen: 
% (nötig zur korrekten Rechnung mit freqz, grpdelay, zplane) 
a0 = zeros(size(FIR0koeff)); % oder: a = zeros(1, n+1); 
a1 = zeros(size(FIR1koeff)); % oder: a = zeros(1, n+1); 
a2 = zeros(size(FIR2koeff)); % oder: a = zeros(1, n+1); 
a3 = zeros(size(FIR3koeff)); % oder: a = zeros(1, n+1); 
a4 = zeros(size(FIR4koeff)); % oder: a = zeros(1, n+1); 
a0(1) = 1; 
a1(1) = 1; 
a2(1) = 1; 
a3(1) = 1; 
a4(1) = 1; 
% freqz über Aufruf mit Koeffizientenvektoren 
cntW = 4096; 
% Standardmäßig (ohne zusätzliche Parameterangabe cntW) werden nur 512 Frequenzpunkte 
% berechnet! 
[Hfir, Wfir] = freqz(FIR0koeff, a0, cntW); % mit 0 <= Wfir <= pi 
[Hfir1, Wfir1] = freqz(FIR1koeff, a1, cntW); % mit 0 <= Wfir <= pi 
[Hfir2, Wfir2] = freqz(FIR2koeff, a2, cntW); % mit 0 <= Wfir <= pi 
[Hfir3, Wfir3] = freqz(FIR3koeff, a3, cntW); % mit 0 <= Wfir <= pi 
[Hfir4, Wfir4] = freqz(FIR4koeff, a4, cntW); % mit 0 <= Wfir <= pi 
df = Wfir(2)/pi*fn; % oder: df = fn/length(Wfir); 
% df (delta_f) ist der Abstand zwischen den Frequenzpunkten in Hz 
% d.h. df entspricht der Frequenzauflösung in Hz 

amplFIR0r = abs(Hfir); 
amplFIR1r = abs(Hfir1); 
amplFIR2r = abs(Hfir2); 
amplFIR3r = abs(Hfir3); 
amplFIR4r = abs(Hfir4); 
phaseFIR = angle(Hfir); 

amplFIR0=amplFIR0r/(max(amplFIR0r));     % Normierung
amplFIR1=amplFIR1r/(max(amplFIR1r));     % Normierung
amplFIR2=amplFIR2r/(max(amplFIR2r));     % Normierung
amplFIR3=amplFIR3r/(max(amplFIR3r));     % Normierung
amplFIR4=amplFIR4r/(max(amplFIR4r));     % Normierung
%amplFIR=amplFIROr;

% Darstellung des Amplitudengangs (linear): 
% fig = figure(fig+1); 
fFir=Wfir/pi*fn;
subplot(321);
plot(fFir/(fs/2), 20*log10(amplFIR0), 'b');grid 
xlabel(['f / fin (fin ist max fs/2=fn)'])
title('Amplitudengang des FIR0- Filters (passt, siehe DAC- DB S.58)') 
ylabel('Verstärkung') 
subplot(322);
plot(fFir/(fs/2), 20*log10(amplFIR1), 'b');grid 
xlabel(['f / fin (fin ist max fs/2=fn)'])
title('Amplitudengang des FIR1- Filters (passt, siehe DAC- DB S.58)') 
ylabel('Verstärkung') 
subplot(323);
plot(fFir/(fs/2), 20*log10(amplFIR2), 'b');grid 
xlabel(['f / fin (fin ist max fs/2=fn)'])
title('Amplitudengang des FIR2- Filters (passt, siehe DAC- DB S.58)') 
ylabel('Verstärkung') 
subplot(324);
plot(fFir/(fs/2), 20*log10(amplFIR3), 'b');grid 
xlabel(['f / fin (fin ist max fs/2=fn)'])
title('Amplitudengang des FIR3- Filters (passt, siehe DAC- DB S.58)') 
ylabel('Verstärkung') 
subplot(325);
plot(fFir/(fs/2), 20*log10(amplFIR4), 'b');grid 
xlabel(['f / fin (fin ist max fs/2=fn)'])
title('Amplitudengang des FIR4- Filters (passt, siehe DAC- DB S.58)') 
ylabel('Verstärkung') 

%xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
%hold on; 
%plot(Wn*fn,1,'rx') 
%hold off; 

%axis([0 fn -0.1 1.1]); 
% Darstellung der Phase: 
subplot(326);
plot(Wfir/pi*fn, -unwrap(phaseFIR)/pi*180) 
title('Phasengang des FIR0- Filters') 
ylabel('Phase in Grad') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 


uf=upfirdn(s1,FIR0koeff/(max(FIR0koeff)),2,1);    % Upsample, apply FIR filter, and downsample

NFFT = 2^nextpow2(length(uf));       % Next power of 2 from length of s1
Su = fft(uf,NFFT)/length(uf);
f = fs/2*linspace(0,1,NFFT/2+1);

ups=figure(4);
%subplot(224);
plot(f(1:385)*1e-6,10*log10(2*abs(Su(1:0.75*(NFFT/2)+1))),'g');grid on;       % Plot single-sided amplitude spectrum.
%set(gca,'XTick',(0:fc*1e-6:(f(end)*1e-6)/2));
%set(gca,'XTick',(0:f(end)/5:f(end))*1e-6);
legend('S1(f)*FIR0 in dB','S2(f) in dB','S3(f) in dB')
xlabel('f / MHz')
ylabel('| S1(f)*FIR0 | in dB')
title(['NFFT =' num2str(NFFT,'%i')]);



