% KardinalSinus test
%
% function disppos 
% h.f = figure; 
% plot(rand(1,10)); 
% grid on; 
% h.a=gca; 
% set(h.f,'WindowButtonDownFcn',{@druecken,h}); 
% set(h.f,'WindowButtonUpFcn', {@loesen,h}); 
% 
% 
% function druecken(o,e,h) 
% pt = get(h.a, 'CurrentPoint'); 
% set(h.f,'Name',num2str([pt(1,1) pt(1,2)])); 
% set(h.f, 'WindowButtonMotionFcn', {@ziehen,h}) 
% 
% function ziehen(o,e,h) 
% pt = get(h.a, 'CurrentPoint'); 
% set(h.f,'Name',num2str([pt(1,1) pt(1,2)])); 
% 
% function loesen(o,e,h) 
% set(h.f, 'WindowButtonMotionFcn', '');
% 

delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten


fc=37;
Tc=1/fc;
fs=300;
Ts=1/fs;
L=1023;
t=[-L/2:1:L/2]*Ts;

%f1=0.95*fs*sinc(fc*t);
f1=sinc(fc*t).*cos(2*pi*fc*t);
fcmpx=cos(2*pi*fc*t)+0.8*i*sin(2*pi*fc*t);

Fs = fs;                    % Sampling frequency
T = Ts;                     % Sample time
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(f1,NFFT)/L;
Fcmpx=fft(fcmpx,NFFT)/L;

Y=Y/max(abs(Y));
Fcmpx=Fcmpx/max(abs(Fcmpx));

f = Fs*linspace(0,1,NFFT/2-1);
fNP1 = Fs*linspace(-1,1,NFFT);
fNP = Fs*linspace(-1,1,2*NFFT);
ffull=Fs*linspace(0,1,NFFT);
ffake=2*Fs*linspace(-1,1,4*NFFT);

% Plot single-sided amplitude spectrum.
FcmpxShift=fftshift(abs(Fcmpx)/NFFT);
FcmpxShift=FcmpxShift/max(abs(FcmpxShift));

FcmpxShiftFake=zeros(1,2*length(FcmpxShift));
FcmpxShiftAb=zeros(1,4*length(FcmpxShift));

for k=1:length(FcmpxShiftFake)
    FcmpxShiftFake(k)=FcmpxShift(end);
end

for k=1:length(FcmpxShiftAb)
    FcmpxShiftAb(k)=FcmpxShift(end);
end

FcmpxShiftFake(0.25*end:0.75*(end-1))=FcmpxShift;
FcmpxShiftAb((0.25/2)*end+(length(FcmpxShiftAb)/4):...
             (0.75/2)*(end-1)+(length(FcmpxShiftAb)/4))=FcmpxShift;
FcmpxShiftAb((0.25/2)*end+(length(FcmpxShiftAb)/2):...
             (0.75/2)*(end-1)+(length(FcmpxShiftAb)/2))=FcmpxShift;
FcmpxShiftAb((0.25/2)*end:...
             (0.75/2)*(end-1))=FcmpxShift;

f88=figure(88);

% h.f = figure; 
% plot(rand(1,10)); 
% grid on; 
% h.a=gca; 

subplot(321);
plot(ffake(0.25*end:0.75*(end-1)),(abs(FcmpxShiftFake)));grid on; 
title('Spektrum der kompl. Schwingung mit nicht- idealem Verlauf')
xlabel('Frequenz (Hz)')
ylabel('| Fcmpx(f) | ')
xlim([-fs fs]);
ylim([0 1.1]);
title(['fc =' num2str(fc,'%.d') ' Hz'...
       '   fs = inf'...
       '   Ts = 0' ...
       ])

   
   
subplot(323);
plot(ffake,(abs(FcmpxShiftAb)));grid on; 
xlabel('Frequenz (Hz)')
ylabel('| F1(f) | ')
ylim([0 1.1]);
xlim([-fs fs]);
title(['Spektrum nach Abtastung'])

