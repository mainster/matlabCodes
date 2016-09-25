%%%%%%%%%%%%%%%%%%%%%%%%
% Verlauf von AD DA Wandlung
%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten

fs=100;
Ts=1/fs;
fc=10;
Tc=1/fc;
N=(2^16-1);

ssinc1='sinc(fc*t).*cos(2*pi*fc*t)';
t=[-N/2:1:N/2-1]*Ts;
tfake=[-N/2:1:N/2-1]*0.1*Ts;
sinc1=eval(ssinc1);
sinc1fake=sinc(fc*tfake).*cos(2*pi*fc*tfake);

Fs = fs;                    % Sampling frequency
T = Ts;                     % Sample time
NFFT = 2^nextpow2(N); % Next power of 2 from length of y
SINC1 = fft(sinc1,NFFT)/N;
SINC1 = fftshift(SINC1/NFFT);

Z=SINC1(1:end/4);
SINC1LR = [SINC1 SINC1 SINC1];
SINC1fake= [Z Z Z Z SINC1 Z Z Z Z];
ticksF = Fs/2*linspace(-1,1,NFFT);
ticksFLR = Fs/2*linspace(-3,3,3*NFFT);

f1=figure(1);
subplot(321);
plot(tfake,sinc1fake);grid on;
legend(['f1(t)=' ssinc1]);
title('f1(t)')
xlabel('Time s')
ylabel('f1(t)')
title(['fc = ' num2str(fc,'%.2d') ' Hz'...
       '   Tc = ' num2str(1/fc,'%.2e') ' s'...
       '   fs = inf '...
       '   Ts = 0' ...
       ])
xlim([-0.5 0.5]);
ylim([-0.75 max(sinc1)*1.25]);
box on;

% Plot doble-sided amplitude spectrum.
SINC1fake=abs(SINC1fake);
yMAX=SINC1fake(round(((150+fc)*length(SINC1fake)/300)));  % Normierung auf Amplitude bei f=fc

for k=1:length(SINC1fake)
    if SINC1fake(k)>yMAX;
        SINC1fake(k)=yMAX;
    end
end

subplot(322);
plot(ticksFLR,SINC1fake/yMAX);grid on;
ylim([0 1.1]);

%ylim([0 round(max(SINC1fake/1e-5)*10)/10]);
title('Normiertes Spektrum von f1(t)')
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')


%%%%%%%%%%%%%%%%%%%%%%%
% Nach der AD- Wandlung
%%%%%%%%%%%%%%%%%%%%%%%
subplot(323);
sp1=stem(t,sinc1);grid on;
set(sp1,'MarkerFaceColor','blue','MarkerSize',4)
legend('f1(t)');
title('f1(t)')
xlabel('Time s')
ylabel('f1(t)')
title(['fc =' num2str(fc,'%.2d') ' Hz'...
       '   fs = ' num2str(fs,'%.2d') ' Hz'...
       '   Ts = ' num2str(1/fs,'%.2e') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       ])
xlim([-0.2 0.2]);
ylim([-0.75 max(sinc1)*1.25]);
box on;

% Plot doble-sided amplitude spectrum.
subplot(324);
SINC1LR=2*abs(SINC1LR);
yMAX=SINC1LR(round(((150+fc)*length(SINC1LR)/300)));  % Normierung auf Amplitude bei f=fc
for k=1:length(SINC1LR)
    if SINC1LR(k)>yMAX;
        SINC1LR(k)=yMAX;
    end
end
plot(ticksFLR,SINC1LR/yMAX);grid on; 
ylim([0 1.1]);
title(['Normiertes Spektrum nach Abtastung von f1(t)'...
       '   NFFT = ' num2str(NFFT,'%.2d')
])
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')
text(-fs,-0.2,['-F_s'],'HorizontalAlignment','center',...
    'FontWeight','bold','FontSize',11,'Color','r')
