%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Simulation Versuch GSM  
%   - Vorlesung: Nachrichtentechnik 1
%   - Dozent:    Prof. Dr.-Ing. Franz Quint
%   - Autoren:   Konrad Benedikt, Philipp Fetzer
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
close all hidden;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Parameter GMSK Simulation
SNR = 20;                                   % Signal zu Rausch-Abstand in dB
lengthOfSymbol = 64;                        % Parameter der �berabtastung/Symbol
phaseOffset = pi/4;                         % Phasenoffset d. Sendesymbole 
simulationTime =147;                        % Simulationszeit
sampleTime = 1;                             % Symbolzeit
simin.time = [0:sampleTime:simulationTime]; % Zeitvektor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Eingansdaten erzeugen (einen der Datens�tze ausw�hlen)
simin.signals.values = ceil(2*rand(length(simin.time),1))-1; % zuf�llige Folge Matlab 
% simin.signals.values = ones(length(simin.time), 1); % Folge aus Einsen
% simin.signals.values = zeros(length(simin.time), 1); % Folge aus Nullen
% simin.signals.values = [ones(floor(length(simin.time)/2),1);zeros(ceil(length(simin.time)/2), 1)];% H�lfte der Bitfolge Einsen, Rest Nullen
% simin.signals.values = ((square(2*pi*simin.time/1.9999, 50)+1)/2)'; % wechselnd Null-Eins-Folge

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Simulation Simulink-Modell
 sim('GSM_sim_orig.mdl');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ FFT-Analyse der modulierten Bitfolgen

% FFT-Parameter festlegen
L = length(simoutGmsk.signals.values);
Ts = simoutTime.signals.values(2)-simoutTime.signals.values(1);
Fs = 1/Ts;
window = blackman(L);
NFFT = 2^nextpow2(L);
f = Fs/2*linspace(-1,1,NFFT);

% GMSK-Signal
Y_Gmsk = fft(simoutGmsk.signals.values.*window,NFFT)/L;
Y_Gmsk = Y_Gmsk/max(abs(Y_Gmsk)); % Normierung
Y_Gmsk_dB = 10*log10(abs([Y_Gmsk(end/2:end);Y_Gmsk(1:end/2-1)]).^2);

% MSK-Signal
Y_Msk = fft(simoutMsk.signals.values.*window,NFFT)/L;
Y_Msk = Y_Msk/max(abs(Y_Msk)); % Normierung
Y_Msk_dB = 10*log10(abs([Y_Msk(end/2:end);Y_Msk(1:end/2-1)]).^2);

% BPSK-Signal
Y_Bpsk = fft(simoutBpsk.signals.values.*window,NFFT)/L;
Y_Bpsk = Y_Bpsk/max(abs(Y_Bpsk)); % Normierung
Y_Bpsk_dB = 10*log10(abs([Y_Bpsk(end/2:end);Y_Bpsk(1:end/2-1)]).^2);

% zweiseitiges Spektrum plotten
f1 = figure(1);
set(f1, 'Name', 'Leistungsdichtespektrum ');
plot(f,Y_Bpsk_dB, 'g') ;
hold on;
plot(f,Y_Msk_dB, 'r') ;
plot(f,Y_Gmsk_dB, 'b'); 
hold off;
legend('BPSK', 'MSK', 'GMSK');
title('normiertes Leistungsdichtespektrum \phi(f)');
xlabel('Frequenz / Hz');
ylabel('Leistung / dB');
grid('on');
ylim([-90;1]);
set(gca,'XTickLabel',{'-4/Ts','-3/Ts','-2/Ts','-1/Ts', '0', '1/Ts','2/Ts','3/Ts','4/Ts'});
xlim([-(4/sampleTime),(4/sampleTime)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Plot zeitlicher Verlauf Phase

f2 = figure(2);
set(f2, 'Name', 'zeitlicher Verlauf Phase');

% BPSK
subplot(3,1,1);
plot(simoutTime.signals.values, angle(simoutBpsk.signals.values).*(180/pi));
set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
title('Verlauf BPSK');
ylim([-200 200]);
xlabel('Zeit / T_s');
grid('on');
ylabel('Phase / �');

% MSK
subplot(3,1,2);
plot(simoutTime.signals.values, angle(simoutMsk.signals.values).*(180/pi));
set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
title('Verlauf MSK');
ylim([-200 200]);
xlabel('Zeit / T_s');
grid('on');
ylabel('Phase / �');

% GMSK
subplot(3,1,3);
plot(simoutTime.signals.values, angle(simoutGmsk.signals.values).*(180/pi));
set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
title('Verlauf GMSK');
ylim([-200 200]);
xlabel('Zeit / T_s');
grid('on');
ylabel('Phase / �');