% fc =' num2str(fc,'%d') ' Hz'...
%        '   fs =' num2str(fs,'%d') ' Hz'...
%        '   Ts = ' num2str(1/fs,'%.3e') ' s'...
%        '   n Samples: ' num2str(length(t),'%d')

subplot(325);
plot(ffake,(abs(FcmpxShiftAb)));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequenz (Hz)')
ylabel('| F1(f) | ')
xlim([-fs*(4/3) fs*(4/3)]);
title(['fc =' num2str(fc,'%d') ' Hz'...
       '   fs =' num2str(fs,'%d') ' Hz'...
       '   Ts = ' num2str(1/fs,'%.3e') ' s'...
       '   n Samples: ' num2str(length(t),'%d')...
       ])
ylim([0 1.1]);
text(-fs,-25e-2,['\fontname{arial}-f_s'],'HorizontalAlignment','center','FontWeight','bold','FontSize',14,'Color','r')
text(fs,-25e-2,['\fontname{arial}f_s'],'HorizontalAlignment','center','FontWeight','bold','FontSize',14,'Color','r')
line([-fs -fs],[0 1.1],'color','r','linestyle','--')
line([fs fs],[0 1.1],'color','r','linestyle','--')


%%%%%%%%%%%%%%%%%%%%%%%%
p1=figure(1);
subplot(321);
hold on;
plot(t,f1);grid on;
hold off;
legend('f1(t)');
title('f1(t)')
xlim([-0.25 0.25]);
xlabel('Time s')
ylabel('f1(t)')

title(['fc =' num2str(fc,'%.2e') ' Hz'...
       '   fs =' num2str(fs,'%.2e') ' Hz'...
       '   Ts = ' num2str(1/fs,'%.5e') ' s'...
       '   fs/fc = ' num2str(fs/fc,'%.3f')...
       '   n Samples: ' num2str(length(t),'%i')...
       ])

subplot(322);
% Plot single-sided amplitude spectrum.
plot(fNP,(abs([fliplr(Y) Y])));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')

% Plot single-sided amplitude spectrum.
subplot(323);
plot(fNP,(abs([fliplr(Fcmpx) Fcmpx])));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')

FcmpxShift=fftshift(abs(Fcmpx)/NFFT);
subplot(324);
plot(fNP(end/4:(end-1)*0.75),10*log10(abs(FcmpxShift)));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')

subplot(325);
plot(ffull,Fcmpx);grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')

% f1 um x2 Interpolieren
%

f1Interpol=zeros(1,2*length(f1));
length(f1);
length(f1Interpol);
ti=[-length(t):1:length(t)-1]*Ts/2;

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
plot(t,f1);grid on;
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
plot(ti,f1Interpol,'r');grid on;
hold off;
%ylim([min(sr) max(sr)]);
%set(gca,'XTick',(-10*fc:10*fc));
%set(gca,'YTick',(0:0.1:2));
legend('f1Int(t)');
title('f1(t) INTERPOLIERT')
xlabel('Time s')
ylabel('f1(t) int')

title(['fc =' num2str(fc,'%.2e') ' Hz'...
       '   fs =' num2str(2*fs,'%.2e') ' Hz'...
       '   Ts = ' num2str(Ts/2,'%.5e') ' s'...
       '   fs/fc = ' num2str(2*fs/fc,'%.3f')...
       '   n Samples: ' num2str(length(ti),'%i')...
       ])

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

subplot(222);
ffull=Fs*linspace(0,1,NFFT);
% Plot single-sided amplitude spectrum.
plot(ffull,10*log10(abs(Y)));grid on; 
title('Spectrum of f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1(f) | in dB')


% Plot Interpol. Spektrum
%
Fs = 2*Fs;                    % Sampling frequency
T = 1/Fs;                     % Sample time
Li=2*L;
NFFT = 2^nextpow2(Li); % Next power of 2 from length of y
Yint = fft(f1Interpol,NFFT)/Li;

