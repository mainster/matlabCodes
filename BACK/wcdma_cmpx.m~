% Versuch SIG UMTS-Bassestation
%
% 5MHz breites WCDMA- Signal über kompletten Downlink- Bereich
% aller deutschen Netzanbieter verschiebbar.
%
% 2.11Ghz ... 2.17GHz --> dDown = 60MHz --> nChannel=60/5=30
% 
% Aus Kosten und Performance- Gründen ist LO als Festfrequenz-
% Oszillator zu realisieren.
% f_fpga=38.4MHz DDR  -->  Abtastfreq. WCDMA- Signal f_dac=76.8MHz
%
% 3 Szenarien
%  - A: FPGA erzeugt reelles Bandpasssignal auf erforderlicher Freq
%       DAC ohne interpolation und ohne NCO
%  - B: FPGA erzeugt komplexe Basisband auf fc=0
%       DAC ohne interpolation aber mit mischer
%  - C: FPGA erzeugt komplexe Basisband auf fc=0
%       DAC mit interpolation und mit mischer

delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten
clc;

fa=40e3;
Ta=1/fa;
B=10e3;

dDown=6e3;
nChan=dDown/B;

fcA=2.5e3;
TcA=1/fcA;
dfcA=B;

N=40e7*TcA;

t=[0:1:N-1]*Ta;

fLO=20e3;

% WCDMA Signal
wcdCx=zeros(1,N);
wcdCxUnsy=zeros(1,N);
wcdCxbp=zeros(1,N);
wcdCxbpUnsy=zeros(1,N);
nTones=B/100;

fAa=1;
fAb=B;

for k=fAa:nTones:fAb
    wcdCx=wcdCx+cos(2*pi*k*t)+i*sin(2*pi*k*t);
    wcdCxUnsy=wcdCxUnsy+cos(2*pi*k*t)+0*i*sin(2*pi*k*t);
end
wcdCxbp=wcdCx.*cos(2*pi*fLO*t);
wcdCxbpUnsy=wcdCxUnsy.*cos(2*pi*fLO*t);



% p1=figure(1);
% plot(t,wcd(1,[1:end]));grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NFFT = 2^nextpow2(N); % Next power of 2 from length of y
NFFT=N;
% ticksFah = fa1/2*linspace(0,1,NFFT/2);
% ticksFa = fa1/2*linspace(0,2,NFFT);
% df=fa1/NFFT;

tickF=fa/2*linspace(-1,1,NFFT);
tickFfa=fa*linspace(0,2,NFFT);

Normierung='on';

WCDcx=fft(wcdCx,NFFT);
WCDcxamp=abs(WCDcx)/NFFT;
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    WCDcxamp = WCDcxamp/max(WCDcxamp);
end;
WCDcxdB=10*log10(WCDcxamp);

WCDcxUnsy=fft(wcdCxUnsy,NFFT);
WCDcxUnsyamp=abs(WCDcxUnsy)/NFFT;
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    WCDcxUnsyamp = WCDcxUnsyamp/max(WCDcxUnsyamp);
end;
WCDcxUnsydB=10*log10(WCDcxUnsyamp);

WCDcxbpUnsy=fft(wcdCxbpUnsy,NFFT);
WCDcxbpUnsyamp=abs(WCDcxbpUnsy)/NFFT;
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    WCDcxbpUnsyamp = WCDcxbpUnsyamp/max(WCDcxbpUnsyamp);
end;
WCDcxbpUnsydB=10*log10(WCDcxbpUnsyamp);

WCDcxbp=fft(wcdCxbp,NFFT);
WCDcxbpamp=abs(WCDcxbp)/NFFT;
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    WCDcxbpamp = WCDcxbpamp/max(WCDcxbpamp);
end;
WCDcxbpdB=10*log10(WCDcxbpamp);


f=linspace(-4*fa,4*fa,8*NFFT);
filDa=sin(pi*Ta*f)./(pi*Ta*f);
filDadB=10*log10(abs(filDa));

p2=figure(2);
plot(f,10*log10(abs(filDa)));

yl=[-150 10];
sub=230;
p3=figure(3);
subplot(sub+1);
hold on;
plot(fa*linspace(0,2,2*NFFT)*1e-3,[WCDcxdB WCDcxdB]...
    +filDadB(end/2:3*end/4-1),'b');grid on;
