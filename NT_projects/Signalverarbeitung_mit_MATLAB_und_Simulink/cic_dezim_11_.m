% Programm cic_dezim_11_.m zur Parametrierung des Modells 
% cic_dezim1_.mdl bzw. cic_dezim2_.mdl
% Literatur : [1] Matthew P. Donadio "CIC Filter Introduction"
%             [2] Ricardo A. Losada " Practical FIR Filter Design in
%             MATLAB"

clear

R = 5;    % Dezimierungsfaktor;   
M = 1;    % Differential Delay
N = 3;    % Anzahl Stufen

% ------- CFIR Entwurf
nord = 30;      % Ordnung des Filters
Npow = 5;       % Sinc power
w = 0.35;       % Sinc 'frequency factor'

Apass = 5.7565e-4;    % 0.01 dB Welligkeit
Astop = 0.01;         % 40 dB DŠmpfung
Aslope = 60;          % 60 dB Steigung
Fpass = 2*50/2000;     % Durchlassfrequenz 50 Hz bei fs = 10000/R Hz
cfir = firceqrip(nord, Fpass,[Apass, Astop],...
    'passedge','slope',Aslope,'invsinc',[w,Npow]);

% --------- Frequenzgaenge
nfft = 1024;
cfir_e = zeros(1, length(cfir)*R);
cfir_e(1:R:end) = cfir;

[Hcfir,w] = freqz(cfir_e,1,nfft,'whole',1);

figure(1);   clf;
subplot(211);

plot(w, 20*log10(abs(Hcfir)));

hold on;
% Frequenzgang des CIC-Filters
bcic = ones(1,R*M);   % Die aufgeloeste Form (8) aus [1]
% ohne die Potenzierung mit N
acic = 1;
[Hcic,w] = freqz(bcic,acic,nfft,'whole',1);
gain = (R*M)^N;
Hcic = (Hcic.^N)/gain;

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
title('Gesamter Amplitudengang (vor der Dezimierung)');
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

