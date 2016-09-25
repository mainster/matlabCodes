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
B=8e3;

dDown=6e3;
nChan=dDown/B;

fcA=2.5e3;
TcA=1/fcA;
dfcA=B;

N=40e7*TcA;

t=[0:1:N-1]*Ta;

% WCDMA Signal
wcd=zeros(nChan,N);
wcdCx=zeros(1,N);
wcdCxUnsy=zeros(1,N);
dwcd=B/50;

fAa=1;
fAb=B;

for chanCtr=1:nChan
    for k=fAa:dwcd:fAb
        wcd(chanCtr,[1:end])=wcd(chanCtr,[1:end])+sin(2*pi*(k+(chanCtr-1)*B)*t);
        wcdCx=wcdCx+cos(2*pi*k*t)+i*sin(2*pi*k*t);
        wcdCxUnsy=wcdCxUnsy+cos(2*pi*k*t)+0.95*i*sin(2*pi*k*t);
    end
end

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
WCD=zeros(nChan,N);
WCDamp=zeros(nChan,N);
WCDdB=zeros(nChan,N);
WCDdBsh=zeros(nChan,N);

WCDcx=zeros(1,N);
WCDcxamp=zeros(1,N);
WCDcxdB=zeros(1,N);

tickF=fa/2*linspace(-1,1,NFFT);
tickFfa=fa*linspace(0,2,NFFT);

for chanCtr=1:nChan
    WCD(chanCtr,[1:end])=fft(wcd(chanCtr,[1:end]),NFFT);
    WCDamp(chanCtr,[1:end])=abs(WCD(chanCtr,[1:end]))/NFFT;
    WCDdB(chanCtr,[1:end])=10*log10(WCDamp(chanCtr,[1:end]));
    WCDdBsh(chanCtr,[1:end])=fftshift(WCDdB(chanCtr,[1:end]));
end;

WCDcx=fft(wcdCx,NFFT);
WCDcxamp=abs(WCDcx)/NFFT;
WCDcxdB=10*log10(WCDcxamp);

WCDcxUnsy=fft(wcdCxUnsy,NFFT);
WCDcxUnsyamp=abs(WCDcxUnsy)/NFFT;
WCDcxUnsydB=10*log10(WCDcxUnsyamp);


p2=figure(2);
YSCALE=[-100 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
col=zeros(nChan,3);
r=1;g=2;b=3;
dc=3/nChan
for jj=1:1:nChan/3
    col(jj,r)=dc*jj
end
for jj=1:1:nChan/3
    col(jj+nChan/3,g)=dc*jj
end
for jj=1:1:nChan/3
    col(jj+2*nChan/3,b)=dc*jj
end


for j=1:nChan
    subplot(nChan/2,2,j);
    plot(tickF,WCDdBsh(j,[1:end]),'color',col(j,(1:end)));grid on;
    xlabel('Frequency (Hz)')
    ylabel('| A(f) | in dB')
    legend('WCDdB(1)','WCDdB(2)','WCDdB(3)');
    set(gca, 'Layer','bottom')
    %ylim([YSCALE]);
    % xlim([0 4*fa1]);
    % line([fa1 fa1],[YSCALE],'color','r','linestyle','--')
    % line([2*fa1 2*fa1],[YSCALE],'color','r','linestyle','--')
    % line([3*fa1 3*fa1],[YSCALE],'color','r','linestyle','--')
    box on; 
end

p3=figure(3);
subplot(221);
plot(fa/2*linspace(0,2,NFFT),WCDcxdB,'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
legend('WCDcxdB');
set(gca, 'Layer','bottom')
box on; 

subplot(222);
plot(fa/2*linspace(0,2,NFFT),WCDdB,'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
legend('WCDcxdB');
set(gca, 'Layer','bottom')
box on;

subplot(223);
plot(fa/2*linspace(0,2,NFFT),WCDcxUnsydB,'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
legend('WCDcxdB');
set(gca, 'Layer','bottom')
box on; 

subplot(224);
plot(fa/2*linspace(0,2,NFFT),fftshift(WCDcxUnsydB),'b');grid on;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
legend('WCDcxdB');
set(gca, 'Layer','bottom')
box on;

