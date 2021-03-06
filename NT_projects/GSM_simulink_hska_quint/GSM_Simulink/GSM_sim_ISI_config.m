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
SNR = 1000;                                   % Signal zu Rausch-Abstand in dB
lengthOfSymbol = 64;                        % Parameter der �berabtastung/Symbol
phaseOffset = pi/4;                         % Phasenoffset d. Sendesymbole 
simulationTime =25;                        % Simulationszeit
sampleTime = 1;                             % Symbolzeit
simin.time = [0:sampleTime:simulationTime]; % Zeitvektor
siminSymbols.time = [0:sampleTime:simulationTime]; % Zeitvektor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ Eingansdaten erzeugen (einen der Datens�tze ausw�hlen)
simin.signals.values = ceil(2*rand(length(simin.time),1))-1; % zuf�llige Folge Matlab 
siminSymbols.signals.values = (randi(4,1,length(siminSymbols.time))-1).'; % zuf�llige Folge Matlab 
%siminSymbols.signals.values = [0 1 2 3 3 3 1 0 2 0 3 3 1 0 2]'; 
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
f1=figure(1);
SUB=210;
%sub1=subplot(SUB+1);
%sub2=subplot(SUB+2);

legstr=[];
for i=0:3
    rcRoll=0.2*i;
    
    legstr=[legstr sprintf('r=%.1f:',rcRoll)];
    
    rcUpsample=25;
    sim('GSM_sim_ISI');
    
%     subplot(sub1);
%     hold all;
%     plot([0:length(simoutPulse.signals.values)-1],simoutPulse.signals.values)
%     hold off; 
%     grid on;
%     grid minor;
% 
%     subplot(sub2);
    hold all;
    plot([0:length(simoutShaped.signals.values)-1]/rcUpsample, simoutShaped.signals.values)
    hold off; 
    grid on;
    grid minor;
end

legend(strsplit(legstr,':'));

ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');

return; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ FFT-Analyse der modulierten Bitfolgen

% FFT-Parameter festlegen
L = length(simoutGmsk.signals.values)
Ts = simoutTime.signals.values(2)-simoutTime.signals.values(1);
Fs = 1/Ts;
window = blackman(L);
NFFT = 2^nextpow2(L);
f = Fs/2*linspace(-1,1,NFFT);

% GMSK-Signal
Y_Gmsk = fft(simoutGmsk.signals.values.*window,NFFT)/L;
Y_Gmsk = Y_Gmsk/max(abs(Y_Gmsk)); % Normierung
Y_Gmsk_dB = 10*log10(abs([Y_Gmsk(end/2:end);
Y_Gmsk(1:end/2-1)]).^2);

% MSK-Signal
Y_Msk = fft(simoutMsk.signals.values.*window,NFFT)/L;
Y_Msk = Y_Msk/max(abs(Y_Msk)); % Normierung
Y_Msk_dB = 10*log10(abs([Y_Msk(end/2:end);Y_Msk(1:end/2-1)]).^2);

% BPSK-Signal
Y_Bpsk = fft(simoutBpsk.signals.values.*window,NFFT)/L;
Y_Bpsk = Y_Bpsk/max(abs(Y_Bpsk)); % Normierung
Y_Bpsk_dB = 10*log10(abs([Y_Bpsk(end/2:end);Y_Bpsk(1:end/2-1)]).^2);

% % BPSKinter-Signal
% k=1;
% for n=1:length(simoutGmsk.signals.values)*2
%     window2(k) = k;
%     L2 = k;
%     valInter(k) = simoutBpsk.signals.values(n);
%     k;
%     window2(k) = k;
%     L2 = k;
%     valInter(k) = 0;
%     k++;
% end

% Y_Bpsk_Int = fft(valInter.*window2,NFFT)/L2;
% Y_Bpsk = Y_Bpsk/max(abs(Y_Bpsk)); % Normierung
% Y_Bpsk_dB = 10*log10(abs([Y_Bpsk(end/2:end);Y_Bpsk(1:end/2-1)]).^2);

% RC- Shaper-Signal
Y_RCshape = fft(simoutRCShaper.signals.values([1:L],1).*window,NFFT)/L;
Y_RCshape = Y_RCshape/max(abs(Y_RCshape)); % Normierung
Y_RCshape_dB = 10*log10(abs([Y_RCshape(end/2:end);Y_RCshape(1:end/2-1)]).^2);

% fg=figure(33)
% plot(f,Y_Bpsk_Int)

% zweiseitiges Spektrum plotten
f1 = figure(1);
set(f1, 'Name', 'Leistungsdichtespektrum ');
plot(f,Y_RCshape_dB, 'b') ;
hold on;
plot(f,Y_Bpsk_dB, 'g') ;
%plot(f,Y_RCshape2_dB, 'r') ;
%plot(f,Y_Msk_dB, 'r') ;
%plot(f,Y_Gmsk_dB, 'b'); 
hold off;
legend('RCShaper', 'BPSK');
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
SUB=410;

set(f2, 'Name', 'zeitlicher Verlauf Phase');

% BPSK
subplot(SUB+1);
plot(simoutTime.signals.values, angle(simoutBpsk.signals.values).*(180/pi));
set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
title('Verlauf BPSK');
ylim([-200 200]);
xlabel('Zeit / T_s');
line([Fs Fs], [-190 190],'color','red','linestyle','--','LineWidth',1)
grid('on');
ylabel('Phase / deg');

col=[hex2dec('E6') hex2dec('E5') hex2dec('DF')]/256;
TsVec=[63:64:length(simoutMsk.signals.values)-1];
line([TsVec' TsVec']*1/64, [-190 190],'color',col,'linestyle','--','LineWidth',1)

% MSK
subplot(SUB+2);
plot(simoutTime.signals.values, angle(simoutMsk.signals.values).*(180/pi));
set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
title('Verlauf MSK');
ylim([-200 200]);
xlabel('Zeit / T_s');
grid('on');
ylabel('Phase / deg');

% GMSK
subplot(SUB+3);
hold all;
plot(simoutTime.signals.values, real(simoutMsk.signals.values));
plot(simoutTime.signals.values, real(simoutGmsk.signals.values));
%set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
hold off;
title('Verlauf (G)MSK');
%ylim([-200 200]);
legend('MSK','GMSK');
xlabel('Zeit / T_s');
grid('on');
ylabel('real');

subplot(SUB+4);
hold all;
plot(simoutTime.signals.values, real(simoutMsk.signals.values));
plot(simoutTime.signals.values, real(simoutGmsk.signals.values));
%set(gca, 'YTick',  [-180 -90 0 90 180],'YTickLabel', [-180 -90 0 90 180]);
hold off;
title('Verlauf (G)MSK');
%ylim([-200 200]);
xlabel('Zeit / T_s');
grid('on');
ylabel('imag');


 ar=sort(findall(0,'type','figure'));
 set(ar,'WindowStyle','docked');


