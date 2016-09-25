% Programm noise_alias_.m zur Untersuchung der 
% Abtastung von bandbegrenztem Rauschen mit und ohne
% Antialiasing-Filter
% Arbeitet mit dem Modell noise_alias.mdl 
clear;
% -------- Parameter 
fs = 1000;    % Abtastfrequenz
N = 4;
frausch = N*fs;  % Bandbreite des Rauschsignals
% frausch = fs/2

nfft = 256;  % Anzahl Bin der FFT und
% Größe des Puffers

fpsd = 6*fs;

% -------- Aufruf der Simulation 
sim('noise_alias',[0:1/fpsd:2]);

nd = 0:nfft/2-1;
figure(1);
plot(nd*fpsd/nfft, 10*log10(yout(nd+1,:)/max(max(yout))));
title(['Leistungsspektraldichte ohne und mit Antialiasing-Filter (fs = ',...
        num2str(fs),' Hz; frausch = ',num2str(frausch),' Hz)']);
xlabel('Hz'),    grid;
ylabel('dB'),
hold on
La = axis;
plot([fs/2, fs/2], [La(3), La(4)]);
hold off


