% Programm cos_bank2.m in dem eine cosinusmodulierte Filterbank
% entwickelt wird.
% Es dient auch zur Initialisierung des Modells cos_bank_2.mdl
% in dem die Filterbank simuliert wird

% -------- Allgemeine Parameter
N = 32;   % Anzahl Bandpässe im Nyquistbereich
fs = 1000;
Ts = 1/fs;

% -------- Teifpassprototyp-Filter
L = 512;     % Anzahl Koeffizienten des Filters
[h, hi, hir] = unicmfb(N,L,1/(2*N),1e5,L,0,0); % Doblinger Verfahren
h = h/sqrt(N);
hi = hi'/sqrt(N);     hir = hir'/sqrt(N);
hit = hir;

figure(1);    clf,
subplot(211), plot(0:L-1, h);
title(['Einheitspulsantwort des Prototypfilters (L = ',num2str(L),' )']);
xlabel('Index k');     grid;
La = axis;   axis([La(1), L-1, La(3:4)]);

nfft = 2024;

H = fft(h, nfft);
nd = 0:nfft/4;
subplot(212), plot(nd/nfft, 20*log10(abs(H(nd+1))));
title(['Amplitudengang des Prototypfilters']);
xlabel('f/fs');     grid;
ylabel('dB');

hit = hir';
% -------- Frequenzgang der Analyse-Filterbank
Hi = fft(hi', nfft); 
Hir = fft(hir', nfft);

figure(2);    clf,
subplot(211), plot((0:nfft-1)/nfft, 20*log10(abs(Hi)));
title(['Amplitudengang des Analyseteils der Filterbank']);
xlabel('f/fs');     grid;
La = axis;   axis([La(1:2), -120, 10]);
ylabel('dB');

nd = nfft/8;
subplot(212), plot((0:nd-1)/nfft, 20*log10(abs(Hi(1:nd,:))));
title(['Amplitudengang des Analyseteils der Filterbank (Ausschnitts)']);
xlabel('f/fs');     grid;
La = axis;   axis([La(1), nd/nfft, -120, 10]);
ylabel('dB');


figure(3);   clf;
subplot(211), plot((0:nfft-1)/nfft, 20*log10(sum(abs(Hi.*Hir),2)));
title(['Amplitudengang des Filterbanksystems (der "Distortion Function")']);
xlabel('f/fs');     grid; 
ylabel('dB');

t = zeros(N, 2*L-1);
for p = 1:N
    t(p,:) = conv(hi(p,:), hir(p,:));
end;
tt = sum(t);

subplot(212), stem(0:length(tt)-1, tt);
title('Einheitspulsantwort des  Filterbanksystems (der "Distortion Function")');
xlabel('n');   grid;
La = axis;     axis([La(1),length(tt)-1, La(3:4)]);

% -------- Aufruf der Simulation
sim('cos_bank_2', [0, 1]);





    