text(fs,-0.2,['F_s'],'HorizontalAlignment','center',...
    'FontWeight','bold','FontSize',11,'Color','r')
line([-fs -fs],[0 1.1],'color','r','linestyle','--')
line([fs fs],[0 1.1],'color','r','linestyle','--')
box on;

%%%%%%%%%%%%%%%%%%%%%%%
% Nach der DA- Wandlung
%%%%%%%%%%%%%%%%%%%%%%%
subplot(325);
hold on;
[xb,yb]=stairs(t,sinc1);
%plot(xb-Ts/2,yb,'r','LineWidth',2);
plot(xb,yb,'r','LineWidth',2);
sp1=stem(t,sinc1,'b');grid on;
hold off;
set(sp1,'MarkerFaceColor','blue','MarkerSize',4)
xlim([-0.2 0.2]);
ylim([-0.75 max(sinc1)*1.25]);
box on;

% Plot doble-sided amplitude spectrum.
subplot(326);
hold on;
plot(ticksFLR,SINC1LR/yMAX,'b');grid on; 
filDA=sin(pi*Ts*ticksFLR)./(pi*ticksFLR);
plot(ticksFLR,abs(filDA/max(filDA)),'g--','LineWidth',1);
plot(ticksFLR,abs((filDA/max(filDA)).*(SINC1LR/yMAX)),'g','LineWidth',2);
hold off;
ylim([0 1.1]);
title(['Normiertes Spektrum nach DA- Wandlung von f1(t)'...
       '   NFFT = ' num2str(NFFT,'%.2d')
])
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')
text(-fs,-0.2,['-F_s'],'HorizontalAlignment','center',...
    'FontWeight','bold','FontSize',11,'Color','r')
text(fs,-0.2,['F_s'],'HorizontalAlignment','center',...
    'FontWeight','bold','FontSize',11,'Color','r')
line([-fs -fs],[0 1.1],'color','r','linestyle','--')
line([fs fs],[0 1.1],'color','r','linestyle','--')
box on;

%%%%%%%%%%%%%%%%%%%%%%%
% Back- Off
%%%%%%%%%%%%%%%%%%%%%%%

ymax=1.1;
ymin=0.8;
p2=figure(2);
rectf=zeros(1,length(SINC1LR));
tpHz=300/N;
h=45;
filDAInv=(pi*ticksFLR)./sin(pi*Ts*ticksFLR);
rectf((15+450)/tpHz:(h+450)/tpHz)=ones(1,length((15+450)/tpHz:(h+450)/tpHz));
%Plot doble-sided amplitude spectrum.
hold on;
plot(ticksFLR,rectf,'b','LineWidth',1);
plot(ticksFLR,abs(filDA/max(filDA)),'g--','LineWidth',1);
plot(ticksFLR,abs(filDAInv)/100,'r','LineWidth',2);
plot(ticksFLR,abs((filDA/max(filDA)).*rectf),'g','LineWidth',1);grid on;
% line([5 5],[ymin 1],'color','b','linestyle','-')
% line([15 15],[ymin 1],'color','b','linestyle','-')
% line([5 15],[1 1],'color','b','linestyle','-')
hold off;
ylim([ymin ymax]);
xlim([2 18]);
title(['Normiertes Spektrum nach DA- Wandlung von f1(t)'...
       '   NFFT = ' num2str(NFFT,'%.2d')
])
xlabel('Frequency (Hz)')
ylabel('| F1(f) | ')
text(-fs,-0.2,['-F_s'],'HorizontalAlignment','center',...
    'FontWeight','bold','FontSize',11,'Color','r')
text(fs,-0.2,['F_s'],'HorizontalAlignment','center',...
    'FontWeight','bold','FontSize',11,'Color','r')
line([-fs -fs],[0 1.1],'color','r','linestyle','--')
line([fs fs],[0 1.1],'color','r','linestyle','--')
legend('|A1(f)|','sin(x)/x','x/sin(x)','Location','SouthEast')
box on;





