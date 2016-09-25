%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% harmonisches vielfaches, Oberschwingungen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten
clc;

fa1=2^14;
Ta1=1/fa1;
fa2=4*fa1;
Ta2=1/fa2;
n=2^16;
fc=160;
t=[0:1:n]*Ta1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L=n;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
ticksF = fa1/2*linspace(0,2,NFFT);
NFFTx2 = 2^nextpow2(4*L); % Next power of 2 from length of y
ticksFx2 = fa1*linspace(0,4,NFFTx2);
ticksFx4 = fa2/2*linspace(0,2,NFFTx2);
ticksFx4x2 = fa2*linspace(0,2,2*NFFTx2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erzeugung von Oberwellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=5;
ySow1=sin(2*pi*fc*t);
ySowN=nan(length(t),N);
ySowNsum=ySowN;
YSowN=nan(length(fft(ySow1,NFFT)/(L)), N);
YSowN_dB=YSowN;
am=2;
for n=1:N
    am=am/n;
    ySowN(1:end,n)=am*(sin(2*pi*(2*n-1)*fc/10*t));%.*cos(2*pi*(2*n-1)*fc/10*t)).';
    YSowN(1:end,n)=(fft(ySowN(1:end,n),NFFT)/(L)).';
    YSowN_dB(1:end,n)=10*log10(abs(YSowN(1:end,n)));
end;



p1=figure(1);
col=['r' 'g' 'b'];
subplot(211);
hold all;
for n=1:N
    plot(ticksFx2(1:end/4),abs(YSowN(1:end,n)));grid on;
end;
hold off;
xlim([0 2*fc/10*N]);

subplot(212);
hold all;
for n=1:N
    plot(ticksFx2(1:end/4),(YSowN_dB(1:end,n)));grid on;
end;
hold off;
xlim([0 2*fc/10*N]);

p2=figure(2);

col=['r' 'g' 'b'];
hold all;
ySowNsum = ySowN;
for n=1:N
    subplot(N,2,2*n-1);
    for k=1:n
        hold all;
        plot(t(1:100),ySowN(1:100,k));grid on;
        hold off;
    end;
    subplot(N,2,2*n);
    for k=1:n
        hold all;
        ySowNsum(1:end,n)=ySowNsum(1:end,n)+ySowN(1:end,k);
        plot(t(1:100),ySowNsum(1:100,k));grid on;
        hold off;
    end;
end;
hold off;

p3=figure(3);
%ytrec=square(2*pi*fc*t)+square(2*pi*2*fc*t);
ytrec=square(2*pi*fc*t);

Yt=(fft(ySow1,NFFT)/(L)).';
Yt=Yt/max(abs(Yt));
Yt_dB=10*log10(abs(Yt));

Ytrec=(fft(ytrec,NFFT)/(L));
Ytrec=Ytrec/max(abs(Ytrec));
Ytrec_dB=10*log10(abs(Ytrec));

subplot(311);
hold on;
plot(ticksF,Yt_dB,'b','LineWidth',2);grid on;
plot(ticksF,Ytrec_dB,'r','LineWidth',2);grid on;
legend('Yt_dB','Ytrec_dB');
hold off;
xlim([0 650]);
ylim([-40 5]);
line([fc fc],[0 5],'color','g','LineWidth',2,'LineStyle','-');
line(2*[fc fc],[0 5],'color','g','LineWidth',2,'LineStyle','-');
line(3*[fc fc],[0 5],'color','g','LineWidth',2,'LineStyle','-');
set(gca,'XTick',[0:650/10:650])

subplot(312);
hold on;
plot(ticksF,abs(Yt),'b','LineWidth',2);grid on;
plot(ticksF,abs(Ytrec),'r','LineWidth',1);grid on;
legend('Yt','Ytrec')
hold off;
xlim([0 fa1/4]);
ylim([-0.1 1.2]);
%set(gca,'XTick',[0:640/10:640])

subplot(313);
hold on;
%plot(ticksF,Yt_dB,'b','LineWidth',2);grid on;
%plot(ticksF,Ytrec_dB,'r','LineWidth',1);grid on;
plot(t(1:200),ytrec(1:200),'r','LineWidth',1);grid on;
legend('ytrec')
hold off;
%xlim([159 161]);
%ylim([-0.1 1.2]);
%set(gca,'XTick',[159:1/10:161])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%  Quantisierung  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fa=2^11;
Ta=1/fa;
L=2^12;
t=[0:1:L-1]*Ta;
f1=50;
ysin=sin(2*pi*f1*t);

p4=figure(4);
subplot(221);
stem(t(1:2/(f1*Ta)),ysin(1:2/(f1*Ta)));grid on;

subplot(222);
[xb,yquant]=stairs(t(1:end/2),sin(2*pi*2*f1*t(1:end/2)));
hold on;
st1=stem(t(1:2/(f1*Ta)),yquant(1:2/(f1*Ta)),'r');grid on;
%st2=stem(t(1:25),ysin(1:25));grid on;

set(st1,'MarkerFaceColor','red','MarkerSize',4)
set(st2,'MarkerFaceColor','blue','MarkerSize',2)
%stairs(t(1:25),ysin(1:25),'r'); grid on;
hold off;

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
ticksF = fa/2*linspace(0,2,NFFT);

NFFTqa = 2^nextpow2(2*L-1); % Next power of 2 from length of y
ticksFqa = fa/2*linspace(0,2,NFFTqa);

Yquant=fft(yquant,NFFTqa)/(2*L-1);
Yquant_dB=10*log10(abs(Yquant));

Ysin=fft(ysin,NFFT)/L;
Ysin_dB=10*log10(abs(Ysin));

subplot(223);
plot(ticksF,Ysin_dB);grid on;
legend('Ysin_dB');

subplot(224);
plot(ticksFqa,Yquant_dB,'r');grid on;
legend('Yquant_dB');

arr=sort(findall(0,'type','figure'));
delete(arr(1:end-1))

% hold on;
% plot(ticksFx2(1:end/4),abs([YS]),'b','LineWidth',2);grid on;
% plot(ticksFx2(1:end/4),abs([YSrect]),'r');grid on;
% hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fs=100e3;
% Ts=1/fs;
% L=2^16;
% fc=160;
% t=[0:1:L-1]*Ts;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % fft
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% ticksF = fs/2*linspace(0,2,NFFT);
% 
% ySq=sign(sin(2*pi*fc*t));
% ySquare=square(2*pi*fc*t);
% 
% YSquare=(fft(ySquare,NFFT)/L);
% YSquare=YSquare/max(abs(YSquare));
% YSquare_dB=10*log10(abs(YSquare));
% 
% PYSquare = abs(fft(ySquare,NFFT)).^2/L/fs;
% 
% % Create a single-sided spectrum
% Hpsd = dspdata.psd(PYSquare(1:length(PYSquare)/2),'Fs',fs);  
% plot(Hpsd);