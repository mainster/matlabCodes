%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reelle Schwingung, interpol, da- wandeln, mischen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten
clc;

%%%
hellblau=[0.2549, 0.71372549, 0.952941176];
dunkelblau=[0.070588235, 0.262745098, 0.607843137]

fa1=1000;
Ta1=1/fa1;
fa2=4*fa1;
Ta2=1/fa2;
n=2^14-1;
fc=100;
Tc=1/fc;
t=[0:1:n]*Ta1;
%tx2=[0:1:2*n+1]*Ta2;
tx4=[0:1:4*(n+1)-1]*Ta2;
tx4x2=[0:1:8*(n+1)-1]*Ta2;

phi=pi/9;   % Phasenverschiebung für Mischerschwingung
phi=0;
yS=cos(2*pi*fc*t);

%%%% Quasi- Kontinuierlich gegenüber fa1 %%%%
fak=100e3;
Tak=1/fak;
nk=100e3;
tk=[0:1:nk-1]*Tak;
ySk=cos(2*pi*fc*tk);
ySbpk=cos(2*pi*fc*tk).*cos(2*pi*fa1*tk + phi);
%yS=chirp(t,50,n*Ta1,200);

ySIntx2=zeros(1,length(yS)*2);
ySIntx2Zeros=zeros(1,length(yS)*2);

j=1;
for k=1:length(yS)-1
    ySIntx2(j)=yS(k);
    ySIntx2Zeros(j)=yS(k);
    ySIntx2(j+1)=(yS(k+1)+yS(k))/2;
%    ySInt(j+1)=0;
    j=j+2;
end



ySIntx4=zeros(1,length(ySIntx2)*2);

j=1;
for k=1:length(ySIntx2)-1
    ySIntx4(j)=ySIntx2(k);
    ySIntx4(j+1)=(ySIntx2(k+1)+ySIntx2(k))/2;
%    ySInt(j+1)=0;
    j=j+2;
end



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

Normierung='on';
% von fa1 auf fa2 x4 interpoliert
ySInt=ySIntx4;
% Mischen mit Feinmischer f=fa1
ySIntbp=ySInt.*cos(2*pi*fa1*tx4+phi);
%ySIntbp=ySInt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sin(x)/x Filter wegen S&H der Konvertierung
filDA1k=sin(pi*(Ta1)*ticksFx4x2)./(pi*ticksFx4x2);
filDA4k=sin(pi*(Ta2)*ticksFx4x2)./(pi*ticksFx4x2);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    filDA1k=filDA1k/max(abs(filDA1k));
    filDA4k=filDA4k/max(abs(filDA4k));
end;
filDA1kdB=10*log10(abs(filDA1k));
filDA4kdB=10*log10(abs(filDA4k));

YrectResp=fft(rectpuls(tx4/Ta2),NFFTx2)/(2*L);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x/sin(x) Korrekturfilter
filCorDA1k=(Ta1*pi*ticksF)./sin(pi*(Ta1)*ticksF);
filCorDA4k=(Ta2*pi*ticksFx4)./sin(pi*(Ta2)*ticksFx4);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erzeugung von Oberwellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ySrect=sign(yS);
ySow1 = sin(2*pi*fc*t);
ySow3 = 0.5*sin(2*pi*3*fc*t);
ySow5 = 0.25*sin(2*pi*5*fc*t);
ySow7 = 0.125*sin(2*pi*7*fc*t);

