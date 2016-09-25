% Matlab R2013a
%
% MATLAB kann ein Signal mit nur weißem Rauschen mit der Funktion wgn()
% generieren: my_noise = wgn(m, n, power); Der Rückgabewert von my_noise
% ist eine m-von-n-Matrix mit einem zufälligen Wert des weißen Rauschens.

%my_noise = wgn(100, 1, 1);

% MATLAB kann mithilfe der Funktion agwn() weißes Rauschen zu einem
% vorhandenen Signal hinzufügen: my_noisy_signal = awgn(my_signal, snr)

% Beim erzeugen von wave- dateien gibt es programme, die im wave- header
% einen fehlerhaften (oder einen matlab- unbekannten) "compression code"
% hinterlegen. 
% Der unbekannte "compression code" löst folgende Fehlermeldung beim 
% enlesen mit wavread() aus:
%
% ////////////////////////////////////////////////////////////////////////
% Data compression format (Format #65534) is not supported
% ////////////////////////////////////////////////////////////////////////
%
% Ein einfacher Workaround ist hier beschrieben:
%
% ////////////////////////////////////////////////////////////////////////
% http://social.msdn.microsoft.com/Forums/en-US/f58b74b4-8903-4801-8671-b100b2ab975d/cannot-load-the-wav-file-captured-by-audiocaptureraw-in-matlab?forum=kinectsdkaudioapi
% Changing the "compression code" to 0x0003 (eg. in a hex editor), you can
% now read the wav in matlab and it actually looks like a wave file in 4
% channels... A small matlab hack, that does the trick is:
% ////////////////////////////////////////////////////////////////////////

fname='wavefiles/Mjackson1000.wav';
f=fopen(fname,'r+');   % wave als raw file öffnen
fseek(f,20,0);         % filedescriptor f auf byte 20 im waveheader setzen
fwrite(f,[3 0]);       % "compression code" mit 0x03 überschreiben
fclose(f);             
[yin FsIn]=wavread(fname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));


yin=yin(0.5*FsIn:end,1);    % clear left channel, remove 0.5 sec quit time 
yin(20*FsIn:end)=[];        % cut wave vector to 20sec playback

% % weißes rauschen erzeugen, addieren
% yinN=awgn(yin,5,'measured');
% % hinteren Teil mit unverrauschtem Signal überschreiben
% yinN(round(end/2:end))=yin(round(end/2:end)); 

yinN=yin;
l10=round(length(yin)/6);

nsam=1.5*FsIn;    % nsam entspricht n sek.
SNRmax=10;
testVec=zeros(length(yin),1);

for i=1:5
    rangeM=[l10*i-nsam/2:l10*i+nsam/2];
    yinN(rangeM)=awgn(yin(rangeM),SNRmax-i,'measured');
    testVec(rangeM)=wgn(length(rangeM),1,i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 1 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
tt=[0:1:length(yin)-1]*1/FsIn;
plot(tt,testVec);
title('Rauschsignal, welches der Jackson wave aufaddiert wird')
grid on;

mpl=audioplayer(yinN,FsIn);   % erzeuge audioplayer object mpl
play(mpl)                     % play wave stored in y from beginning to end

L=FsIn;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
YIN = fft(yin,NFFT)/L;
YINN = fft(yinN,NFFT)/L;
f = FsIn/2*linspace(0,1,NFFT/2+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 2 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
SUB=210;
% Plot single-sided amplitude spectrum.
subplot(SUB+1);
plot(f,2*abs(YIN(1:NFFT/2+1)));
grid on;
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

subplot(SUB+2);
plot(f,2*abs(YINN(1:NFFT/2+1)));
grid on;
title('Single-Sided Noisy Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

huellIn=abs(hilbert(yin));
huell9=abs(hilbert(yinN));
corHuell = xcorr(huellIn, huell9); 

cor9 = xcorr(yin, yin); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 3 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
clf('reset');

hold all;
plot(corHuell);
plot(cor9);
hold off;
grid on;
legend('corrHuell','corr');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verschobene aufnahmen erzeugen und per xcorr verschiebung
% in sek bestimmen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l1=length(yin);
% hinteren 90% nach ys9 kopieren und den Anfang hinten anhängen
ys9=[yin(end-0.9*l1:end); yin(1:end-0.9*l1)];     % 0.1*20sek sek nach rechts verschoben
% hinteren 80% nach ys8 kopieren und den Anfang hinten anhängen
ys8=[yin(end-0.8*l1:end); yin(1:end-0.8*l1)];     % 0.2*20sek sek nach rechts verschoben

clear huell1 huell2;

%huellIn=abs(hilbert(yin));
%huell9=abs(hilbert(ys9));
%huell8=abs(hilbert(ys8));

huellIn=abs(hilbert(awgn(yin,1,'measured')));
huell9=abs(hilbert(awgn(ys9,1,'measured')));
huell8=abs(hilbert(awgn(ys8,1,'measured')));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 4 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f4=figure(4);
SUB=220;

tt=[0:1:length(yin)-1]*1/FsIn;

subplot(SUB+1);
plot(tt,huellIn);
xlabel('t [sek]')
subplot(SUB+2);
plot(tt,huell9);
xlabel('t [sek]')

subplot(SUB+3);
plot(tt,yin);
grid on;
xlabel('t [sek]')
subplot(SUB+4);
plot(tt,ys9);
grid on;
xlabel('t [sek]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 5 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f5=figure(5);
SUB=220;

tt2=linspace(-length(yin)*1/FsIn,length(yin)*1/FsIn,2*length(yin)-1);
corH9=xcorr(huellIn,huell9);
corH8=xcorr(huellIn,huell8);
cor9=xcorr(yin,ys9);
cor8=xcorr(yin,ys8);

corH9=corH9/max(corH9);
corH8=corH8/max(corH8);

subplot(SUB+1);
plot(tt2,corH9);
title(sprintf('xcorr original- wave und um 2 sek.\n nach rechts verschobene wave'))
grid on;

subplot(SUB+2);
plot(tt2,cor9);
grid on;

subplot(SUB+3);
plot(tt2,corH8);
title(sprintf('xcorr original- wave und um 4 sek.\n nach rechts verschobene wave'))
grid on;

subplot(SUB+4);
plot(tt2,cor8);
grid on;

ar=sort(findall(0,'type','figure'));    % alle figure handles suchen 
set(ar,'WindowStyle','docked');         % Dock figure windows

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aufnahme verrauschen 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l1=length(yin);
% hinteren 90% nach ys kopieren und den Anfang hinten anhängen
% ys9=[yin(end-0.9*l1:end); yin(1:end-0.9*l1)];     % 0.1*20sek sek nach rechts verschoben
% ys8=[yin(end-0.8*l1:end); yin(1:end-0.8*l1)];     % 0.2*20sek sek nach rechts verschoben

clear huell1 huell2;

huellIn=abs(hilbert(yin));
huellNoise=abs(hilbert(yinN));

corInNoise=xcorr(yin,yinN);
corInNoiseH=xcorr(huellIn,huellNoise);

f6=figure(6);
SUB=220;

hold all;
psd(yin);
psd(yinN);
psd(wgn(100,1,0))
hold off;
legend('yin', 'yinNoisy','wgn(100,1,0)');

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');








