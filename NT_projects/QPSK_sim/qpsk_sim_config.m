%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Simulation QPSK  
% Abgeleitet aus der Simulation GSM_VERSUCH Quint
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
close all hidden;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Parameter GMSK Simulation
SNR = 30;                                   % Signal zu Rausch-Abstand in dB
lengthOfSymbol = 32;                        % Parameter der �berabtastung/Symbol
phaseOffset = pi/4;                         % Phasenoffset d. Sendesymbole 
simulationTime =60-1;                        % Simulationszeit
sampleTime = 1;                             % Symbolzeit
%simin.time = [0:sampleTime:simulationTime]; % Zeitvektor
siminSymbolsRand.time = [0:sampleTime:simulationTime]; % Zeitvektor
siminSymbols1.time = [0:sampleTime:simulationTime]; % Zeitvektor
siminSymbols2.time = [0:sampleTime:simulationTime]; % Zeitvektor
siminSymbols3.time = [0:sampleTime:simulationTime]; % Zeitvektor
siminSymbols4.time = [0:sampleTime:simulationTime]; % Zeitvektor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Eingansdaten erzeugen (einen der Datens�tze ausw�hlen)

v1=[0;1;2;3;2;1];
v2=[0;1;3];
v3=[0;1;3;2];
v4=[0;2;3;1];

syms s1 s2 s3 s4;

s1=v1;
s2=v2;
s3=v3;
s4=v4;

%clear s1 s2 s3 s4
% zufällig
for n=1:(60/6)-1;  s1=[s1;v1];  end
for n=1:(60/3)-1;  s2=[s2;v2];  end
for n=1:(60/4)-1;  s3=[s3;v3];  end
for n=1:(60/4)-1;  s4=[s4;v4];  end

siminSymbolsRand.signals.values = (randi(4,1,length(siminSymbolsRand.time))-1).';
siminSymbols1.signals.values = s1; 
siminSymbols2.signals.values = s2; 
siminSymbols3.signals.values = s3; 
siminSymbols4.signals.values = s4; 

siminSymbols3.signals.values = s3; 

%simin.signals.values = ones(length(simin.time), 1); % Folge aus Einsen
% Aufgabe 4
% simin.signals.values = [0;0;1;0;1;0; zeros((length(simin.time)-12)/2, 1);1;1;1;1;1;0; zeros((length(simin.time)-12)/2, 1)];
%simin.signals.values = [1;0;1;0;1;0; zeros((length(simin.time)-12)/2, 1);1;0;1;0;1;0; zeros((length(simin.time)-12)/2, 1)];
%simin.signals.values = [1;1;1;1;1;0;1;1;0;0;1;0;1;0;0; zeros((length(simin.time)-30)/2, 1);0;0;0;1;1;0;1;1;0;0;1;0;1;0;0;  zeros((length(simin.time)-30)/2, 1)];
%simin.signals.values = [0;0;0; ones(57,1);0;0;1;0;0;0;1;1;1;1;0;1;1;0;1;0;0;0;1;0;0;0;1;1;1;1;0;  0; ones(57,1); 0;0;0];

%simin.signals.values = zeros(length(simin.time), 1); % Folge aus Nullen
% simin.signals.values = [ones(floor(length(simin.time)/2),1);zeros(ceil(length(simin.time)/2), 1)];% H�lfte der Bitfolge Einsen, Rest Nullen
%simin.signals.values = ((square(2*pi*simin.time/1.9999, 50)+1)/2)'; % wechselnd Null-Eins-Folge

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Simulation Simulink-Modell
 sim('QPSK_sim.mdl');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ FFT-Analyse der modulierten Bitfolgen

% FFT-Parameter festlegen
L = (simulationTime*lengthOfSymbol)+1
Ts = simoutTime.signals.values(2)-simoutTime.signals.values(1);
Fs = 1/Ts;
window = blackman(L);
NFFT = 2^nextpow2(L);
f = Fs/2*linspace(-1,1,NFFT);

