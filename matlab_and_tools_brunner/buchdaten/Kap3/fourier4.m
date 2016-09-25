% Programm (fourier4.m) zur Bestimmung der 
% komplexen Fourier-Reihe mit Hilfe der FFT

f1 = 100;           % Frequenz des 1. Signals           
f2 = 4300;          % Frequenz des 2. Signals
fs = 1000;          % Abtastfrequenz und Abtastperiode
Ts = 1/fs;

t = 0:0.1e-4:49e-3; % Zeitbereich für die kontinuierlichen 
                    % Signale
td = 0:Ts:49e-3;    % Zeitbereich für die diskreten Signale

x1 = 5*cos(2*pi*t*f1-pi/2);     % Kontinuierliche Signale
x2 = 10*cos(2*pi*t*f2+pi/3);

xd1 = 5*cos(2*pi*td*f1-pi/2);   % Diskrete Signale
xd2 = 10*cos(2*pi*td*f2+pi/3);

%------ Darstellung der Signale
figure(1);        clf;
subplot(211), plot(t,x1);   hold on;
stem(td,xd1);   grid;
title('Signal mit f1 = 100 Hz (fs = 1000 Hz)');
xlabel('Zeit in s');        hold off;

tm = max(t)/10;
p = find(t<=tm);
q = find(td<=tm);

subplot(212), plot(t(p),x2(p));   hold on;
stem(td(q),xd2(q));    grid;
title('Signal mit f2 = 4300 Hz (fs = 1000 Hz)');
xlabel('Zeit in s');        hold off;

%------ Darstellung der FFT (abs(FFT)/N und Winkel(FFT))
xd = xd1 + xd2;
Xi = fft(xd);
N = length(Xi);

figure(2);
subplot(211), stem((0:N-1)*fs/N, abs(Xi)/N);
title('Amplitudenspektrum (abs(FFT)/N)');
xlabel('Frequenz in Hz');

phase = angle(Xi);           % In dieser Schleife werden die 
for m = 1:N                  % falschen Phasenwerte entfernt
   if abs(real(Xi(m)))& abs(imag(Xi(m))) < 1e-9;
      phase(m) = 0;
   end;
end;   
subplot(212), stem((0:N-1)*fs/N, phase);
title('Phasenspektrum (Winkel(FFT))');
xlabel('Frequenz in Hz');
