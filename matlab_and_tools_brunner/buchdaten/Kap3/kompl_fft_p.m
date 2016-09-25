% Programm kompl_fft_p.m zur Untersuchung der FFT
% eines komplexen Signals, das zur Bildung des Basisbandsignal
% für die einseitige Amplitudenmodulation dient.
%
% Arbeitet mit dem Modell kompl_fft.mdl


% -------- Parameter für das Modell
Ts = 0.001;       % Abtastfrequenz fs = 1000 Hz
fs = 1/Ts;

% Hilbert-Filter
Nfilter = 64;
hh = remez(Nfilter, [0.02, 0.48]*2, [1 1], 'Hilbert');
Nfft = 256;
Hh = fft(hh, Nfft);

figure(1);       clf;
subplot(121), stem(0:Nfilter, hh);
title('Impulsantwort des Hilbert-Filters');
La = axis;    axis([0, Nfilter, La(3:4)]);

subplot(222), plot((0:Nfft-1)/Nfft, abs(Hh));
title('Amplitudengang des Hilbert-Filters');

% Phasengang des nichtkausalen Filters
phi = unwrap(angle(Hh))+((0:Nfft-1)/Nfft)*2*pi*Nfilter/2;

subplot(224), plot((0:Nfft-1)/Nfft, phi*180/pi);
title('Phasengang des nichtkausalen Filters');
xlabel('f/fs');

% -------- Verspätung für den oberen Zweig im Modell
delay = Nfilter/2;

disp('Nach der Durchführung dieses Programms, ');
disp('kann die Simulation gestartet werden !!!');






