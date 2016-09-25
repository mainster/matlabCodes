% Programm harm_komp1.m, in dem Sequenzen von harmonischen Komponenten Ÿber
% die inverse Fourier-Transformation gebildet werden

N = 30;
X1 = zeros(1, N);    X2 = X1;

% ------- Erste Komponente
i = 3;
X1(i+1) = 1*exp(j*pi/3);         % FFT der ersten Sequenz          
X1(N-(i-1)) = conj(X1(i+1));

x1 = real(ifft(X1*N/2));         % erste Sequenz x1

nd = 0:0.1:N;
x1r = cos(2*pi*nd*i/N + pi/3);   % kontinuierliche HŸlle von x1 

% ------- Zweite Komponente
i = 7;
X2(i+1) = 1*exp(-j*pi/4);         % FFT der zweiten Sequenz  
X2(N-(i-1)) = conj(X2(i+1));

x2 = real(ifft(X2*N/2));         % zweite Sequenz x2

nd = 0:0.1:N;
x2r = cos(2*pi*nd*i/N - pi/4);   % kontinuierliche HŸlle von x2 

% ------------------------------------
figure(1);   clf;
subplot(421), stem(0:N-1, abs(X1));
ylabel('Betrag');   grid;
title('FFT der Sequenz x1');
pos = get(gca,'Position');
set(gca,'Position', [pos(1:3), pos(4)*0.9]);

subplot(423), stem(0:N-1, angle(X1));
ylabel('Phase');   grid;

subplot(425), stem(0:N-1, abs(X2));
ylabel('Betrag');   grid;
title('FFT der Sequenz x2');
pos = get(gca,'Position');
set(gca,'Position', [pos(1:3), pos(4)*0.9]);

subplot(427), stem(0:N-1, angle(X2));
ylabel('Phase');   grid;

subplot(222), stem(0:N-1, x1);
title('Sequenz x1');  grid;
hold on
plot(nd, x1r);
hold off

subplot(224), stem(0:N-1, x2);
title('Sequenz x2');  grid;
hold on
plot(nd, x2r);
hold off

% -------- Die Summe der FFT
Xt = X1 + X2;

xt = real(ifft(Xt*N/2));
xtr = x1r + x2r;

figure(2);   clf;
subplot(221), stem(0:N-1, abs(Xt));
ylabel('Betrag');   grid;
title('FFT der Sequenz x1 + x2');

subplot(223), stem(0:N-1, angle(Xt));
ylabel('Phase');   grid;

subplot(122), stem(0:N-1, xt);
hold on
plot(nd, xtr);
hold off
title('Sequenz x1 + x2');   grid;
