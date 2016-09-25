% Programm expan_fir1.m in dem die Expansion mit
% Nullwerten der Einheitspulsantwort eines FIR-Filters 
% untersucht wird

clear

% -------- FIR-TP
nord = 20;   % Ordnung des Filters
fr = 0.4;    % Zum Nyquist-Bereich relative Frequenz

htp = fir1(nord, fr);

% -------- Expandiertes FIR-Filter
m = 3;       % Expansionsfaktor

hexp = zeros(1, length(htp)*m);
hexp(1:m:end) = htp;

% -------- Frequenzgaenge
nfft = 1024;
Htp = fft(htp, nfft);
Hexp = fft(hexp, nfft);

figure(1);   clf;
subplot(221), stem(0:length(htp)-1, htp);
title('Einheitspulsantwort FIR-TP');
xlabel('k');   grid;

subplot(223), plot((0:nfft-1)/nfft, 20*log10(abs(Htp)));
title('Amplitudengang FIR-TP');
xlabel('f/fs');   grid;
La = axis;   axis([La(1:2), -80, 10]);

subplot(222), stem(0:length(hexp)-1,hexp );
title('Einheitspulsantwort expan. FIR');
xlabel('k');   grid;
La = axis;   axis([La(1), length(hexp), La(3:4)]);

subplot(224), plot((0:nfft-1)/nfft, 20*log10(abs(Hexp)));
title('Amplitudengang exp. FIR');
xlabel('f/fs');   grid;
La = axis;   axis([La(1:2), -80, 10]);

