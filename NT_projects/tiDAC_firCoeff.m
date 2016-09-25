%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% FIR Interpolation und inverser sinc filter
%

fs=1000;
fn=fs/2;
pfil=figure(1);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Ts=1/fs;
L=2^15;
t=[0:1:L-1]*Ts;
fc=100;
% % sinc freq
% fc=1;
% Tc=1/fc;

s1=cos(2*pi*fc*t);


% Darstellung der Phase: 
subplot(326);
plot(Wfir/pi*fn, -unwrap(phaseFIR)/pi*180) 
title('Phasengang des FIR0- Filters') 
ylabel('Phase in Grad') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']);grid on;

uf=upfirdn(s1,FIR0koeff/(max(FIR0koeff)),2,1);    % Upsample, apply FIR filter, and downsample

NFFT = 2^nextpow2(L);       % Next power of 2 from length of s1
ticksF = fs/2*linspace(0,1,NFFT/2);

Uf = fft(uf,NFFT)/L;
Uf=Uf/max(abs(Uf));
UfdB=10*log10(Uf);

S1 = fft(s1,NFFT)/L;
S1=S1/max(abs(S1));
S1dB=10*log10(abs(S1));

ups=figure(3);


subplot(221);
plot(ticksF,S1dB(1:end/2));grid on;
legend('S1(f) in dB','S2(f) in dB','S3(f) in dB')
xlabel('f / MHz')
ylabel('| S1(f)*FIR0 | in dB')
ylim([-50 0]);
title(['NFFT =' num2str(NFFT,'%i')]);

subplot(222);
plot(ticksF*2,UfdB(1:end/2));grid on;
legend('S1(f)*FIR0 in dB','S2(f) in dB','S3(f) in dB')
xlabel('f / MHz')
ylabel('| S1(f)*FIR0 | in dB')
ylim([-50 0]);
title(['NFFT =' num2str(NFFT,'%i')]);




