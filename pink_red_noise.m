%% Spektrum von rosa und rotem Rauschen (1/f, 1/f.^2) plotten und vergleichen
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isOpen = matlabpool('size') > 0;
c = parcluster('LocalProfileX58AUD7');

if ~isOpen
	matlabpool open 4;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global Wpsd Npsd Rpsd Ppsd ff COL_PINK COL_WHITE COL_RED
PICPATH='/media/storage/data_notebook/HS_Karlsruhe/steffiHS/Masterarbeit_Jonas/bilder_thesis_steffi/';

COL_PINK = [1 0 1];
COL_PINK = [1 125/255 1];
COL_WHITE = [1 1 1]*145/255;
COL_RED = [1 0 0];
COL_MIX = [[1 1 1]+COL_PINK+COL_RED];
COL_MIX = COL_MIX ./max(COL_MIX);
%%
fs = 500e3;		% Abtastfrequenz 
NFFT = 2^22;	% gewünschte FFT-Länge 
				% N=2^x, sonst wird der DFT-Algorithmus verwendet!
ff = fs/2*linspace(0,1,NFFT/2+1);	% Frequenzvektor für psds
% ---------------------------------------------- 
% Erzeugung eines Datensatzes mit N Abtastwerten 
% ---------------------------------------------- 
tt = [0:1/fs:(NFFT-1)/fs];
wn = randn(1,length(tt));		% zeitsignal mit weißem rauschen
pn = 1.2*pinknoise(length(tt));		% zeitsignal mit rosa rauschen
rn = 10*sqrt(12)*rednoise(length(tt));		% zeitsignal mit rotem rauschen
% rn = 10*rednoise(length(tt));		% zeitsignal mit rotem rauschen
nf=wn.*pn.*rn;
nf=wn+pn+rn;
% ---------------------------------------------- 

% NFFT_calc nur zur Kontrolle. Da der Zeitvektor schon auf die
% Länge eines ganzzahligen Exponents zur Basis 2 erzeugt wurde,
% (FFT- Länge NFFT=2^x) muss NFFT_calc == NFFT sein

NFFT_calc = 2^nextpow2(length(pn));	% Next power of 2 from length of y
if NFFT_calc ~= NFFT
	fprintf('NFFT: \t\t%g aber\nNFFT_calc: \t%g\n',NFFT,NFFT_calc)
	NFFT = NFFT_calc;
	fprintf('NFFT neu: \t%g\n',NFFT)
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%		Welch's power spectral density estimate
%
%		pxx = pwelch(x,window,noverlap,nfft)
%		replacement for depricatad dspdata.psd(___)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
segmentlength=50;
seglen = segmentlength;

%Wpsd{:,k} = pwelch(wn,seglen,20,seglen,fs);  
% Wpsd = pwelch(wn);  
% Ppsd = pwelch(pn);  
% Rpsd = pwelch(rn);  
%% PSD
Wxx = abs(fft(wn,NFFT)).^2/length(wn)/fs;		% PSD of white noise
Pxx = abs(fft(pn,NFFT)).^2/length(pn)/fs;		% PSD of pink noise
Rxx = abs(fft(rn,NFFT)).^2/length(rn)/fs;		% PSD of red noise
Nxx = abs(fft(nf,NFFT)).^2/length(nf)/fs;		% PSD of red noise

% Create a single-sided PSD
Wpsd = dspdata.psd(Wxx(1:length(Wxx)/2),'fs',fs);  
%Wpsd = pwelch(wn,[],[],NFFT-1);
Ppsd = dspdata.psd(Pxx(1:length(Pxx)/2),'fs',fs);  
Rpsd = dspdata.psd(Rxx(1:length(Rxx)/2),'fs',fs); 
Npsd = dspdata.psd(Nxx(1:length(Nxx)/2),'fs',fs); 

