% Programm lauf_summ1.m zur Darstellung 
% des Frequenzgang eines Laufenden-Summierfilters 
% (1-z^(-M))/(1-z^(-1))

M = 10;
zaehler = [1, zeros(1,M-1),-1];   
nenner = [1 -1];
nfft =256;
[H,w]= freqz(zaehler, nenner, nfft, 'whole');

figure(1);    clf;
subplot(211), plot(w/(2*pi), 20*log10(abs(H)));
title(['Amplitudengang, M = ',num2str(M)]);
xlabel('f/fs');   grid;
subplot(212), plot(w/(2*pi), angle(H));
title(['Phasengang']);
xlabel('f/fs');   grid;