N=8;
ySowN=nan(length(t),N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Oberwellen 
YSrect=fft(ySrect,NFFT)/(L);
%YS=fftshift(YS/NFFT);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YSrect = YSrect/max(abs(YSrect));
end;
YSrect_dB=10*log10(abs(YSrect));

YSowN=nan(length(fft(ySow1,NFFT)/(L)), N);
YSowN_dB=YSowN;
am=2;
for n=1:N
    am=am/2;
    ySowN(1:end,n)=am*sin(2*pi*(2*n-1)*fc/10*t).';
    YSowN(1:end,n)=(fft(ySowN(1:end,n),NFFT)/(L)).';
    %YS=fftshift(YS/NFFT);
    if strcmp(Normierung,'ON') ||...
       strcmp(Normierung,'on')
 %       YSowN(1:end,n) = YSowN(1:end,n)/max(abs(YSowN(1:end,n)));
    end;
    YSowN_dB(1:end,n)=10*log10(abs(YSowN(1:end,n)));
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, fa1
YS=fft(yS,NFFT)/(L);
disp(['max(abs(YS)) = ',num2str(max(2*abs(YS))),' = ',num2str(10*log10(max(2*abs(YS)))),'dB']);
%YS=fftshift(YS/NFFT);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YS = YS/max(abs(YS));
end;
YS_dB=10*log10(2*abs(YS));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, x2 Nullen
YSintx2Zeros=fft(ySIntx2Zeros,NFFTx2)/(2*L);
disp(['max(abs(YSintx2Zeros)) = ',num2str(max(abs(YSintx2Zeros))),' = ',num2str(10*log10(max(abs(YSintx2Zeros)))),'dB']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, fa2
%YSx2=fft(ySx2,NFFTx2)/(2*L);
%YSx2=fftshift(YSx2/NFFTx2);
%YIQrf = YIQrf/max(abs(YIQrf));
%YSx2_dB=10*log10(abs(YSx2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, for interpoliert auf x2
YSintx2=fft(ySIntx2,NFFTx2)/(2*L);
disp(['max(abs(YSintx2)) = ',num2str(max(abs(YSintx2))),' = ',num2str(10*log10(max(abs(YSintx2)))),'dB']);
%YSint=fftshift(YSint/NFFTx2);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
%    YSintx2 = YSintx2/max(abs(YSintx2));
end;
YSintx2_dB=10*log10(abs(YSintx2));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, interpoliert auf x4
YSint=fft(ySInt,NFFTx2)/(2*L);
disp(['max(abs(ySInt"x4")) = ',num2str(max(abs(ySInt))),' = ',num2str(10*log10(max(abs(ySInt)))),'dB']);
%YSint=fftshift(YSint/NFFTx2);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YSint = YSint/max(abs(YSint));
end;
YSint_dB=10*log10(abs(YSint));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% cos(fa1) mischen
YSintbp=fft(ySIntbp,NFFTx2)/(2*L);
disp(['max(abs(YSintbp)) = ',num2str(max(abs(YSintbp))),' = ',num2str(10*log10(max(abs(YSintbp)))),'dB']);
%YSint=fftshift(YSint/NFFTx2);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YSintbp=YSintbp/max(abs(YSintbp));
end;
YSintbp_dB=10*log10(abs(YSintbp));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DA- Wandlung des interpolierten 
% und gemischten signals
ySIntbpDA=conv(ySIntbp(2:end-1),[0.5 1 0.5]);
YSintbpDA=fft(ySIntbpDA,NFFTx2)/(2*L);
disp(['max(abs(YSintbpDA)) = ',num2str(max(abs(YSintbpDA))),' = ',num2str(10*log10(max(abs(YSintbpDA)))),'dB']);
%YSint=fftshift(YSint/NFFTx2);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    ySIntbpDA=ySIntbpDA/max(abs(ySIntbpDA));
end;
YSintbpDA_dB=10*log10(abs(YSintbpDA));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schwingungbei fc, conv fa2
YSintConv=fft(conv(ySInt(2:end-1),[0.5 1 0.5]),NFFTx2)/(2*L);
disp(['max(abs(YSintConv)) = ',num2str(max(abs(YSintConv)))]);
%YSintConv=fftshift(YSintConv/NFFTx2);
if strcmp(Normierung,'ON') ||...
   strcmp(Normierung,'on')
    YSintConv=YSintConv/max(abs(YSintConv));
end;
YSintConv_dB=10*log10(abs(YSintConv));



dfx1=length(YS)/fa1;
dfx4=length(YSint)/fa2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% IFFT TEST %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nper=0.75;
% gRng=[0:length(YSintbp)-1];
% gRang=ticksFx4;
% invSinc=Ta2*(pi*gRng*Ta2)./(sin(pi*gRng*Ta2));

corFilRngd=[filCorDA4k(1:0.4*fa2*dfx4) ones(1,length(filCorDA4k(0.4*fa2*dfx4:end)))];
%pt2=figure(103);
%plot(ticksFx4(1:900*dfx4),filCorDA4k(1:900*dfx4));grid on;
%plot(ticksFx4,corFilRngd);grid on;


ySiff = ifft((YS),NFFT/2)*L;
%ySiffNorm = ySiff/max(abs(ySiff));

ySx2iff = ifft((YSintx2),NFFTx2)*0.5*L;
%ySx2iffNorm = ySx2iff/max(abs(ySx2iff));

ySx4iff = ifft((YSint),NFFTx2)*0.5*L;
%ySx4iffNorm = ySx4iff/max(abs(ySx4iff));

ySintbpiff = ifft((YSintbp.*corFilRngd),NFFTx2)*0.5*L;
%ySintbpiffNorm = ySintbpiff/max(abs(ySintbpiff));

pt=figure(77);

subplot(221);
hold on;
plot(tk(1:Nper*Tc/Tak)*1e3,ySk(1:Nper*Tc/Tak),'r');grid on;
stem(t(1:Nper*Tc/Ta1)*1e3,yS(1:Nper*Tc/Ta1),...
    'r','Marker','o','MarkerFaceColor','r','LineWidth',2,'MarkerSize',4);grid on;
legend('s1 zeitkontinuierlich','s1 mit fa1 abgetastet');
xlabel('t / ms');
ylim([-1.2 1.2]);
hold off;box on;

subplot(222);
hold on;
plot(tk(1:Nper*Tc/Tak)*1e3,ySk(1:Nper*Tc/Tak),'r');grid on;
title(['Normiert auf s1 - Zeitkontinuierlich']);
stem(t(1:Nper*Tc/Ta1)*1e3,yS(1:Nper*Tc/Ta1),...
    'r','Marker','o','MarkerFaceColor','r','LineWidth',3,'MarkerSize',4);grid on;
stem(t(1:2*Nper*Tc/Ta1)*1e3*0.5,ySx2iff(1:2*Nper*Tc/(Ta1))/max(ySx2iff),...
    'color','black','Marker','o','MarkerFaceColor','black','LineWidth',1,'MarkerSize',4);grid on;
stem(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySx4iff(1:4*Nper*Tc/(Ta1))/max(ySx4iff),...
    'color',dunkelblau,'Marker','+','LineWidth',1,'MarkerSize',14);grid on;
legend('s1 - zeitkontinuierlich',...
    's1 - abgetastetmit fa1 ',...
    's1 - linear x2 Interpoliert',...
    's1 - linear x4 Interpoliert'...
    );
xlabel('t / ms');
ylim([-1.2 1.2]);
hold off;box on;

subplot(223);
hold on;
plot(tk(1:Nper*Tc/Tak)*1e3,ySbpk(1:Nper*Tc/Tak)*max(ySintbpiff),'r');grid on;
stem(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySintbpiff(1:4*Nper*Tc/(Ta1)),...
    'color',dunkelblau,'Marker','o','MarkerFaceColor',dunkelblau,...
    'LineWidth',1,'MarkerSize',5);grid on;
stairs(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySintbpiff(1:4*Nper*Tc/(Ta1)),...
    'color',dunkelblau,'LineWidth',1,'LineStyle','--');grid on;
legend('s1 um fa1 verschoben - zeitkontinuierlich',...
    's1 - linear x4 Interpoliert, um fa1 verschoben '...
    );
xlabel('t / ms')
hold off;box on;

subplot(224);
hold on;
%plot(tk(1:Nper*Tc/Tak)*1e3,ySbpk(1:Nper*Tc/Tak),'r');grid on;
stairs(t(1:4*Nper*Tc/Ta1)*1e3*0.25,ySintbpiff(1:4*Nper*Tc/(Ta1)),...
    'color',dunkelblau,'LineWidth',1);grid on;
legend('s1 um fa1 verschoben - zeitkontinuierlich',...
    's1 - linear x4 Interpoliert, um fa1 verschoben '...
    );
xlabel('t / ms')
hold off;box on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p99=figure(99);
col=['r' 'g' 'b'];
subplot(211);
hold all;
for n=1:N
    plot(ticksFx2(1:end/4),abs(YSowN(1:end,n)));grid on;
end;
hold off;

subplot(212);
hold all;
for n=1:N
    plot(ticksFx2(1:end/4),(YSowN_dB(1:end,n)));grid on;
end;
hold off;

p100=figure(100);

col=['r' 'g' 'b'];
for n=1:N
    subplot(N/2,2,n);
    plot(t(1:100),ySowN(1:100,n));grid on;
end;
% subplot(313)
% hold on;
% plot(ticksFx2(1:end/4),abs([YS]),'b','LineWidth',2);grid on;
% plot(ticksFx2(1:end/4),abs([YSrect]),'r');grid on;
% hold off;


p1=figure(1);
YSCALE=[-50 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
subplot(421);
plot(ticksFx2*1e-3,[YS_dB YS_dB YS_dB YS_dB],'b');grid on;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YS\_dB');
set(gca, 'Layer','bottom')
ylim([YSCALE]);
line([fa1*1e-3 fa1*1e-3],[YSCALE],'color','r','linestyle','--')
line([2*fa1*1e-3 2*fa1*1e-3],[YSCALE],'color','r','linestyle','--')
line([3*fa1*1e-3 3*fa1*1e-3],[YSCALE],'color','r','linestyle','--')
box on;   

ysIff = ifft(ifftshift(YS),NFFT);

subplot(422);
plot(ticksFx2*1e-3,abs([YS YS YS YS]),'b');grid on;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa1,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta1,'%.5f') ' s'...
       '   n Samples: ' num2str(length(t),'%i')...
       '   NFFT: ' num2str(NFFT,'%i')...
       ])
legend('YS\_dB');
set(gca, 'Layer','bottom')
line([fa1*1e-3 fa1*1e-3],[0 1.2],'color','r','linestyle','--')
line([2*fa1*1e-3 2*fa1*1e-3],[0 1.2],'color','r','linestyle','--')
line([3*fa1*1e-3 3*fa1*1e-3],[0 1.2],'color','r','linestyle','--')
ylim([0 1.2]);
box on;   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
% auf x4 interpol
subplot(423);
hold on;
plot(ticksFx4x2*1e-3,[YSint_dB YSint_dB],'b');grid on;
hold off;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['x4 interpoliert   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','North');
set(gca, 'Layer','bottom')
line([fa2*1e-3 fa2*1e-3],YSCALE,'color','r','linestyle','--')
line([2*fa2*1e-3 2*fa2*1e-3],YSCALE,'color','r','linestyle','--')
ylim(YSCALE);
box on; 

subplot(424);
hold on;
plot(ticksFx4x2*1e-3,abs([YSint YSint]),'b');grid on;
hold off;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['x4 interpoliert   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','North');
set(gca, 'Layer','bottom')
line([fa2*1e-3 fa2*1e-3],[0 1.2],'color','r','linestyle','--')
line([2*fa2*1e-3 2*fa2*1e-3],[0 1.2],'color','r','linestyle','--')
ylim([0 1.2]);
box on; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
% auf x4 interpol und mit fa1 gemischt
subplot(425);
hold on;
plot(ticksFx4x2*1e-3,[YSintbp_dB YSintbp_dB],'b');grid on;
hold off;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['auf fa1 gemischt   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','North');
set(gca, 'Layer','bottom')
line([fa2*1e-3 fa2*1e-3],YSCALE,'color','r','linestyle','--')
line([2*fa2*1e-3 2*fa2*1e-3],YSCALE,'color','r','linestyle','--')
ylim(YSCALE)
box on; 

subplot(426);
hold on;
plot(ticksFx4x2*1e-3,abs([YSintbp YSintbp]),'b');grid on;
hold off;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['auf fa1 gemischt   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','North');
set(gca, 'Layer','bottom')
line([fa2*1e-3 fa2*1e-3],[0 1.2],'color','r','linestyle','--')
line([2*fa2*1e-3 2*fa2*1e-3],[0 1.2],'color','r','linestyle','--')
ylim([0 1.2]);
box on; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
% auf x4 interpol und mit fa1 gemischt
% nach DA- Wandlung
subplot(427);
hold on;
plot(ticksFx4x2*1e-3,[YSintbp_dB YSintbp_dB]+filDA4kdB,'b');grid on;
plot(ticksFx4x2*1e-3,filDA4kdB,'r');grid on;
hold off;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
set(gca, 'Layer','bottom')
line([fa2*1e-3 fa2*1e-3],YSCALE,'color','r','linestyle','--')
line([2*fa2*1e-3 2*fa2*1e-3],YSCALE,'color','r','linestyle','--')
ylim(YSCALE)
box on; 

subplot(428);
hold on;
plot(ticksFx4x2*1e-3,abs([YSintbp YSintbp].*filDA4k),'b','LineWidth',1);grid on;
%plot(ticksFx4x2,imag([YSintbp YSintbp].*filDA4k),'b');grid on;
plot(ticksFx4x2*1e-3,abs(filDA4k),'r');grid on;
%plot(ticksFx4x2,abs(filDA4k),'r');grid on;
hold off;
xlabel('Frequenz (kHz)')
ylabel('| A(f) | in dB')
title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','North');
set(gca, 'Layer','bottom')
line([fa2*1e-3 fa2*1e-3],[0 1.2],'color','r','linestyle','--')
line([2*fa2*1e-3 2*fa2*1e-3],[0 1.2],'color','r','linestyle','--')
ylim([0 1.2]);
box on; 


p22=figure(22);
hold on;
plot(ticksFx4x2*0.5,10*log10(abs([YSintx2 YSintx2])),'b');grid on;
hold off;
xlabel('Frequency (Hz)')
ylabel('| A(f) | in dB')
title(['x2 interpoliert   fc =' num2str(fc,'%.2f') ' Hz'...
       '   fa =' num2str(fa2,'%.2f') ' Hz'...
       '   Ta = ' num2str(Ta2,'%.5f') ' s'...
       '   n Samples: ' num2str(length(ySIntx4),'%i')...
       '   NFFT: ' num2str(NFFTx2,'%i')...
       ])
legend('YSint\_dB','YSintConv\_dB','Location','North');
set(gca, 'Layer','bottom')
%ylim([-50 0]);
box on; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    diskretes signal   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%    inverse FFT   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p2=figure(2);

rev=[YSintbp YSintbp].*filDA4k;%.*filDA4k;
r=ifft(rev(1:end/2),NFFTx2);
rSh=ifft(ifftshift(rev(1:end/2)),NFFTx2);
rev2=YSintbp;%.*filDA4k;
r2=ifft(conv(rev,[0.5 1 0.5]),NFFTx2);


smod=(real(r)/max(real(r))).*cos(2*pi*4*fa1*tx4).*cos(2*pi*4*fa1*tx4);
smod2=imag(r2/max(real(r2))).*cos(2*pi*4*0*tx4x2(1:end/2));
%s2=cos(2*pi*fc*tx4).*cos(2*pi*fa1*tx4).*cos(2*pi*4*0*tx4);

faN=0.5/250e-6;
L=length(smod);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
ticksF = faN*linspace(0,1,NFFT);

% FFT nach da- wandlung und externem mischen
Ysmod=fft(smod,NFFT)/(L);
%Ysmod = Ysmod/max(abs(Ysmod));
Ysmod_dB=10*log10(abs(Ysmod));

Ys2=fft(r2,NFFT)/(L);
%YSint=fftshift(YSint/NFFTx2);
Ys2 = Ys2/max(abs(Ys2));
Ys2_dB=10*log10(abs(Ys2));

subplot(211);
hold on;
%stem([1:0.02/Ta2]*Ta2*1e3,real(r(1:0.02/Ta2))/max(real(r(1:0.02/Ta2))),...
stem([1:0.02/Ta2]*Ta2*1e3,imag(r(1:0.02/Ta2))/max(imag(r(1:0.02/Ta2))),...
    'r','MarkerSize',6,'MarkerFaceColor','r');grid on;
%stairs([1:0.02/Ta2]*Ta2*1e3,real(rSh(1:0.02/Ta2))/max(real(rSh(1:0.02/Ta2))),...
%stairs([1:0.02/Ta2]*Ta2*1e3,imag(rSh(1:0.02/Ta2))/max(imag(rSh(1:0.02/Ta2))),...
%    'b','MarkerSize',4,'MarkerFaceColor','b');grid on;
stairs([1:0.02/Ta2]*Ta2*1e3,imag(r(1:0.02/Ta2))/max(imag(r(1:0.02/Ta2))));grid on;
hold off;
legend('samples real(ifft(YSintbp,NFFTx2))','stairs real(ifft(YSintbp,NFFTx2))');
line([2 2],[-1.1 1.1],'color','r','linestyle','--')
line([12 12],[-1.1 1.1],'color','r','linestyle','--')
xlabel('Zeit (ms)');
ylim([-1.1 1.1]);
box on;

subplot(212);
%stairs([1:0.02/Ta2]*Ta2*1e3,real(r(1:0.02/Ta2))/max(real(r(1:0.02/Ta2))));grid on;
stairs([1:0.02/Ta2]*Ta2*1e3,imag(r(1:0.02/Ta2))/max(imag(r(1:0.02/Ta2))));grid on;
legend('stairs real(ifft(YSintbp,NFFTx2))');
xlabel('Zeit (ms)');
ylim([-1.1 1.1]);
box on;

plotted=imag(r/max(imag(r)));
Lk=length(plotted);
NFFTk2=2^nextpow2(Lk);
Yplotted=fft(r,NFFTk2)/(Lk);
%Ysmod = Ysmod/max(abs(Ysmod));
Yplotted_dB=10*log10(abs(plotted));

ticksFk=fa2*linspace(0,1,NFFTk2);
p45=figure(45);
plot(ticksFk,Yplotted_dB);grid on;
% 
% subplot(413);
% stairs([1:0.02/Ta2]*Ta2,smod(1:0.02/Ta2));grid on;
% ylim([-1.1 1.1]);
% 
% subplot(414);
% hold on;
% plot(ticksFx4x2,[Ysmod_dB Ysmod_dB],'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% ylim([-50 0]);
% box on; 




% subplot(424);
% hold on;
% plot(ticksF,Ys2_dB,'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% ylim([-50 0]);
% box on; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abgestastete Schwingung bei fc
% auf x4 interpol und mit fa1 gemischt
% nach DA- Wandlung
% mischen auf 4*fa1
% subplot(423);
% hold on;
% plot(ticksFx4x2,[YSintbp_dB YSintbp_dB]+filDA4kdB,'b');grid on;
% plot(ticksFx4x2,filDA4kdB,'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','SouthEast');
% set(gca, 'Layer','bottom')
% ylim([-50 5]);
% box on; 
% 
% subplot(424);
% hold on;
% plot(ticksFx4x2,abs([YSintbp YSintbp].*filDA4k),'b','LineWidth',1);grid on;
% %plot(ticksFx4x2,imag([YSintbp YSintbp].*filDA4k),'b');grid on;
% plot(ticksFx4x2,abs(filDA4k),'r');grid on;
% %plot(ticksFx4x2,abs(filDA4k),'r');grid on;
% hold off;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['nach DA- Wandlung   fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa2,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta2,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(ySIntx4),'%i')...
%        '   NFFT: ' num2str(NFFTx2,'%i')...
%        ])
% legend('YSint\_dB','YSintConv\_dB','Location','North');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on; 
% 






% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Jetzt nochmal ohne interpolation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fa1=4*1000;
% Ta1=1/fa1;
% n=2^15-1;
% fc=100;
% t=[0:1:4*(n+1)-1]*Ta1;
% 
% yS=cos(2*pi*fc*t);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % fft
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L=n;
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% ticksF = fa1/2*linspace(0,2,NFFT);
% ticksFx2 = fa1/2*linspace(0,4,2*NFFT);
% ticksFx4 = fa1/2*linspace(0,8,4*NFFT);
% 
% Normierung='on';
% % Mischen mit Feinmischer f=fa1
% ySIntbp=ySInt.*cos(2*pi*fa1*t);
% % sin(x)/x Filter wegen S&H der Konvertierung
% filDA4k=sin(pi*(Ta2)*ticksFx4x2)./(pi*ticksFx4x2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     filDA1k=filDA1k/max(abs(filDA1k));
%     filDA4k=filDA4k/max(abs(filDA4k));
% end;
% filDA1kdB=10*log10(abs(filDA1k));
% filDA4kdB=10*log10(abs(filDA4k));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, fa1
% YS=fft(yS,NFFT)/(L);
% %YS=fftshift(YS/NFFT);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YS = YS/max(abs(YS));
% end;
% YS_dB=10*log10(abs(YS));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, fa2
% %YSx2=fft(ySx2,NFFTx2)/(2*L);
% %YSx2=fftshift(YSx2/NFFTx2);
% %YIQrf = YIQrf/max(abs(YIQrf));
% %YSx2_dB=10*log10(abs(YSx2));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, for interpoliert auf x2
% YSintx2=fft(ySIntx2,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSintx2 = YSintx2/max(abs(YSintx2));
% end;
% YSintx2_dB=10*log10(abs(YSintx2));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, interpoliert auf x4
% YSint=fft(ySInt,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSint = YSint/max(abs(YSint));
% end;
% YSint_dB=10*log10(abs(YSint));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% cos(fa1) mischen
% YSintbp=fft(ySIntbp,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSintbp=YSintbp/max(abs(YSintbp));
% end;
% YSintbp_dB=10*log10(abs(YSintbp));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% DA- Wandlung des interpolierten 
% % und gemischten signals
% ySIntbpDA=conv(ySIntbp(2:end-1),[0.5 1 0.5]);
% YSintbpDA=fft(ySIntbpDA,NFFTx2)/(2*L);
% %YSint=fftshift(YSint/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     ySIntbpDA=ySIntbpDA/max(abs(ySIntbpDA));
% end;
% YSintbpDA_dB=10*log10(abs(YSintbpDA));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Schwingungbei fc, conv fa2
% YSintConv=fft(conv(ySInt(2:end-1),[0.5 1 0.5]),NFFTx2)/(2*L);
% %YSintConv=fftshift(YSintConv/NFFTx2);
% if strcmp(Normierung,'ON') ||...
%    strcmp(Normierung,'on')
%     YSintConv=YSintConv/max(abs(YSintConv));
% end;
% YSintConv_dB=10*log10(abs(YSintConv));
% 
% 
% f2=figure(2);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% subplot(521);
% %plot(ticksFx4x2,[YS_dB YS_dB YS_dB YS_dB],'b');grid on;
% plot(ticksFx2,[YS_dB YS_dB],'b');grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
% legend('YS\_dB');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on;   
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Abgestastete Schwingung bei fc
% subplot(525);
% %plot(ticksFx4x2,[YS_dB YS_dB YS_dB YS_dB],'b');grid on;
% plot(ticksFx2,[YSintbp_dB],'b');grid on;
% xlabel('Frequency (Hz)')
% ylabel('| A(f) | in dB')
% title(['fc =' num2str(fc,'%.2f') ' Hz'...
%        '   fa =' num2str(fa1,'%.2f') ' Hz'...
%        '   Ta = ' num2str(Ta1,'%.5f') ' s'...
%        '   n Samples: ' num2str(length(t),'%i')...
%        '   NFFT: ' num2str(NFFT,'%i')...
%        ])
% legend('YS\_dB');
% set(gca, 'Layer','bottom')
% %ylim([-50 0]);
% box on;   


arr=sort(findall(0,'type','figure'));
%delete(arr(1:end-2))