%% %%%%%%%%%%%%%%%%%% !!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pegel normieren auf 0dB@1kHz
% index von 1e3:end/2 weil zweiseitiges Spektrum und max() dann
% am ende den selben Wert wie bei 0Hz findet als maximum
% pinkNoiseSpecN = pinkNoiseSpec./(max(pinkNoiseSpec(1e3:end/2)));	% Pegel auf 0dB normieren
% redNoiseSpecN = redNoiseSpec./(max(redNoiseSpec(1e3:end/2)));	% Pegel auf 0dB normieren
%%%%%%%%%%%%%%%%%%%%% !!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
SUB=120;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot single-sided amplitude spectrum.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2 = figure(2); clf;
% plot(ff, 10*log10(abs(whiteNoiseSpec(1:NFFT/2+1))));		% spektrum white noise
% plot(ff, 10*log10(abs(pinkNoiseSpec(1:NFFT/2+1))));		% spektrum pink noise
% plot(ff, 10*log10(abs(redNoiseSpec(1:NFFT/2+1))));		% spektrum red noise
% subplot(SUB+1); 
hold all;

ff=[0:fs/(2*length(Ppsd.Data)):fs/2-fs/(2*length(Ppsd.Data))];
plot(ff,10*log10(Wpsd.Data),'Color',COL_WHITE); grid on;
% plot(ff,10*log10(Wpsd)); grid on;
plot(ff,10*log10(Ppsd.Data),'Color',COL_PINK); grid on;
plot(ff,10*log10(Rpsd.Data),'Color',COL_RED); grid on;
set(gca,'XScale','log','Layer','Top');
title('Spektrale Leistungsdichte einiger Rauschanteile')
box on;
xlabel('Frequenz / Hz');
ylabel('abs(Lnn(f)) / dB');
%hl=legend(sprintf('white noise\n 1/f'),sprintf('pink noise\n1/f2'),sprintf('red noise'));
hl=legend('{ white noise }','{ pink noise 1/f }','{ red noise 1/f^2 }');
% set(hl,'DataAspectRatio',[1 2 2])
set(hl,'FontName','Arial');
xlim([995 fs/2]);
ylim([-60 -30]);

pic{1}=[PICPATH get(get(gca,'Title'),'String') '.png'];
export_fig pic1.png -painters -r250 -transparent -nocrop



f3 = figure(3); clf;

% subplot(SUB+2); 
hold all;

plot(ff,10*log10(Npsd.Data),'Color','blue'); grid on;
title('Qualitativer Rauschteppich von elektronischen Schaltungen')
xlabel('Frequenz / Hz');
ylabel('| Lnn(f) | / dB');
hl2=legend({ sprintf('Grundrauschen\n(intrinsic noise floor)') });
set(gca,'XScale','log','Layer','Top');
box on;
xlim([1e3 fs/2]);
ylim([-60 -30]);


% Create line
annotation(figure1,'line',[0.459895833333333 0.9046875],[0.415 0.415],...
	'LineStyle','--',...
	'LineWidth',3,...
	'Color',[1 0 0]);

% Create line
annotation(figure1,'line',[0.130729166666667 0.552083333333333],...
	[0.821428571428571 0.372670807453416],'LineStyle','--','LineWidth',3,...
	'Color',[1 0 0]);

% Create line
annotation(figure1,'line',[0.513 0.513],[0.114906832298136 0.51],...
	'LineStyle','--',...
	'LineWidth',3,...
	'Color',[1 0 0]);

% Create textarrow
annotation(figure1,'textarrow',[0.626420454545455 0.51875],...
	[0.607228915662651 0.430124223602484],'TextEdgeColor','none','TextLineWidth',3,...
	'TextBackgroundColor',[0.831372559070587 0.815686285495758 0.7843137383461],...
	'FontWeight','demi',...
	'FontSize',16,...
	'String',{'1/f- Eckfrequenz'},...
	'HeadLength',15,...
	'HeadWidth',15,...
	'LineWidth',3,...
	'Color',[1 0 0]);


pic{2}=[PICPATH get(get(gca,'Title'),'String') '.png'];
export_fig pic2.png -painters -r250 -transparent -nocrop
%%
for k=1:length(pic)
	pic{k} = strrep(pic{k},' ','_');
	movefile(sprintf('pic%i.png',k), pic{k});
end
return








% xlim([1 fs/2]);
%%
subplot(SUB+2); hold all;
plot(10*log10(Ppsd));
 set(gca,'XScale','log');
% xlim([1 fs/2]);

subplot(SUB+3); hold all;
plot(10*log10(Rpsd));
set(gca,'XScale','log');
% xlim([1 fs/2]);
% ylim([5e-5, 5e-3])
% xlim([1,1e3])

