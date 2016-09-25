% Programm cic_interp_1_.m zur Parametrierung des Modells 
% cic_interp1_.mdl 
% Literatur : [1] Matthew P. Donadio "CIC Filter Introduction"
%             [2] Ricardo A. Losada " Practical FIR Filter Design in
%             MATLAB"

clear

R = 5;    % Interpolierungsfaktor;   
M = 1;    % Differential Delay
N = 3;    % Anzahl Stufen

% ------- CFIR Entwurf
nord = 40;      % Ordnung des Filters
Npow = 5;       % Sinc power
w = 0.1;        % Sinc 'frequency factor'

Apass = 5.7565e-4;    % 0.01 dB Welligkeit
Astop = 0.01;         % 40 dB DŠmpfung
Aslope = 60;          % 60 dB Steigung
Fpass = 2*50/2000;     % Durchlassfrequenz 50 Hz bei fs = 10000/R Hz
cfir = firceqrip(nord, Fpass,[Apass, Astop],...
    'passedge','slope',Aslope,'invsinc',[w,Npow]);

% --------- Frequenzgang des CFIR-Filters relativ zu fs'
nfft = 2048;
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
xlabel('f/fs''');   grid;
title('Amplitudengang des CIC- und des CFIR-Filters');
La = axis;  axis([La(1:2), -150, 5]); 

subplot(212);
% Gesamt Frequenzgang
Hg = Hcic.*Hcfir;
plot(w, 20*log10(abs(Hg)));
xlabel('f/fs');   grid;
title('Gesamter Amplitudengang (nach der Interpolierung)');
La = axis;  axis([La(1:2), -150, 5]); 

% -------- Zoom des Durchlassbereichs
figure(2);      clf;
nd = 1:nfft/4;

subplot(121), plot(w(nd), 20*log10(abs(Hg(nd))));
La = axis;  axis([La(1:2), -150, 5]); 
hold on
plot(w(nd), 20*log10(abs(Hcic(nd))),'r');
title('Gesamter Amplitudengang (Zoom)');
xlabel('f/fs');   grid;
hold off;
legend('CIC+CFIR', 'CIC');

%--------------------------------
nd = 1:fix(nfft/4/20);
subplot(122), plot(w(nd), 20*log10(abs(Hg(nd))));
La = axis;  axis([La(1:2), -0.6, 0.2]); 
hold on
plot(w(nd), 20*log10(abs(Hcic(nd))),'r');
title('Durchlassbereich (Zoom)');
xlabel('f/fs');   grid;
hold off;
legend('CIC+CFIR', 'CIC');

% -------- Fixed-Point CFIR
% Es wird das Filter cfir im Fixed-Point Format umgewandelt
cfir_fix = dfilt.dffir(cfir);

cfir_fix.arithmetic = 'fixed';
cfir_fix.FilterInternals = 'SpecifyPrecision';
cfir_fix.OutputWordLength = 16;
cfir_fix.OutputFracLength = 15;

cfir_fix.InputWordLength = 16;
cfir_fix.InputFracLength = 15;

cfir_fix.RoundMode = 'Floor';
cfir_fix.OverflowMode = 'saturate';

cfir_fix.AccumWordLength = 32;
cfir_fix.AccumFracLength = 30;

cfir_fix.ProductWordLength = 32;
cfir_fix.ProductFracLength = 30;

hpsd = noisepsd(cfir_fix,20);       % Leistungsspektraldichte des Fehlers
% des quantisierten Filters
[Hcfir_fix,w] = freqz(cfir_fix.numerator,1,nfft); % Frequenzgang 
% des quantisierten Filters
[Hcfirn,w] = freqz(cfir,1,nfft);    % Frequenzgang des idealen 
% CFIR-Filters bei fs'

%---------------------------------------------------
figure(3);      clf;
plot(w/pi, 20*log10([abs(Hcfir_fix),abs(Hcfirn)]));
hold on
plot(hpsd);
title('CFIR-Filter und Leistungspektraldichte der Fehler des CFIR-Filters');
hold off
legend('Quantisiertes','und ideales CFIR');

% --------- Erzeugung des Filterblocks im Modell cic_dezim4.mdl 
block(cfir_fix, 'Destination','Current','Blockname','cfir_block',...
    'OverwriteBlock','on');

% ------- Berechnung der Bit Growth füŸr die Stufen
i = 1:N;
Gi1 = 2.^i

i = N+1:2*N;
Gi2 = (2.^(2*N-i)).*R.^(i-N-1) 

Bin = 1;
WN = fix(Bin+log2(Gi2))

% -------- Aufruf der Simulation
%sim('cic_interp1_',[0,1]);
sim('cic_interp2_',[0,1]);