plot(fa*linspace(0,2,2*NFFT)*1e-3,filDadB(end/2:3*end/4-1),'r');grid on;
hold off;
xlabel('Frequency (kHz)')
ylabel('| A(f) | in dB')
title([
       '   fa =' num2str(fa,'%.3e') ' Hz'...
       '   Ta = ' num2str(Ta,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
ylim(yl);
legend('WCDcxdB','Location','South');
set(gca, 'Layer','bottom')
box on; 

subplot(sub+2);
hold on;
plot(fa*linspace(-2,2,4*NFFT)*1e-3,fftshift([WCDcxdB WCDcxdB WCDcxdB WCDcxdB])...
    +filDadB(end/4:3*end/4-1),'b');grid on;
plot(fa*linspace(-2,2,4*NFFT)*1e-3,filDadB(end/4:3*end/4-1),'r');grid on;
hold off;
xlabel('Frequency (MHz)')
ylabel('| A(f) | in dB')
title(['LO =' num2str(fLO*1e-3,'%.1f') ' MHz'...
       '   fa =' num2str(fa*1e-3,'%.1f') ' MHz'...
       '   Ta = ' num2str(Ta*1e6,'%.1f') ' ns'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('WCDcxdB','Location','South');
set(gca, 'Layer','bottom');
ylim(yl);
box on; 


subplot(sub+3);
hold on;
plot(fa*linspace(-1,1,2*NFFT)*1e-3,[WCDcxbpdB WCDcxbpdB]...
    +filDadB(end/2-end/8:end/2+end/8-1),'b');grid on;
plot(fa*linspace(-1,1,2*NFFT)*1e-3,filDadB(end/2-end/8:end/2+end/8-1),'r');grid on;
hold off;
xlabel('Frequency (kHz)')
ylabel('| A(f) | in dB')
title(['LO =' num2str(fLO*1e-6,'%f') ' MHz'...
       '   fa =' num2str(fa,'%.3e') ' Hz'...
       '   Ta = ' num2str(Ta,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('WCDcxdB','Location','South');
set(gca, 'Layer','bottom')
ylim(yl);
box on; 




subplot(sub+4);
hold on;
plot(fa*linspace(0,2,2*NFFT)*1e-3,[WCDcxUnsydB WCDcxUnsydB]...
    +filDadB(end/2:3*end/4-1),'b');grid on;
plot(fa*linspace(0,2,2*NFFT)*1e-3,filDadB(end/2:3*end/4-1),'r');grid on;
hold off;
xlabel('Frequency (kHz)')
ylabel('| A(f) | in dB')
title([
       '   fa =' num2str(fa,'%.3e') ' Hz'...
       '   Ta = ' num2str(Ta,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
ylim(yl);
legend('WCDcxdB','Location','South');
set(gca, 'Layer','bottom')
box on; 

subplot(sub+5);
hold on;
plot(fa*linspace(-2,2,4*NFFT)*1e-3,fftshift([WCDcxUnsydB WCDcxUnsydB WCDcxUnsydB WCDcxUnsydB])...
    +filDadB(end/4:3*end/4-1),'b');grid on;
plot(fa*linspace(-2,2,4*NFFT)*1e-3,filDadB(end/4:3*end/4-1),'r');grid on;
hold off;
xlabel('Frequency (MHz)')
ylabel('| A(f) | in dB')
title(['LO =' num2str(fLO*1e-3,'%.1f') ' MHz'...
       '   fa =' num2str(fa*1e-3,'%.1f') ' MHz'...
       '   Ta = ' num2str(Ta*1e6,'%.1f') ' ns'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('WCDcxdB','Location','South');
set(gca, 'Layer','bottom');
ylim(yl);
box on; 


subplot(sub+6);
hold on;
plot(fa*linspace(-1,1,2*NFFT)*1e-3,[WCDcxbpUnsydB WCDcxbpUnsydB]...
    +filDadB(end/2-end/8:end/2+end/8-1),'b');grid on;
plot(fa*linspace(-1,1,2*NFFT)*1e-3,filDadB(end/2-end/8:end/2+end/8-1),'r');grid on;
hold off;
xlabel('Frequency (kHz)')
ylabel('| A(f) | in dB')
title(['LO =' num2str(fLO*1e-6,'%f') ' MHz'...
       '   fa =' num2str(fa,'%.3e') ' Hz'...
       '   Ta = ' num2str(Ta,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('WCDcxdB','Location','South');
set(gca, 'Layer','bottom')
ylim(yl);
box on; 



% %-------------- kompl. multitone B=10MHz bei flo=2109,5MHz im Bereich 2029,5MHz bis 2189,5MHz  -----------------
% \begin{figure}[tp]
% 	\centering
% 		\includegraphics[width=0.75\textwidth, angle=0]{SIG_spektren/res_7_11_1}
% 		\caption{Reelwertiges WCDMA- Signal, Downlink- Kanal \textbf{Vodafon[\,1\,]}\\ 
% 			$B=5\,MHz$ Darstellung im Bandpass- Bereich, $f_{DAC}=76.8\,MHz$}
% 		\label{fig:a7111}
% 	\hspace{19mm}
% 	\rule[-0mm]{0.8\textwidth}{0.1mm}\hfill						% Linie aus quadrat, auch innerhalb figure
% 	\vspace{6mm}
%   \includegraphics[width=0.75\textwidth, angle=0]{SIG_spektren/res_7_11_2}
% 		\caption{Reelwertiges WCDMA- Signal, Downlink- Kanal \textbf{Vodafon[\,3\,]}\\ 
% 			$B=5\,MHz$ Darstellung im Bandpass- Bereich, $f_{DAC}=76.8\,MHz$}
% 		\label{fig:a7112}
% \end{figure}
% 
% %-------------- kompl. multitone x4 im bp und bb ------------------------------------------
% \begin{figure}[tp]
% 	\centering
% 		\includegraphics[width=0.75\textwidth, angle=0]{SIG_spektren/res_7_11_3}
% 		\caption{WCDMA- Signal, Bandpass- Bereich, Downlink- Kanal \textbf{Vodafon[\,2\,]} \\
% 		(Schw.) reellwertig (blau) komplex, $B=5\,MHz$ $f_{DAC}=76.8\,MHz$}
% 		\label{fig:a7113}
% 	\hspace{19mm}
% 	\rule[-0mm]{0.8\textwidth}{0.1mm}\hfill						% Linie aus quadrat, auch innerhalb figure
% 	\vspace{6mm}
%   \includegraphics[width=0.75\textwidth, angle=0]{SIG_spektren/res_7_11_4}
% 		\caption{WCDMA- Signal, Bandpass- Bereich, Downlink- Kanal \textbf{Vodafon[\,3\,]} \\
% 		x4 Interpoliert, kleiner I/Q Fehler, $f_{DAC}=76.8\,MHz$}
% 		\label{fig:a7114}
% \end{figure}
