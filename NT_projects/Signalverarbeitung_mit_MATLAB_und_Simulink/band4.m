% Programm band4.m zur Parametrierung des Modells
% band_4.mdl, in dem die Verschiebung des Spektrums
% eines Signals und die Verschiebung des Frequenzgangs
% eines FIR-Filters untersucht werden.

% -------- Parameter
fs = 10000;      Ts = 1/fs;
fc = 2000;    % Mittefrequenz BP

% -------- TP-Prototypfilter das in einem BP-Filter
% umgewandelt wird
nf = 256;        ftp = 0.05;
h0 = fir1(nf, 2*ftp);

% Bandpassfilter aus TP-Prototyp
hbp = h0.*exp(j*2*pi*fc*(-nf/2:nf/2)/fs);

% -------- Eigenschaften des TP-Prototyps 
figure(1),   clf;
subplot(211), stem(0:nf, h0);
title('Einheitspulsantwort des TP-Prototyps');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

nfft = 1024;
H0 = fft(h0, nfft);
subplot(212), plot((0:nfft-1)/nfft, 20*log10(abs(H0)));
title('Amplitudengang des TP-Prototyps');
xlabel('f/fs');   grid;

% -------- Eigenschaften des Real- bzw. Imagin‰ärteils
% des komplexen Bandpassfilters
figure(2),    clf;
subplot(221), stem(0:nf, real(hbp));
title('Einheitspulsantwort Real(hbp)');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

subplot(222), stem(0:nf, imag(hbp));
title('Einheitspulsantwort Imag(hbp)');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

Hbpr = fft(real(hbp), nfft);
subplot(223), plot((0:nfft-1)/nfft, 20*log10(abs(Hbpr)));
title('Amplitudengang Real(hbp)');
xlabel('f/fs');   grid;

Hbpi = fft(imag(hbp), nfft);
subplot(224), plot((0:nfft-1)/nfft, 20*log10(abs(Hbpi)));
title('Amplitudengang Imag(hbp)');
xlabel('f/fs');   grid;

% -------- Eigenschaften des komplexen Bandpassfilters
figure(3),    clf;
subplot(221), stem(0:nf, real(hbp));
title('Einheitspulsantwort Real(hbp)');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

subplot(222), stem(0:nf, imag(hbp));
title('Einheitspulsantwort Imag(hbp)');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

Hbp = fft(hbp, nfft);
subplot(212), plot((0:nfft-1)/nfft, 20*log10(abs(Hbp)));
title('Amplitudengang hbp(n) = h0(n).*exp(2*pi*fc*n/fs)');
xlabel('f/fs');   grid;

% -------- Aufruf der Simulation
sim('band_4',[0,1]);

