% Skript modell1.m, aus dem das Simulink-Modell
% modell_1.mdl aufgerufen wird
clear;
% -------- Aufruf der Simulation 
sim('modell_2', [0, 10]);
% y = Zeitdiskretes Signal Fs = 1000 Hz

% ------- Berechnung der spektralen Leistungsdichte
% von y
Hs = spectrum.welch('Hamming');   % Objekt spectrum (Spezifikation)
Psd = psd(Hs,y,'Fs',1000,'NFFT',256,'SpectrumType','twosided');
        % Berechnung der spektralen Leistungsdichte W/Hz
get(Psd)    % Eigenschaften des Psd-Objekts

figure(1);    clf;
plot((-128:127)*1000/256, 10*log10(fftshift(Psd.Data)));
title('Spektrale Leistungsdichte in dBW/Hz');
xlabel('Hz (fs = 1000 Hz)');    grid on;
ylabel('dBW/Hz');

% ------- Leistung des Signal über die spektrale Leistungsdichte
L_sig = sum(Psd.Data)*1000/256
