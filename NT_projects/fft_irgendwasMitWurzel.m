Tc=1/4000;  % Periodendauer Sin
fs=200000;      %Samplingrate in Hz

N = 80e6*Tc;      %Signallänge in [Anzahl perioden]

ds = 1/fs;       %Zeitintervall
T=0:ds:ds*(N-1);    %Zeitvektor des Signals

signal=sin(2*pi*4000*T);  %Beispielsignal
s2=signal.*sin(2*pi*4000*T);  %Beispielsignal

f=linspace(-fs/2,fs/2,N);   %Frequenzvektor

spektrum = fft(signal,N);   % <--------- Dieses N muss ganzzahlig vielfaches von Tc sein
spektrum2 = fft(s2,N);

Amp_spektrum = abs(spektrum);  %Amplitudenspektrum
Amp_spektrum = fftshift(Amp_spektrum/N);

Amp_spektrum2 = abs(spektrum2);  %Amplitudenspektrum
Amp_spektrum2 = fftshift(Amp_spektrum2/N);

figure(69);
subplot(221);
plot(f,Amp_spektrum);grid on;
subplot(222);
plot(f,10*log10(2*Amp_spektrum));grid on; % Normierter dB Pegel, eigentlich -3.1dB
subplot(223);
plot(f,Amp_spektrum2);grid on;
subplot(224);
plot(f,10*log10(2*Amp_spektrum2));grid on;



