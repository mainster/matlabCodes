% Programm fir_fenster1.m in dem der Einfluß der 
% Fenster-Funktion auf dem Frequenzgang eines FIR-Filter
% untersucht wird

% ------- FIR-Filter mit sinx/x Einheitspulsantwort
% (Rechteckiges Fenster)
fp = 100;     fs = 1000;    fr = fp/fs;
k = -22:22;

b1 = (2*fr)*sin(2*pi*fr*k+eps)./(2*pi*fr*k+eps);
%b1 = (2*fr)*sinc(2*fr*k);

% ------- Hanning-Fenster
w_fenster = hanning(length(k))';
b2 = b1.*w_fenster;

% ------- Frequenzgänge
[H1,w] = freqz(b1, 1, 512, 'whole', 1);
[H2,w] = freqz(b2, 1, 512, 'whole', 1);

figure(1);    clf;
subplot(311), stem(0:length(k)-1, b1);
title('Sinx/x-Einheitspulsantwort');

subplot(312), stem(0:length(k)-1, w_fenster);
title('Hanning-Fensterfunktion');

subplot(313), stem(0:length(k)-1, b2); 
title('Einheitspulsantwort mit Hanning-Fensterfunktion');

figure(2);
subplot(121),
nd = fix(length(w)/4);
plot(w(1:nd), [abs(H1(1:nd)), abs(H2(1:nd))]);
title(['Amplitudengang mit Rechteck- und Hanning-Fenster (linear']); 
xlabel('f/fs');    grid;

subplot(122),
plot(w(1:nd), 20*log10([abs(H1(1:nd)), abs(H2(1:nd))]));
title(['und logaritmisch fuer fs = ',num2str(fs),' Hz; fp = ',num2str(fp),' Hz)']);

La = axis;   axis([La(1:2), -80, 10]);
xlabel('f/fs');    grid;
ylabel('dB');