% 
return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs = 2e3;		% Abtastfrequenz 
NFFT = 2^21;	% gewünschte FFT-Länge 
				% N=2^x, sonst wird der DFT-Algorithmus verwendet!
df = fs/NFFT;	% Frequenzauflösung 

% ---------------------------------------------- 
% Erzeugung eines Datensatzes mit N Abtastwerten 
% ---------------------------------------------- 
tt = [0:1/fs:(NFFT-1)/fs];
wn = wgn(1,length(tt),0);		% zeitsignal mit weißem rauschen
pn = pinknoise(length(tt));		% zeitsignal mit rosa rauschen
rn = rednoise(length(tt));		% zeitsignal mit rotem rauschen
% ---------------------------------------------- 
% pn=pn./max(max([pn', rn'],[],1));
% rn=rn./max(max([pn', rn'],[],1));

if 0
	f1 = figure(1); clf;
	hold all;
	plot(tt,pn); 
	plot(tt,rn);
	hold off; grid on;
	title('noise - time domain');
	xlabel('t/s');
	legend('pink noise, 1/f', 'red noise, 1/f^2')
end

% NFFT_calc nur zur Kontrolle. Da der Zeitvektor schon auf die
% Länge eines ganzzahligen Exponents zur Basis 2 erzeugt wurde,
% (FFT- Länge NFFT=2^x) muss NFFT_calc == NFFT sein

NFFT_calc = 2^nextpow2(length(pn));	% Next power of 2 from length of y
if NFFT_calc ~= NFFT
	fprintf('NFFT: \t\t%g aber\nNFFT_calc: \t%g\n',NFFT,NFFT_calc)
	NFFT = NFFT_calc;
	fprintf('NFFT neu: \t%g\n',NFFT)
end

whiteNoiseSpec = fft(wn,NFFT)/length(wn);		% fft white noise
pinkNoiseSpec = fft(pn,NFFT)/length(pn);		% fft pink noise
redNoiseSpec = fft(rn,NFFT)/length(rn);			% fft red noise
%% PSD
Wxx = abs(fft(wn,NFFT)).^2/length(wn)/fs;		% PSD of white noise
Pxx = abs(fft(pn,NFFT)).^2/length(pn)/fs;		% PSD of pink noise
Rxx = abs(fft(rn,NFFT)).^2/length(rn)/fs;		% PSD of red noise

% Create a single-sided PSD
Wpsd = dspdata.psd(Wxx(1:length(Wxx)/2),'fs',fs);  
Ppsd = dspdata.psd(Pxx(1:length(Pxx)/2),'fs',fs);  
Rpsd = dspdata.psd(Rxx(1:length(Rxx)/2),'fs',fs);  

ff = fs/2*linspace(0,1,NFFT/2+1);	% Frequenzvektor für fft Spektren
ffp = fs/2*linspace(0,1,NFFT/2);	% Frequenzvektor für psd Spektren

% fflog = logspace(0,log10(fs/2),NFFT/2+1);

% pinkNoiseSpec=pnf;
% redNoiseSpec=rnf;
% pinkNoiseSpec = mag2db( fftshift(abs(pnf)/NFFT) );
% redNoiseSpec = mag2db( fftshift(abs(rnf)/NFFT) );

% finde index der ersten NN Komponenten die kleiner sind als -20dB
% idx = find(pinkNoiseSpec < db2mag(-20),5,'first');
% pinkNoiseSpec = pinkNoiseSpec(idx(end):end/2);		% kürzen auf Werte <-20dB
% redNoiseSpec = redNoiseSpec(idx(end):end/2);		% kürzen auf Werte <-20dB

%% %%%%%%%%%%%%%%%%%% !!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pegel normieren auf 0dB@1kHz
% index von 1e3:end/2 weil zweiseitiges Spektrum und max() dann
% am ende den selben Wert wie bei 0Hz findet als maximum
% pinkNoiseSpecN = pinkNoiseSpec./(max(pinkNoiseSpec(1e3:end/2)));	% Pegel auf 0dB normieren
% redNoiseSpecN = redNoiseSpec./(max(redNoiseSpec(1e3:end/2)));	% Pegel auf 0dB normieren
%%%%%%%%%%%%%%%%%%%%% !!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
SUB=220;
% Plot single-sided amplitude spectrum.
f2 = figure(2); clf;
subplot(SUB+1);
hold all;
plot(ff, 10*log10(abs(whiteNoiseSpec(1:NFFT/2+1))));		% spektrum white noise
plot(ff, 10*log10(abs(pinkNoiseSpec(1:NFFT/2+1))));		% spektrum pink noise
plot(ff, 10*log10(abs(redNoiseSpec(1:NFFT/2+1))));		% spektrum red noise
set(gca,'XScale','log');
xlim([1 fs/2]);
% ylim([5e-5, 5e-3])
% xlim([1,1e3])

