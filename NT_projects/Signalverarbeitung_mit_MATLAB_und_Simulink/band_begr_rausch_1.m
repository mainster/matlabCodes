% Skript band_begr_rausch_1.m, in dem die Eigenschaften
% des Blocks ''Band-Limited White Noise'' untersucht werden
clear;
% -------- Aufruf der Simulation 
sim('band_begr_rausch1', [0, 5]);
% y = Zeitdiskretes Signal Fs = 10000 Hz (wegen der Abtastperiode
      % im Block ''Band-Limited White Noise'' parametriert)

% ------- Berechnung der spektralen Leistungsdichte
% von y
Hs = spectrum.welch('Hamming');   % Objekt spectrum (Spezifikation)
Psd = psd(Hs,y,'Fs',10000,'NFFT',256,'SpectrumType','twosided');
        % Berechnung der spektralen Leistungsdichte W/Hz
get(Psd)    % Eigenschaften des Psd-Objekts

figure(1);    clf;
plot((-128:127)*10000/256, 10*log10(fftshift(Psd.Data)));
title('Spektrale Leistungsdichte in dBW/Hz');
xlabel('Hz (fs = 10000 Hz)');    grid on;
ylabel('dBW/Hz');
La = axis;    axis([La(1:2), -43, -38]);

% ------- Leistung des Signal über die spektrale Leistungsdichte
L_sig = sum(Psd.Data)*10000/256