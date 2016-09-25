function y = faltung1(n,m)
% Funktion (faltung1.m) zur Berechnung der 
% Faltung über die FFT
% Argumente: n,m = Länge der Sequenz aus Einser- bzw. Nullwerte
%
% Testaufruf: y = faltung1(10,10);
%
u = [ones(1,n), zeros(1,m)];
h = u;

%------ FFT der Sequenzen als Annäherung der
%       Fourier-Transformation
U = fft(u);
H = fft(h);

%------ Produkt der FFTs und Faltung über ifft
Y = U.*H;
y = real(ifft(Y));

figure(1);		clf;
k = n+m;
l = 0:k-1;
subplot(211), stem(l,u);
title('Eingangssequenz und Impulsantwort (u; h)');
xlabel('n');

subplot(212), stem(l,y);
title('Ausgang als ifft(U*H)');
xlabel('n');