hold off; grid on;
title('Amplitude spectrum');
xlabel('f/Hz');
ylabel('Magnitude [dB]');
legend('white noise','pink noise, 1/f', 'red noise, 1/f^2')

subplot(SUB+2);	hold all;
plot(ff, 10*log10(abs(whiteNoiseSpec(1:NFFT/2+1))));		% spektrum white noise
plot(ff, 10*log10(abs(pinkNoiseSpec(1:NFFT/2+1))));		% spektrum pink noise
plot(ff, 10*log10(abs(redNoiseSpec(1:NFFT/2+1))));		% spektrum red noise
set(gca,'XScale','log');
% xlim([1e3 50e3]);
hold off;
%%
subplot(SUB+3);	hold all;
plot(ffp, 10*log10(Wpsd.Data));					% PSD white noise
plot(ffp, 10*log10(Ppsd.Data));					% PSD pink noise
plot(ffp, 10*log10(Rpsd.Data));					% PSD red noise
set(gca,'XScale','log');
xlim([1 fs/2]);
hold off;

%%
subplot(SUB+4);
cla; hold all;
f0=1;
% %%%%%%%%%%%%%%%%%% !!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pegel normieren auf 0dB@f0
% index von 1e3:end/2 weil zweiseitiges Spektrum und max() dann
% am ende den selben Wert wie bei 0Hz findet als maximum
% pinkNoiseSpecN = pinkNoiseSpec./(max(pinkNoiseSpec(1e3:end/2)));	% Pegel auf 0dB normieren
% redNoiseSpecN = redNoiseSpec./(max(redNoiseSpec(1e3:end/2)));	% Pegel auf 0dB normieren
%%%%%%%%%%%%%%%%%%%%% !!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%
maxes = max([	Wpsd.Data(f0:end/2),...
				Ppsd.Data(f0:end/2),...
				Rpsd.Data(f0:end/2)],[],1)
plot(ffp, 10*log10(Wpsd.Data/maxes(1))); set(gca,'XScale','log');					% PSD white noise
plot(ffp, 10*log10(Ppsd.Data/maxes(2)));	 set(gca,'XScale','log');				% PSD pink noise
plot(ffp, 10*log10(10000*Rpsd.Data/maxes(3)));set(gca,'XScale','log');					% PSD red noise
set(gca,'XScale','log');
xlim([1 fs/2]);
ylim([-240 -20]);
line(10*[1 1],[-240 -20],'LineWidth',2,'Color',[1 1 1 ]*.6)
line(100*[1 1],[-240 -20],'LineWidth',2,'Color',[1 1 1 ]*.6)
line([1 fs/2],-40*[1 1],'LineWidth',2,'Color',[1 1 1 ]*.6)
line([1 fs/2],-60*[1 1],'LineWidth',2,'Color',[1 1 1 ]*.6)
grid on;
hold off;

subplot(SUB+3);
cla; hold all;
plot(ffp, 10*log10(Wpsd.Data)); set(gca,'XScale','log');					% PSD white noise
plot(ffp, 10*log10(Ppsd.Data));	 set(gca,'XScale','log');				% PSD pink noise
plot(ffp, 10*log10(Rpsd.Data));set(gca,'XScale','log');					% PSD red noise
set(gca,'XScale','log');
xlim([1 fs/2]);
ylim([-240 -20]);
line(10*[1 1],[-240 -20],'LineWidth',2,'Color',[1 1 1 ]*.6)
line(100*[1 1],[-240 -20],'LineWidth',2,'Color',[1 1 1 ]*.6)
for k=-20:-20:-200
	line([1 fs/2],k*[1 1],'LineWidth',2,'Color',[1 1 1 ]*.6)
end
hold off;