subplot(224);
fifull=Fs*linspace(0,1,NFFT);
plot(fifull,10*log10(abs(Yint)/max(abs(Yint))),'r');grid on; 
title('Spectrum of x2 interpolated f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1int(f) | in dB')


% Spektrum von s(t) mit sinc multiplizieren entspricht im Zeitbereich
% einer Faltung mit einem Impuls  -> 
% Sample and Hold -> Zero Order Hold 

zoh=Ts*sinc(Ts*fifull);
hold on;
plot(fifull(1:end-1),10*log10(abs(zoh(1:end-1).*Yint(1:end-1))));grid on; 
hold off;
legend('| Yint |','| Yint * zoh |');
af=[fifull(end/2-100):fifull(end/2+100)];

p3=figure(3);
plot(af,10*log10(0.5*Ts*sinc(0.5*Ts*af)));grid
% set(gca,'XTick',(0:1/fc:n*(1/fc))*UNIT);
% set(gca,'YTick',(-ymax3:(2*ymax3)/10:ymax3));
% xlabel('Periode n*Tc / ns');
% ylim([-ymax3 ymax3]);

% FIR Interpolation und inverser sinc filter
%

p4=figure(4);
% Fs=1000;
% L=1000;
% t=[0:1:L-1]*1e-3;
% % sinc freq
% fc=1;
% Tc=1/fc;

%Ordnung n: 
n = 87; % Anzahl der Nullstellen in der kompl. Ebene 
fa = 1000; % Abtastfrequenz in Hz passend zur Signalverarbeitungs-Hardware wählen 
fn = fa/2; % Nyquistfrequenz 
%Wn = 4000/fn; % -6 dB – Grenzfrequenz in Hz 
%FIRkoeff = fir1(n, Wn, 'low'); % TP-Filter 

% Alternativ der Entwurf eines Bandpasses: 
pass1 = 0.1; % -6 dB – Grenzfrequenz in Hz 
pass2 = 200; % -6 dB – Grenzfrequenz in Hz 
Wn = [pass1/fn pass2/fn]; 
FIRkoeff = fir1(n, Wn, 'bandpass'); % BP-Filter 

% Darstellung der Koeffizienten: 
subplot(223);
plot(FIRkoeff, '--') 
hold on; 
plot(FIRkoeff, '.') 
hold off 
title('Koeffizienten (Impulsantwort) des FIR-Filters') 

% Zunächst den Nennerkoeffizientenvektor erstellen: 
% (nötig zur korrekten Rechnung mit freqz, grpdelay, zplane) 
a = zeros(size(FIRkoeff)); % oder: a = zeros(1, n+1); 
a(1) = 1; 
% freqz über Aufruf mit Koeffizientenvektoren 
cntW = 4096; 
% Standardmäßig (ohne zusätzliche Parameterangabe cntW) werden nur 512 Frequenzpunkte 
% berechnet! 
[Hfir, Wfir] = freqz(FIRkoeff, a, cntW); % mit 0 <= Wfir <= pi 
df = Wfir(2)/pi*fn; % oder: df = fn/length(Wfir); 
% df (delta_f) ist der Abstand zwischen den Frequenzpunkten in Hz 
% d.h. df entspricht der Frequenzauflösung in Hz 
amplFIR = abs(Hfir); 
phaseFIR = angle(Hfir); 


% Darstellung des Amplitudengangs (linear): 
%fig = figure(fig+1); 
subplot(221);
fFir=Wfir/pi*fn;

plot(fFir(1:300/df), 10*log10(amplFIR(1:300/df)), 'b');grid 
%axis([0 fn -0.1 1.1]); 
title('Amplitudengang des FIR-Filters') 
ylabel('Verstärkung') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
hold on; 
plot(Wn*fn,1,'rx') 
hold off; 
% Darstellung der Phase: 
subplot(222);
plot(Wfir/pi*fn, -unwrap(phaseFIR)/pi*180) 
title('Phasengang des FIR-Filters') 
ylabel('Phase in Grad') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 

% si- gewichtung
sigw= @(f,T) sin(pi*f*T)./(pi*f);