% QPSK-Signal Rand
Y_QpskRand = fft(simoutQpskRand.signals.values.*window,NFFT)/L;
Y_QpskRand = Y_QpskRand/max(abs(Y_QpskRand)); % Normierung
Y_QpskRand_dB = 10*log10(abs( [Y_QpskRand(end/2:end);Y_QpskRand(1:end/2-1)] ).^2);
Y_QpskRand_dBff = 10*log10(abs( [Y_QpskRand(end/2:end);Y_QpskRand(1:end/2-1)] ));
% QPSK-Signal 1
Y_Qpsk1 = fft(simoutQpsk1.signals.values.*window,NFFT)/L;
Y_Qpsk1 = Y_Qpsk1/max(abs(Y_Qpsk1)); % Normierung
Y_Qpsk1_dB = 10*log10(abs([Y_Qpsk1(end/2:end);Y_Qpsk1(1:end/2-1)]).^2);
Y_Qpsk1_dBff = 10*log10(abs([Y_Qpsk1(end/2:end);Y_Qpsk1(1:end/2-1)]));
% QPSK-Signal Rand
Y_Qpsk2 = fft(simoutQpsk2.signals.values.*window,NFFT)/L;
Y_Qpsk2 = Y_Qpsk2/max(abs(Y_Qpsk2)); % Normierung
Y_Qpsk2_dB = 10*log10(abs([Y_Qpsk2(end/2:end);Y_Qpsk2(1:end/2-1)]).^2);
Y_Qpsk2_dBff = 10*log10(abs([Y_Qpsk2(end/2:end);Y_Qpsk2(1:end/2-1)]));
% QPSK-Signal Rand
Y_Qpsk3 = fft(simoutQpsk3.signals.values.*window,NFFT)/L;
Y_Qpsk3 = Y_Qpsk3/max(abs(Y_Qpsk3)); % Normierung
Y_Qpsk3_dB = 10*log10(abs([Y_Qpsk3(end/2:end);Y_Qpsk3(1:end/2-1)]).^2);
Y_Qpsk3_dBff = 10*log10(abs([Y_Qpsk3(end/2:end);Y_Qpsk3(1:end/2-1)]));
% QPSK-Signal Rand
Y_Qpsk4 = fft(simoutQpsk4.signals.values.*window,NFFT)/L;
Y_Qpsk4 = Y_Qpsk3/max(abs(Y_Qpsk4)); % Normierung
Y_Qpsk4_dB = 10*log10(abs([Y_Qpsk4(end/2:end);Y_Qpsk4(1:end/2-1)]).^2);
Y_Qpsk4_dBff = 10*log10(abs([Y_Qpsk4(end/2:end);Y_Qpsk4(1:end/2-1)]));
% 
% % RC- Shaper-Signal
% Y_RCshape = fft(simoutRCShaper.signals.values([1:L],1).*window,NFFT)/L;
% Y_RCshape = Y_RCshape/max(abs(Y_RCshape)); % Normierung
% Y_RCshape_dB = 10*log10(abs([Y_RCshape(end/2:end);Y_RCshape(1:end/2-1)]).^2);

% fg=figure(33)
% plot(f,Y_Bpsk_Int)

% zweiseitiges PSD Spektrum plotten
f1 = figure(1);
set(f1, 'Name', 'QPSK Leistungsdichtespektrum ');
subplot(321);
plot(f,Y_QpskRand_dB, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('Random');
subplot(322);
plot(f,Y_Qpsk1_dB, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v1');
subplot(323);
plot(f,Y_Qpsk2_dB, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v2');
subplot(324);
plot(f,Y_Qpsk3_dB, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v3');
subplot(325);
plot(f,Y_Qpsk4_dB, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);

legend('v4');
hold off;

title('normiertes Leistungsdichtespektrum \phi(f)');
xlabel('Frequenz / Hz');
ylabel('Leistung / dB');
grid('on');
ylim([-90;1]);
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);


% zweiseitiges Spektrum plotten
f3 = figure(3);
set(f3, 'Name', 'QPSK Spektrum ');
subplot(321);
plot(f,Y_QpskRand_dBff, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('Random');
subplot(322);
plot(f,Y_Qpsk1_dBff, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v1');
subplot(323);
plot(f,Y_Qpsk2_dBff, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v2');
subplot(324);
plot(f,Y_Qpsk3_dBff, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v3');
subplot(325);
plot(f,Y_Qpsk4_dBff, 'b') ;grid on;
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);
legend('v4');
hold off;

title('normiertes Spektrum');
xlabel('Frequenz / Hz');
ylabel('Leistung / dB');
ylim([-90;1]);
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);


% Einhüllende
f4 = figure(4);
set(f4, 'Name', 'Einhüllende');
subplot(321);
plot(simoutTime.signals.values, abs(simoutQpskRand.signals.values));grid on;
subplot(322);
plot(simoutTime.signals.values, abs(simoutQpsk1.signals.values));grid on;
subplot(323);
plot(simoutTime.signals.values, abs(simoutQpsk2.signals.values));grid on;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Plot zeitlicher Verlauf Phase

f2 = figure(2);
set(f2, 'Name', 'zeitlicher Verlauf Phase');

% QPSK
subplot(511);
plot(simoutTime.signals.values, angle(simoutQpskRand.signals.values).*(180/pi));grid on;
subplot(512);
plot(simoutTime.signals.values, angle(simoutQpsk1.signals.values).*(180/pi));grid on;
subplot(513);
plot(simoutTime.signals.values, angle(simoutQpsk2.signals.values).*(180/pi));grid on;
subplot(514);
plot(simoutTime.signals.values, angle(simoutQpsk3.signals.values).*(180/pi));grid on;
subplot(515);
plot(simoutTime.signals.values, angle(simoutQpsk4.signals.values).*(180/pi));grid on;
set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
title('Verlauf QPSK');
ylim([-200 200]);
xlabel('Zeit / T_s');
grid('on');
ylabel('Phase / �');



