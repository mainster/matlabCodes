% Programm cic_dezim_14_.m zur Parametrierung des Modells 
% cic_dezim4_.mdl 
% Literatur : [1] Matthew P. Donadio "CIC Filter Introduction"
%             [2] Ricardo A. Losada " Practical FIR Filter Design in
%             MATLAB"

clear

R = 5;    % Dezimierungsfaktor;   
M = 1;    % Differential Delay
N = 3;    % Anzahl Stufen

% ------- CFIR Entwurf
nord = 30;              % Ordnung des Filters
Npow = 5;               % Sinc power
w = 0.35;               % Sinc 'frequency factor'

Apass = 5.7565e-4;      % 0.01 dB Welligkeit
Astop = 0.01;           % 40 dB DŠmpfung
Aslope = 80;            % 80 dB Steigung
Fpass = 2*50/2000;      % Durchlassfrequenz 50 Hz bei fs = 10000/R Hz
cfir = firceqrip(nord, Fpass,[Apass, Astop],...
    'passedge','slope',Aslope,'invsinc',[w,Npow]);

% --------- Frequenzgang des CFIR-Filters relativ zu fs
nfft = 1024;
cfir_e = zeros(1, length(cfir)*R);
cfir_e(1:R:end) = cfir;
[Hcfir,w] = freqz(cfir_e,1,nfft,'whole',1);

% --------- Frequenzgang des idealen CIC-Filters
bcic = ones(1,R*M);   % Die aufgeloeste Form (8) aus [1]
% ohne die Potenzierung mit N
acic = 1;
[Hcic,w] = freqz(bcic,acic,nfft,'whole',1);
gain = (R*M)^N;
Hcic = (Hcic.^N)/gain;


%---------------------------------------------------
figure(1);   clf;
subplot(211); plot(w, 20*log10(abs(Hcfir)));
hold on;
plot(w, 20*log10(abs(Hcic)),'r');
hold off
xlabel('f/fs'' (fs'' = fs*R = 10000 Hz)');   grid;

title('Amplitudengang des CIC- und des CFIR-Filters');
La = axis;  axis([La(1:2), -150, 5]); 

subplot(212);
% Gesamt Frequenzgang
Hg = Hcic.*Hcfir;
plot(w, 20*log10(abs(Hg)));
xlabel('f/fs'' (fs'' = fs*R = 10000 Hz)');   grid;
title('Gesamter Amplitudengang (vor der Dezimierung)');
La = axis;  axis([La(1:2), -150, 5]); 

% -------- Zoom des Durchlassbereichs
figure(2);      clf;
nd = 1:nfft/4;

subplot(121), plot(w(nd), 20*log10(abs(Hg(nd))));
La = axis;  axis([La(1:2), -150, 5]); 
hold on
plot(w(nd), 20*log10(abs(Hcic(nd))),'r');
plot(w(nd), 20*log10(abs(Hcfir(nd))),'m');
title('Gesamter Amplitudengang (Zoom)');
xlabel('f/fs'' (fs'' = fs*R = 10000 Hz)');   grid;
hold off;
legend('CIC+CFIR', 'CIC', 'CFIR','Location','Southwest');

%--------------------------------
nd = 1:fix(nfft/4/20);
subplot(122), plot(w(nd), 20*log10(abs(Hg(nd))));
La = axis;  axis([La(1:2), -0.6, 0.2]); 
hold on
plot(w(nd), 20*log10(abs(Hcic(nd))),'r');
plot(w(nd), 20*log10(abs(Hcfir(nd))),'m');
title('Durchlassbereich (Zoom)');
xlabel('f/fs'' (fs'' = fs*R = 10000 Hz)');   grid;
hold off;
legend('CIC+CFIR', 'CIC', 'CFIR');

% -------- Fixed-Point CFIR
% Es wird das Filter cfir im Fixed-Point Format umgewandelt
cfir_fix = dfilt.dffir(cfir);

cfir_fix.arithmetic = 'fixed';
cfir_fix.FilterInternals = 'SpecifyPrecision';
cfir_fix.OutputWordLength = 32;
cfir_fix.OutputFracLength = 10;

cfir_fix.InputWordLength = 32;
cfir_fix.InputFracLength = 10;

cfir_fix.CoeffAutoScale = 0;
cfir_fix.CoeffWordLength = 16;
cfir_fix.NumFracLength = 15;

cfir_fix.RoundMode = 'Floor';
cfir_fix.OverflowMode = 'saturate';

cfir_fix.AccumWordLength = 64;
cfir_fix.AccumFracLength = 32;

cfir_fix.ProductWordLength = 64;
cfir_fix.ProductFracLength = 32;

hpsd = noisepsd(cfir_fix,10,'NormalizedFrequency', 0,...
              'Fs',2000); % Leistungsspektraldichte des Fehlers
% des quantisierten Filters bei Abtastfrequenz 2000 Hz
[Hcfir_fix,w] = freqz(cfir_fix.numerator,1,nfft); % Frequenzgang 
% des quantisierten Filters
[Hcfirn,w] = freqz(cfir,1,nfft);    % Frequenzgang des idealen 
% CFIR-Filters bei fs'

%---------------------------------------------------
figure(3);      clf;
subplot(211),
plot(w/pi, 20*log10([abs(Hcfir_fix),abs(Hcfirn)]));
xlabel('2*f/fs, fs = 2000 Hz');  grid on
title('Idealer und quantisierter CFIR-Filter');
legend('Quantisiertes','und ideales CFIR');

subplot(212),
plot(hpsd);
title('Leistungspektraldichte der Fehler des CFIR-Filters');
xlabel('2*f/fs, fs = 2000 Hz');  

% --------- Erzeugung des Filterblocks im Modell cic_dezim4.mdl 
block(cfir_fix, 'Destination','Current','Blockname','cfir_block',...
    'OverwriteBlock','on');

% --------- Aufruf der Simulation
sim('cic_dezim4_',[0,1]);
