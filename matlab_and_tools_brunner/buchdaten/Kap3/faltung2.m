function y = faltung2(u,h)
% Funktion (faltung2.m) zur Berechnung der 
% Faltung über die FFT
% Argumente: u = Eingangssequenz; h = Impulsantwort
%
% Testaufruf:u = ones(1,20);
%            h = 0.6.^(0:10);
%            y = faltung2(u, h);

%------ FFT der Sequenzen als Annäherung der
%       Fourier-Transformation
k = length(u) + length(h);
U = fft(u,k);
H = fft(h,k);

%------ Produkt der FFTs und Faltung über ifft
Y = U.*H;
y = real(ifft(Y));

lu = length(u);		nu = 0:lu-1;
lh = length(h);     nh = 0:lh-1;
ly = length(y);		ny = 0:ly-1;

figure(1);		clf;
subplot(311), stem(nu,u);
title('Eingangssequenz u');
La = axis;		axis([La(1), ly, La(3), La(4)]);

subplot(312), stem(nh,h);
title('Impulsantwort h');
La = axis;		axis([La(1), ly, La(3), La(4)]);

subplot(313), stem(ny,y);
title('Ausgang als ifft(U*H)');
xlabel('n');
