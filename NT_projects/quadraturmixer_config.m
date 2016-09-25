%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Simulation diskreter Quadraturmischer
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten

clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phaseSin = 0;  
phaseCos = 90*(180/pi);
f0=300;
fs=2000;
Ts = 1/fs;

sampleTime=Ts;
simulationTime=(2^15-1)*sampleTime;
siminA.time=([0:sampleTime:simulationTime]).';
siminB.time=([0:sampleTime:simulationTime]).';

fa=50; fb=100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Eingansdaten erzeugen 
%simin.signals.values = cos(2*pi*fbb*simin.time);
%simin.signals.values = chirp(simin.time,fa,simulationTime,fb).*cos(2*pi*fbb*simin.time);
siminA.signals.values =  chirp(siminA.time,fa,simulationTime,fb,[ ],0);
siminB.signals.values =  chirp(siminA.time,fa,simulationTime,fb,[ ],90);
%simin.signals.values = cos(2*pi*fbb*simin.time)+i*sin(2*pi*fbb*simin.time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Simulation Simulink-Modell
 sim('quadraturmischer.mdl');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ FFT-Analyse der modulierten Bitfolgen

% FFT-Parameter festlegen
L = length(inphase.signals.values)
Ts = simoutTime.signals.values(2)-simoutTime.signals.values(1);
Fs = fs
window = blackman(L);
NFFT = 2^nextpow2(L);
ticksF = Fs/2*linspace(-1,1,NFFT);
ticksFz = Fs/2*linspace(0,1,NFFT/2+1);

Yein = fft(siminA.signals.values,NFFT)/L;
Yein = fftshift(Yein/NFFT);
%Yein = Yein/max(abs(Yein));
YeindB = 10*log10(abs(Yein(end/2:end)));

Yi = fft(inphase.signals.values,NFFT)/L;
Yi = fftshift(Yi/NFFT);
%Yi = Yi/max(abs(Yi)); % Normierung
YidB = 10*log10(abs(Yi(end/2:end)));

Yh = fft(ht.signals.values,NFFT)/L;
Yh = fftshift(Yh/NFFT);
%Yh = Yh/max(abs(Yh)); % Normierung
YhdB = 10*log10(abs(Yh(end/2:end)));

Yhcos = fft(htcos.signals.values,NFFT)/L;
Yhcos = fftshift(Yhcos/NFFT);
%Yhcos = Yhcos/max(abs(Yhcos)); % Normierung
YhcosdB = 10*log10(abs(Yhcos(end/2:end)));

Yxcos = fft(xtcos.signals.values,NFFT)/L;
Yxcos = fftshift(Yxcos/NFFT);
%Yxcos = Yxcos/max(abs(Yxcos)); % Normierung
YxcosdB = 10*log10(abs(Yxcos(end/2:end)));

Yq = fft(quadratur.signals.values,NFFT)/L;
Yq = fftshift(Yq/NFFT);
%Yq = Yq/max(abs(Yq)); % Normierung
YqdB = 10*log10(abs(Yq(end/2:end)));

Yiq = fft(inphase.signals.values-quadratur.signals.values,NFFT)/L;
Yiq = fftshift(Yiq/NFFT);
%Yiq = Yiq/max(abs(Yiq)); % Normierung
YiqdB = 10*log10(abs(Yiq(end/2:end)));



p1=figure(1);
% BPSK

subplot(421);
plot(ticksFz, YeindB);grid('on');
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum F\_in' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])   

subplot(422);
%plot(ticksF, [flipud(YidB(1:end-1));YidB(1:end-1)]);grid('on');
plot(ticksFz, YxcosdB);grid('on');
grid(gca,'minor');
title('Verlauf BPSK');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum x*cos' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])
   
subplot(424);
%plot(ticksF, [flipud(YidB(1:end-1));YidB(1:end-1)]);grid('on');
plot(ticksFz, YhdB);grid('on');
grid(gca,'minor');
title('Verlauf BPSK');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum xh' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])

subplot(426);
%plot(ticksF, [flipud(YidB(1:end-1));YidB(1:end-1)]);grid('on');
plot(ticksFz, YhcosdB);grid('on');
grid(gca,'minor');
title('Verlauf BPSK');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum xhcos' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])

subplot(423);
plot(ticksFz, YidB);grid('on');
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum Inphase ' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])

subplot(425);
plot(ticksFz, YqdB);grid('on');
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum Quadratur ' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])
   
subplot(427);
plot(ticksFz, YiqdB);grid('on');
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
xlim([0 fs]*0.5);
%ylim([-50 0]);
title(['Spektrum I-Q' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      Ts = ' num2str(1/Ts,'%.3e') ' s'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Komplexer mischer, komplexes Basisband vorhanden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
fs=2000;
Ts=1/fs;
N=2^16;
t=([0:1:N-1]*Ts).';
fa=50;
fb=100;
flo=400;

%phi=90;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multitone- Generator TEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mt=[0:length(t)-1];
fmin=50;
fmax=60;
df=fmax-fmin;
k=0;
mt = chirp(t.',fmin+k*df,(length(t))*Ts,fmax+k*df,[ ],90);
for k=2:2:10
    mt = mt+chirp(t.',fmin+k*df,(length(t))*Ts,fmax+k*df,[ ],90);
end
%clear mt;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sIzf='chirp(t,fa,(length(t)*Ts),fb,[ ],0)';
sQzf='chirp(t,fa,(length(t)*Ts),fb,[ ],90)';

Izf=eval(sIzf);
Qzf=eval(sQzf);
LOsin=sin(2*pi*flo*t);
LOcos=cos(2*pi*flo*t);

%Izf=mt.';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hilbert- Transformierte durch Faltung TEST --> Funktioniert, nach Faltung
% muss die Hilbertransformierte um 20dB verstärkt werden...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gh=1/(pi*t);
gh=gh.';
%QzfConv=conv(Izf,gh);
%QzfConv=QzfConv(end/2:end) * 100;
QzfConv=Izf*(-i*sg;

%Qzf=QzfConv*1000;
Irf=Izf.*LOcos+Qzf.*LOsin;
Qrf=Qzf.*LOcos-Izf.*LOsin;
Irf=Izf.*LOcos;
Qrf=Qzf.*LOsin;
IrfNoQ=Izf.*LOcos+ 0 *Qzf.*LOsin;
QrfConv=QzfConv.*LOcos-Izf.*LOsin;

% FFT-Parameter festlegen
L = length(Izf);
Fs = fs;
NFFT = 2^nextpow2(L);
ticksF = Fs/2*linspace(-1,1,NFFT);
ticksFz = Fs/2*linspace(0,1,NFFT/2+1);

%%%%%%%%%% Multitone Spektrum %%%%%%%%%%
Ymt = fft(mt,NFFT)/L;
Ymt = fftshift(Ymt/NFFT);
%YIzf = YIzf/max(abs(YIzf));
YmtdB = 10*log10(abs(Ymt(end/2:end)));

p33=figure(33);
subplot(311)
plot(ticksFz,YmtdB);grid on;
subplot(312);
hold on;
plot(t(1:500),QzfConv(1:500),'g');grid on;
plot(t(1:500),Izf(1:500),'r');grid on;
plot(t(1:500),Qzf(1:500),'b');grid on;
hold off;
legend('QzfConv','Izf','Qzf');

YIzf = fft(Izf,NFFT)/L;
YIzf = fftshift(YIzf/NFFT);
%YIzf = YIzf/max(abs(YIzf));
YIzf_dB = 10*log10(abs(YIzf(end/2:end)));

YQzf = fft(Qzf,NFFT)/L;
YQzf = fftshift(YQzf/NFFT);
%YQzf = YQzf/max(abs(YQzf));
YQzf_dB = 10*log10(abs(YQzf(end/2:end)));

YQzfConv = fft(QzfConv,NFFT)/L;
YQzfConv = fftshift(YQzfConv/NFFT);
%YQzfConv = YQzfConv/max(abs(YQzfConv));
YQzfConv_dB = 10*log10(abs(YQzfConv(end/2:end)));

YIrf = fft(Irf,NFFT)/L;
YIrf = fftshift(YIrf/NFFT);
%YIrf = YIrf/max(abs(YIrf));
YIrf_dB = 10*log10(abs(YIrf(end/2:end)));

YIrfNoQ = fft(IrfNoQ,NFFT)/L;
YIrfNoQ = fftshift(YIrfNoQ/NFFT);
%YIrfNoQ = YIrfNoQ/max(abs(YIrfNoQ));
YIrfNoQ_dB = 10*log10(abs(YIrfNoQ(end/2:end)));

YQrf = fft(Qrf,NFFT)/L;
YQrf = fftshift(YQrf/NFFT);
%YQrf = YQrf/max(abs(YQrf));
YQrf_dB = 10*log10(abs(YQrf(end/2:end)));

YIQrf = fft(Irf+Qrf,NFFT)/L;
YIQrf = fftshift(YIQrf/NFFT);
%YIQrf = YIQrf/max(abs(YIQrf));
YIQrf_dB = 10*log10(abs(YIQrf(end/2:end)));

YIQrfConv = fft(Irf+QrfConv,NFFT)/L;
YIQrfConv = fftshift(YIQrfConv/NFFT);
%YIQrfConv = YIQrfConv/max(abs(YIQrfConv));
YIQrfConv_dB = 10*log10(abs(YIQrfConv(end/2:end)));

p2=figure(2);

subplot(321);
plot(ticksFz, YIzf_dB);grid('on');
grid(gca,'minor');
xlabel('Frequenz Hz');
%ylim([-40 5]);
ylabel('|A| in dB');
title(['Spektrum Izf(f)' ...
       '    ' sIzf...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      f_{LO} = ' num2str(flo,'%.2d') ' Hz'...
       ])

subplot(322);
hold on;
plot(ticksFz, YQzf_dB);grid('on');
plot(ticksFz, YQzfConv_dB,'r');grid('on');
hold off;
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
%ylim([-40 5]);
title(['Spektrum Qzf(f)' ...
       '    ' sQzf...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      f\_LO = ' num2str(flo,'%.2d') ' Hz'...
       ])

subplot(323);
plot(ticksFz, YIrf_dB);grid('on');
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
%ylim([-50 5]);
title(['Spektrum I\_rf(f)' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      f\_LO = ' num2str(flo,'%.2d') ' Hz'...
       ])

subplot(324);
plot(ticksFz, YQrf_dB);grid('on');
%hold on;
%plot(ticksFz, 10*log10(real(YQrf(end/2:end))));grid('on');
%plot(ticksFz, 10*log10(imag(YQrf(end/2:end))),'r');grid('on');
%hold off;
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
%ylim([-50 5]);
title(['Spektrum Q\_rf(f)' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      f\_LO = ' num2str(flo,'%.2d') ' Hz'...
       ])  
   
%subplot(3,2,[5 6]);
subplot(325);
hold on;
%plot(ticksFz, YIrfNoQ_dB,'r','LineWidth',2);grid('on');
plot(ticksFz, YIQrf_dB,'g','LineWidth',2);grid('on');
plot(ticksFz, YIQrfConv_dB,'r','LineWidth',1);grid('on');
hold off;
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
legend('YIQrf\_dB','YIQrfConv\_dB');
%ylim([-50 5]);
title(['Spektrum nach Quadraturmischung' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      f\_LO = ' num2str(flo,'%.2d') ' Hz'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])  

subplot(326);
hold on;
plot(ticksFz, YIrfNoQ_dB,'r','LineWidth',2);grid('on');
%plot(ticksFz, real(YIQrf_dB-YIQrfConv_dB),'g','LineWidth',2);grid('on');
%plot(ticksFz, imag(YIQrf_dB-YIQrfConv_dB),'r','LineWidth',2);grid('on');
hold off;
grid(gca,'minor');
xlabel('Frequenz Hz');
ylabel('|A| in dB');
legend('real(YIQrf\_dB-YIQrfConv\_dB)','imag(YIQrf\_dB-YIQrfConv\_dB)');
%ylim([-50 5]);
title(['Spektrum nach Quadraturmischung' ...
       '      Chirp = ' num2str(fa,'%d') ' ... ' num2str(fb,'%d') ' Hz'...
       '      fs =' num2str(fs,'%d') ' Hz'...
       '      f\_LO = ' num2str(flo,'%.2d') ' Hz'...
       '      n Samples: ' num2str(length(siminA.signals.values),'%i')...
       '      NFFT: ' num2str(NFFT,'%i')...
       ])  
   
% p3=figure(3);
% hold on;
% plot(t(1:1000),Izf(1:1000),'g');
% plot(t(1:1000),Qzf(1:1000),'r');
% hold off;


