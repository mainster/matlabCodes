%%%% Versuch Fax


delete(findall(0,'type','line'));


% DIS Nachricht - FSK
[xbandpassFull xbandpass xtiefpass fs]=fsk_darstellung;

%xbf=xbandpassFull;
xbf=xbandpassFull;

pix_filename='PIX.wav';
pix_path='/media/data/CODES/matlab_workspace/VersuchFax/';
[ypix,FSpix,NBITSpix,OPTSpix]=wavread([pix_path pix_filename]);

dis_filename='DIS.wav';
dis_path='/media/data/CODES/matlab_workspace/VersuchFax/';
[ydis,FSdis,NBITSdis,OPTSdis]=wavread([dis_path dis_filename]);

dcs_filename='DCS.wav';
dcs_path='/media/data/CODES/matlab_workspace/VersuchFax';
[ydcs,FSdcs,NBITSdcs,OPTSdcs]=wavread([dcs_path dcs_filename]);


fs=FSdis;
FS=fs;

% Länge der FFT die gerechnet werden soll
% ---------------------------------------
% entsprechend der möglichen Längen in Cool Edit
% 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536
NFFT=4096;

% Fensterfunktion die verwendet werden soll
% -----------------------------------------
% F�r die die noch kein DSV, TK etc. geh�rt haben: Die Fensterfunktion
% dient dazu das die R�nder bei der verwendeten L�nge der FFT ausge-
% blendet werden, M�gliche Fensterfunktionen:
% BARTLETT, BARTHANNWIN, BLACKMAN, BLACKMANHARRIS, BOHMANWIN, 
% CHEBWIN, GAUSSWIN, HAMMING, HANN = Hanning, KAISER, NUTTALLWIN, 
% PARZENWIN, RECTWIN, TRIANG, TUKEYWIN
Window_Funktion=hann(NFFT);

% �berlappung bei der FFT
% -----------------------
% OVERLAP=0             % keine �berlappung
% OVERLAP=NFFT-1;       % "Totale �berlappung"
% OVERLAP=NFFT/2;       % �berlapp bis zur halben L�nge der FFT
OVERLAP=NFFT/2;


% Mittenfrequenz (Carrier-Frequenz) der 2-FSK in [Hz]
% ---------------------------------------------------
f0=1750;

% ------------------------------------
% 1. Bildung komplexes Basisbandsignal
% ------------------------------------
ydis_bb=ydis.*exp(-j*2*pi*f0/FS*(1:length(ydis))');   % Spektrum um die Mittenfrequenz
ydcs_bb=ydcs.*exp(-j*2*pi*f0/FS*(1:length(ydcs))');   % Spektrum um die Mittenfrequenz
ypix_bb=ypix.*exp(-j*2*pi*f0/FS*(1:length(ypix))');   % Spektrum um die Mittenfrequenz


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 3 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f3=figure(3);
SUB=310;

subplot(SUB+2);
[l f] = psd(ydis_bb,NFFT,FS,Window_Funktion,OVERLAP);
f = f-FS/2;
l= fftshift(l);
plot(f,10*log10(l))
axis tight
title('Spektrale Leistungsdichte des um die Mittenfrequenz (1750Hz) verschobenen Signals');     grid on;
xlabel('f in [Hz]');
ylabel('[dB]');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hochmischen auf andere mitenfrequenz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f0mixUp=400;
%Y_mischUp=Y_misch.*exp(j*2*pi*f0mixUp/FS*(1:length(Y_misch))');   % Spektrum um die Mittenfrequenz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 4 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phaseDis_bb=atan2(imag(ydis_bb),real(ydis_bb));
phaseDis_bb_un=unwrap(phaseDis_bb);
freqDis_bb_mom=FSdis/(2*pi)*diff(phaseDis_bb_un);
tt=[0:1:length(ydis_bb)-1]/FSdis;

f4=figure(4);
SUB=310;

subplot(SUB+1);
plot(tt(1:end/400),phaseDis_bb(1:end/400));
grid on;
title('DIS');
subplot(SUB+2);
plot(tt(1:end/400),phaseDis_bb_un(1:end/400));
grid on;
subplot(SUB+3);
stem(freqDis_bb_mom(1:end/400));
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 5 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phaseDcs=atan2(imag(ydcs_bb),real(ydcs_bb));
phaseDcs_un=unwrap(phaseDcs);
freqDcs_mom=FSpix/(2*pi)*diff(phaseDcs_un);
tt=[0:1:length(ydcs)-1]/fs;

f5=figure(5);
SUB=310;
DIV=100;

subplot(SUB+1);
plot(tt(1:end/DIV),phaseDcs(1:end/DIV));
grid on;
title('DCS');
subplot(SUB+2);
plot(tt(1:end/DIV),phaseDcs_un(1:end/DIV));
grid on;
subplot(SUB+3);
stem(freqDcs_mom(1:end/DIV));
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Figure 6 %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phasePix=atan2(imag(ypix),real(ypix));
phasePix_un=unwrap(phasePix);
freqPix_mom=FSpix/(2*pi)*diff(phasePix_un);
tt=[0:1:length(ypix)-1]/FSpix;

f6=figure(6);
SUB=310;

subplot(SUB+1);
plot(tt(1:end/4000),phasePix(1:end/4000));
grid on;
title('PIX');
subplot(SUB+2);
plot(tt(1:end/4000),phasePix_un(1:end/4000));
grid on;
subplot(SUB+3);
stem(freqPix_mom(1:end/4000));
grid on;

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return;


% f=fopen(fname,'r+'); 
% fseek(f,20,0); 
% fwrite(f,[3 0]); 
% fclose(f); 
[yin3 FsIn3]=wavread('3.wav');
[yin31 FsIn31]=wavread('3_1.wav');

yin31(1:round(8.22*FsIn31))=[];

tt=linspace(0,length(yin31)/FsIn31,length(yin31));
%tt=linspace(0,length(yin31),length(yin31));
plot(tt,yin31)


