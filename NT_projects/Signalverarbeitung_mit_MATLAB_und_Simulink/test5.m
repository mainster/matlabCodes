% Programm test5.m 
% parametriert test_5.mdl

% Spektrum von x verschieben
% TP-Prototypfilter
nf = 256;        ftp = 0.05;
h0 = fir1(nf, 2*ftp);

fs = 10000;      Ts = 1/fs;

fc = 2000;    % Mittefrequenz BP

% Bandpassfilter aus TP-Prototyp
hbp = h0.*exp(j*2*pi*fc*(-nf/2:nf/2)/fs);

figure(1),   clf;
subplot(211), stem(0:nf, h0);
title('Einheitspulsantwort des Prototyp-TP');
La = axis;   axis([La(1), nf+1, La(3:4)]);
xlabel('n');   grid;

nfft = 1024;
H0 = fft(h0, nfft);
subplot(212), plot((0:nfft-1)/nfft, 20*log10(abs(H0)));
title('Amplitudengang des Prototyp-TP');
xlabel('f/fs');   grid;

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

% Polyphasenfilter
M = 10;
% --------- Parameter des Polyphasenfilters
h = h0;
rn = rem(nf+1,M);   
if rn == 0
    g = zeros(M, nf/M);  % nf ein Vielfaches von M
else
    g = zeros(M, fix(nf/M)+1); % Filterlänge zu einem
    h = [h, zeros(1,M-rn)]; % Vielfach von M erweitert
end;
 
for k = 1:M
    g(k,:) = h(k:M:end); % Teilfilter des Polyphasen-
end;                     % filters
gt = g';

% -------- Dezimierung
k = 2;
gd = g;
for p = 0:M-1
    gd(p+1,:) = g(p+1,:)*exp(j*2*pi*p*k/M);
end
ng = length(gd);
gt = gd';
