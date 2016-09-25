% Programm (spektr_2.m) zur Erzeugung eine Rauschsignals mit
% gegebener Leistungsspektraldichte über die iFFT

%-------- Gewünschte Leistungsspektraldichte
N = 4096;
df = 1/N;
f = 0:df:1-df;

f01 = 0.1;      f02 = 0.3;

%------- Spektrum mit nötigter Symmetrie für reelle Signale
Sy = 1./(1+1000*(f-f01).^2)+ 1./(1+1000*(f-(1-f01)).^2)+...
     1./(1+5000*(f-f02).^2)+ 1./(1+5000*(f-(1-f02)).^2);

%------- Darstellung von Sy(f)
figure(1);       clf;
subplot(311),   plot(f, Sy/max(Sy));
title('Gewuenschte Leistungsspektraldichte Sy');
xlabel('f/fs'); grid;
p = get(gca, 'Position');
set(gca, 'Position', [p(1),p(2),p(3), 0.85*p(4)]);

%------- Erwartungswert der FFT
Betrag = sqrt(Sy*N);            % Amplituden der Komponenten
randn('seed', 37915);
Phase = (rand(1, N/2)-0.5)*2*pi;      % Zufällige Phasen
Phase = [Phase, 0, -Phase(N/2:-1:2)]; % Symmetrie für ein relles Signal

%------- Signal
y = real(ifft(Betrag.*exp(j*Phase)));

%------ Gemessene Spektraldichte
Nfft = 256;
[Syg, fw] = psd(y, Nfft, 1, hanning(Nfft/2), Nfft/4);

Syg = [Syg', Syg(Nfft/2:-1:2)'];  % Spektrum für f = 0 bis fs

subplot(312), plot((0:Nfft-1)/Nfft, Syg/max(Syg));
title('Gemessene Leistungsspektraldichte Syg');
xlabel('f/fs'); grid;
p = get(gca, 'Position');
set(gca, 'Position', [p(1),p(2),p(3), 0.85*p(4)]);

subplot(313), plot(0:N-1, y);
title('Erzeugtes Signal');   grid;
xlabel('k');
La = axis;    axis([La(1), N-1, La(3), La(4)]);
p = get(gca, 'Position');
set(gca, 'Position', [p(1),p(2),p(3), 0.85*p(4)]);



