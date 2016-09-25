% Programm int_fft1.m zur Interpolation
% basierend auf der FFT

% ------- Spektrum eines Expandierten Signals
L = 5;
x = filter(fir1(64,0.2),1,randn(1,200));% Bandbegrenzte Sequenz
x = x(101:end);    % ein Ausschnitt
X = fft(x);   % DFT der Sequenz
%
y = zeros(1, length(x)*L);
y(1:L:end) = x;    % Expandierte Sequenz
Y = fft(y);   % DFT der expandierten Sequenz
%
figure(1);
subplot(221), stem(0:length(x)-1, x);
title('Sequenz x');    grid;
subplot(223), plot(0:length(X)-1, abs(X));
title('DFT von x');    grid;
subplot(222), stem(0:length(y)-1, y);
title('Expandierte Sequenz y');    grid;
axis tight;
subplot(224), plot(0:length(Y)-1, abs(Y));
title('DFT von y');    grid;
axis tight;

% ------- Spektrum ohne innere Wiederholungen
n = length(X);  % n gerade Zahl
Ye = [X(1:n/2), zeros(1,(L-1)*n), X(n/2+1:n)];
yi = L*real(ifft(Ye));  % Interpolierte Sequenz 

figure(2);
stem(0:length(y)-1, y);
title('Expandierte Sequenz x und Huelle der interpolierten Sequenz yi');    grid;
hold on
plot(0:length(yi)-1, yi, 'r');
hold off;