% Sinus sweep
fs=400;
Ts=1/fs;
n=2048;
time=[0:Ts:n*Ts-Ts];
timeZ=[fliplr(time(2:end/2))*(-1) time(1:end/2) length(time)*Ts];
f0=0; f1=65;
yChirp=chirp(time,f0,(n*Ts),f1);

% Test si- Spectrum
ySiZ=sin(pi*time(2:end/2)*50)./(pi*time(2:end/2)*50);
ySi=[fliplr(ySiZ) 1 1 ySiZ];

% Test Rect Spectrum
yRect=zeros(1,n);
yRect(2:501)=ones(1,500);
yRectZ=zeros(1,n);
yRectZ(n/2-249:n/2+250)=ones(1,500);

% Sweep Spektrum
Ls=n;
NFFT = 2^nextpow2(Ls); % Next power of 2 from length of y
window = blackman(Ls);
yChirp=yChirp.';

% Si fft
YSi=fft(ySi.',NFFT)/Ls;

% Rect fft
Yrect=fft(yRect.',NFFT)/Ls;
YrectZ=fft(yRectZ.',NFFT)/Ls;

% Ychirp fft
Ychirp = fft(yChirp,NFFT)/Ls;

%fChirp=Fs*linspace(0,1,NFFT);
fChirp = fs/2*linspace(0,1,NFFT/2+1);
fChirpFull = fs*linspace(0,1,NFFT);

ptemp=figure(5);
subplot(421);
plot(fChirpFull, sigw(fChirpFull,Ts));grid;
title('si- Gewichtungsfunktion');

subplot(423);
plot(time,ySi);grid;
subplot(424);
plot(fChirp,abs(YSi(1:NFFT/2+1)),'g');grid on;

subplot(425);
plot(time,yRect);grid;xlim([-10,10]);
subplot(426);
%plot(fChirp(1:800),abs(Yrect(1:800)),'g');grid on;

subplot(427);
plot(timeZ,yRectZ);grid;xlim([-10,10]);
subplot(428);
%plot(fChirp(1:800),abs(YrectZ(1:800)),'g');grid on;

%plot(fChirp,abs(Ychirp)/max(abs(Ychirp)),'r');grid on; 
%plot(fChirp(1:end-1),2*abs(Ychirp(1:NFFT/2)),'g');grid on;       % Plot single-sided amplitude spectrum.

YchirpNP=[fliplr(abs(Ychirp)); abs(Ychirp)];
fChirpNP = linspace(-1,1,2*NFFT)*fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
YchirpNACHFFTEXAMPLE = fft(yChirp,NFFT)/Ls;
YchirpNACHFFTEXAMPLEamp=fftshift(abs(YchirpNACHFFTEXAMPLE)/NFFT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%


p6=figure(6);
subplot(421);
plot(fChirpNP,YchirpNP,'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | ')

subplot(423)
%plot(fChirp,abs(Ychirp)/max(abs(Ychirp)),'r');grid on; 
plot(fChirp(1:end/2),2*abs(Ychirp(1:NFFT/4)),'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | ')

subplot(427)
%plot(fChirp,abs(Ychirp)/max(abs(Ychirp)),'r');grid on; 
plot([-NFFT/2+1:NFFT/2]*(fs/NFFT),YchirpNACHFFTEXAMPLEamp,'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | ')

subplot(422)
%plot(fChirp,10*log10(abs(Ychirp)/max(abs(Ychirp))),'r');grid on; 
plot(fChirp(1:end-1),10*log10(2*abs(Ychirp(1:NFFT/2))),'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | in dB')

subplot(424)
%plot(fChirp,10*log10(abs(Ychirp)/max(abs(Ychirp))),'r');grid on; 
plot(fChirp(1:end/2),10*log10(2*abs(Ychirp(1:NFFT/4))),'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | in dB')


subplot(428)
%plot(fChirp,abs(Ychirp)/max(abs(Ychirp)),'r');grid on; 
plot([-NFFT/2+1:NFFT/2]*(fs/NFFT),10*log10(YchirpNACHFFTEXAMPLEamp),'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | in dB ')



% Interpolate signal


yChirpInt=zeros(1,2*length(yChirp));
yChirpIntZero=zeros(1,2*length(yChirp));
timeInt=[-length(t):1:length(t)-1]*Ts/2;

j=1;
for k=1:length(yChirp)-1
    yChirpInt(j)=yChirp(k);
    yChirpIntZero(j)=yChirp(k);
    yChirpInt(j+1)=(yChirp(k+1)+yChirp(k))/2;
    j=j+2;
end

Lint=2*n;
NFFTint = 2^nextpow2(Lint); % Next power of 2 from length of y
YchirpInt = fft(yChirpInt,NFFTint)/Lint;
YchirpIntZero = fft(yChirpIntZero,NFFTint)/Lint;
%fChirp=Fs*linspace(0,1,NFFT);
fChirpInt = (fs*2)/2*linspace(0,1,NFFTint/2+1);

subplot(425)
%plot(fChirp,abs(Ychirp)/max(abs(Ychirp)),'r');grid on; 
plot(fChirpInt(1:end-1),2*abs(YchirpInt(1:NFFTint/2)),'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) | ')

subplot(426)
%plot(fChirp,abs(Ychirp)/max(abs(Ychirp)),'r');grid on; 
plot(fChirpInt(1:end-1),10*log10(2*abs(YchirpInt(1:NFFTint/2))),'g');grid on;       % Plot single-sided amplitude spectrum.
title(['Spectrum of chirp- Signal ' num2str(f0,'%.2e')...
       ' Hz ... ' num2str(f1,'%.2e') ' Hz'...
       ])
xlabel('Frequency (Hz)')
ylabel('| Chirp(t) in dB | ')


% x2 Interpoliertes Chirp in grss
fChirpFull=linspace(0,1,NFFT)*fs;
fChirpFullInt=linspace(0,1,NFFTint)*2*fs;

ySiBew=sin(pi*fChirpFullInt*Ts/2)./(pi*fChirpFullInt);
ySiBew=2*cos(2*pi*fChirpFullInt*(NFFTint)).^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p7=figure(7);
subplot(311);
plot(fChirpFull,10*log10(Ychirp),'b');grid on;       % Plot single-sided amplitude spectrum.
title(['Chirp- Signals mit f0 = ' num2str(f0,'%d')...
       ' Hz ... f1 = ' num2str(f1,'%d') ' Hz'...
       '       fs =' num2str(fs,'%d') ' Hz'...
       '       Ts = ' num2str(1/fs,'%.3e') ' s'...
       '       n Samples: ' num2str(length(yChirp),'%i')...
       '       NFFT: ' num2str(NFFT,'%i')...
       ])
ylim([-50 -10]);
xlabel('Frequency (Hz)')
ylabel('| Chirp(f) | in dB ')


subplot(312);
plot(fChirpFullInt,10*log10(abs(YchirpIntZero)),'b');grid on;       % Plot single-sided amplitude spectrum.
title(['(Signalvektor verdoppelt, Nullen eingefügt)   Chirp- Signals mit f0 = ' num2str(f0,'%d')...
       ' Hz ... f1 = ' num2str(f1,'%d') ' Hz'...
       '       fs =' num2str(fs*2,'%d') ' Hz'...
       '       Ts = ' num2str(1/(2*fs),'%.3e') ' s'...
       '       n Samples: ' num2str(length(yChirpInt),'%i')...
       '       NFFT: ' num2str(NFFTint,'%i')...
       ])
ylim([-50 -10]);
xlabel('Frequency (Hz)')
ylabel('| Chirp(f) | in dB ')


subplot(313);
plot(fChirpFullInt,10*log10(abs(YchirpInt)),'b');grid on;       % Plot single-sided amplitude spectrum.
title(['(Signalvektor x2 Interpoliert)   Chirp- Signals mit f0 = ' num2str(f0,'%d')...
       ' Hz ... f1 = ' num2str(f1,'%d') ' Hz'...
       '       fs =' num2str(fs*2,'%d') ' Hz'...
       '       Ts = ' num2str(1/(2*fs),'%.3e') ' s'...
       '       n Samples: ' num2str(length(yChirpInt),'%i')...
       '       NFFT: ' num2str(NFFTint,'%i')...
       ])
ylim([-50 -10]);
xlabel('Frequency (Hz)')
ylabel('| Chirp(f) | in dB ')



Ta1=50e-3;
fa1=1/Ta1;
Ta2=Ta1/2;
fa2=1/Ta2;
f0=1;
n=1024;
ts=[0:1:n]*Ta1;
yS=sin(2*pi*f0*ts);

tsDob=[0:1:2*n+1]*Ta2;
ySDob=sin(2*pi*f0*tsDob);

tsInt=[0:1:2*n+1]*Ta2;
ySInt=zeros(1,length(yS)*2);

j=1;
for k=1:length(yS)
    ySInt(j)=yS(k);
%    ySInt(j+1)=(yS(k+1)+yS(k))/2;
    ySInt(j+1)=0;
    j=j+2;
end

p8=figure(8);
subplot(321);
stem(ts,yS,'LineWidth',2,'MarkerFaceColor','b');grid;
legend('ySin=sin(2*pi*f0*t)','Location','NorthWest')
xlim([0 0.25]);
ylim([0 1.1]);
title(['Sinus  mit  f0 =' num2str(f0,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.2e') ' s'...
       ])
set(gca, 'Layer','bottom')
box on;

subplot(323);
hold on;
stem(tsInt,ySInt,'LineWidth',2,'MarkerSize',8,'MarkerFaceColor','b');
stem(tsInt,conv(ySInt(2:end-1),[0.5 1 0.5]),'r','MarkerFaceColor','r');grid on;
hold off;
legend('ySinZero','conv(ySinZero(2:end-1),[0.5 1 0.5])','Location','NorthWest')
xlim([0 0.25]);
ylim([0 1.1]);
set(gca, 'Layer','bottom')
box on;

subplot(325);
stem(tsDob,ySDob,'LineWidth',2,'MarkerFaceColor','b');grid;
xlim([0 0.25]);
ylim([0 1.1]);
title(['Sinus  mit  f0 =' num2str(f0,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.2e') ' s'...
       ])
set(gca, 'Layer','bottom')
box on;
% 
% p8=figure(8);
% T0=1/10;
% tsi=[-50:T0:50];
% ySi=sin(pi*T0*tsi)./(pi*tsi);
% ySi=ySi/max(ySi);
% plot(tsi,ySi);grid on;

% Spektren
L=n;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
fsp = fa1*linspace(0,1,NFFT);
YS=fft(yS,NFFT)/L;

NFFT2 = 2^nextpow2(2*L); % Next power of 2 from length of y
fsp2 = fa2*linspace(0,1,NFFT2);
YSintZ=fft(ySInt,NFFT2)/(2*L);
YSintConv=fft(conv(ySInt(2:end-1),[0.5 1 0.5]),NFFT2)/(2*L);
YSDob=fft(ySDob,NFFT2)/(2*L);



subplot(322);
plot(fsp,10*log10(abs(YS)));grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['f0 =' num2str(f0,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(fsp),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
set(gca, 'Layer','bottom')
ylim([-50 0]);
box on;

subplot(324);
hold on;
plot(fsp2,10*log10(abs(YSintZ)),'b');grid on;
plot(fsp2,10*log10(abs(YSintConv)),'r');grid on;
hold off;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['f0 =' num2str(f0,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(fsp2),'%i')...
       '   NFFT: ' num2str(NFFT2,'%i')...
       ])
legend('A\_SinZero','A\_SinInt','Location','NorthEast');
set(gca, 'Layer','bottom')
ylim([-50 0]);
box on;

subplot(326);
plot(fsp2,10*log10(abs(YSDob)),'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['f0 =' num2str(f0,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(fsp2),'%i')...
       '   NFFT: ' num2str(NFFT2,'%i')...
       ])
legend('A\_Sin2fa','Location','NorthEast');
set(gca, 'Layer','bottom')
ylim([-50 0]);
box on;   
   



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%andere Ansicht
% 
% % Spektren
% L=n;
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% fsp = fa1*linspace(0,1,NFFT);
% YS=fft(yS,NFFT)/L;
% 
% NFFT2 = 2^nextpow2(2*L); % Next power of 2 from length of y
% fsp2 = fa2*linspace(0,1,NFFT2);
% YSintZ=fft(ySInt,NFFT2)/(2*L);
% YSintConv=fft(conv(ySInt(2:end-1),[0.5 1 0.5]),NFFT2)/(2*L);
% YSDob=fft(ySDob,NFFT2)/(2*L);
% 
% p9=figure(9);
% subplot(211);
% stem(ts,yS,'LineWidth',2,'MarkerFaceColor','b');grid;
% legend('ySin=sin(2*pi*f0*t)','Location','NorthWest')
% xlim([0 0.25]);
% ylim([0 1.1]);
% title(['Sinus  mit  f0 =' num2str(f0,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.2e') ' s'...
%        ])
% set(gca, 'Layer','bottom')
% box on;
% 
% 
% 
% subplot(212);
% plot(fsp,10*log10(abs(YS)));grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['f0 =' num2str(f0,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(fsp),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
% set(gca, 'Layer','bottom')
% box on;
% 
% p10=figure(10);
% subplot(211);
% hold on;
% stem(tsInt,ySInt,'LineWidth',2,'MarkerSize',8,'MarkerFaceColor','b');
% stem(tsInt,conv(ySInt(2:end-1),[0.5 1 0.5]),'r','MarkerFaceColor','r');grid on;
% hold off;
% legend('ySinZero','conv(ySinZero(2:end-1),[0.5 1 0.5])','Location','NorthWest')
% xlim([0 0.25]);
% ylim([0 1.1]);
% set(gca, 'Layer','bottom')
% box on;
% 
% subplot(212);
% hold on;
% plot(fsp2,10*log10(abs(YSintZ)),'b');grid on;
% plot(fsp2,10*log10(abs(YSintConv)),'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['f0 =' num2str(f0,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(fsp2),'%i')...
%        '   NFFT: ' num2str(NFFT2,'%i')...
%        ])
% set(gca, 'Layer','bottom')
% box on;
% 
% 
% p11=figure(11);
% subplot(211);
% stem(tsDob,ySDob,'LineWidth',2,'MarkerFaceColor','b');grid;
% xlim([0 0.25]);
% ylim([0 1.1]);
% title(['Sinus  mit  f0 =' num2str(f0,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.2e') ' s'...
%        ])
% set(gca, 'Layer','bottom')
% box on;
% 
% subplot(212);
% plot(fsp2,10*log10(abs(YSDob)),'b');grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['f0 =' num2str(f0,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(fsp2),'%i')...
%        '   NFFT: ' num2str(NFFT2,'%i')...
%        ])
% set(gca, 'Layer','bottom')
% box on;  
% 
% p8=figure(8);
% T0=1/10;
% tsi=[-50:T0:50];
% ySi=sin(pi*T0*tsi)./(pi*tsi);
% ySi=ySi/max(ySi);
% plot(tsi,ySi);grid on;

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Sinus sweep

%clear all;
% 
% tstart = -1;
% tstop  = 1;
% fmax   = 10;
% 
% t = tstart:.0001:tstop;
% 
% y = atan(7*t);
% 
% y = (y - y(1));
% y = y / y(length(y));
% 
% fu=figure(3)
% subplot(3,1,1);
% plot(t, y);
% 
% dy = diff(y)./diff(t);
% 
% subplot(3,1,2);
% plot(t(1:(length(t)-1)), dy);
% 
% s = sin(100*y);
% 
% subplot(3,1,3);
% plot(t, s);
% 
% fu=figure(4)
% subplot(3,1,1);

