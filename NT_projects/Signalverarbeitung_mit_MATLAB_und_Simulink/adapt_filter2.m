% Programm adapt_filter1.m als Beispiel füŸr den Einsatzt des Objekts
% adaptfilt, mit dem adaptive FIR-Filter entwickelt werden köšnnen.
% Es wird ein System identifiziert

% -------- Das zu identifizierende System
nx = 720;
x  = randn(1,nx);     % Input to the filter
nr = 32;
b  = fir1(nr-1,0.5);     % FIR system to be identified
n  = 0.1*randn(1,nx); % Observation noise signal
d  = filter(b,1,x)+n;  % Desired signal

% -------- Identifikation des Systems
mu = 0.01;            % LMS step size
ni = 36;
h = adaptfilt.blms(ni,mu,1,36);

% -------- Ausgang des identifizierten Systems und der Fehler
[y,e] = filter(h,x,d);

figure(1);   clf;
subplot(2,2,1); plot(0:nx-1,[d;y]);
title('Ausgang System und FIR-Filter');
legend('System','FIR-Filter');
xlabel('time index'); 
grid on;

subplot(2,2,2); plot(0:nx-1,[e]);
title('Fehler');
xlabel('time index'); 
grid on;

subplot(2,1,2); stem(0:ni-1, [b, zeros(1, ni-nr)]);
hold on
stem(0:ni-1, h.coefficients,'r');
hold off
xlabel('Index'); 
grid on;     La = axis;   

% -------- Frequenzgang des Systems und Filters
figure(2);   clf;
nfft = 1024;
Hs = fft(b, nfft);
Hi = fft(h.coefficients,nfft);

subplot(211);
plot((0:nfft-1)/nfft, 20*log10(abs([Hs.', Hi.'])));
xlabel('Amplitudengaende der Filter '); 
xlabel('f/fs');    grid on;
legend('System','FIR-Filter');


