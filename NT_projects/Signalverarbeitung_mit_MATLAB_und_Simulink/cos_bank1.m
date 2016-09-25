% Programm cos_bank1.m in dem eine cosinmodulierte Filterbank
% entwickelt wird.
% Es dient auch zur Initialisierung des Modells cos_bank_1.mdl
% in dem die Filterbank simuliert wird

clear

% -------- Allgemeine Parameter
N = 32;   % Anzahl Bandpässe im Nyquistbereich
fs = 1000;
Ts = 1/fs;

% -------- Teifpassprototyp-Filter
L = 512;     % Anzahl Koeffizienten des Filters
h = fir1(L-1, 1/(2*N), kaiser(L, 6));   % Einheitspulsantwort
 
figure(1);    clf,
subplot(211), plot(0:L-1, h);
title(['Einheitspulsantwort des Prototypfilters (L = ',num2str(L),' )']);
xlabel('Index k');     grid;
La = axis;   axis([La(1), L-1, La(3:4)]);

nfft = 4096;
H = fft(h, nfft);
nd = 0:nfft/4;
subplot(212), plot(nd/nfft, 20*log10(abs(H(nd+1))));
title(['Amplitudengang des Prototypfilters']);
xlabel('f/fs');     grid;
ylabel('dB');

% -------- Einheitspulsantworten der Bandpässe:
hi = zeros(N,L);  % Initialisierung
hir = hi;
for i = 0:N-1
    %hi(i+1,:) =2*h.*cos(pi*(2*i+1)*((0:nf-1)-(L-1)/2)/(2*N)); % Einfache Modulation
    
    %hi(i+1,:) =2*h.*cos(pi*(2*i+1)*((0:L-1)-(L-1+N)/2)/(2*N)); 
    % Dolbinger Cosine-Modulationsfilter (ohne Optimierung des Prototyps)  
    
    hi(i+1,:) =2*h.*cos(pi*(2*i+1)*((0:L-1)-(L-1)/2)/(2*N)+((-1)^i)*pi/4); 
    % Vaidyanathan Cosine-Modulationsfilter (ohne Optimierung des Prototyps) 
end;
hir=fliplr(hi);     % Synthese Filter
hit = hir';         % F¸ür das Modell cos_bank_1.mdl
% -------- Frequenzgang der Analyse-Filterbank
Hi = fft(hi', nfft); 
Hir = fft(hir', nfft);

figure(2);    clf,
subplot(211), plot((0:nfft-1)/nfft, 20*log10(abs(Hi)));
title(['Amplitudengang des Analyseteils der Filterbank']);
xlabel('f/fs');     grid;
La = axis;   axis([La(1:2), -100, 10]);
ylabel('dB');

nd = nfft/8;
subplot(212), plot((0:nd-1)/nfft, 20*log10(abs(Hi(1:nd,:))));
title(['Amplitudengang des Analyseteils der Filterbank (Ausschnitt)']);
xlabel('f/fs');     grid;
La = axis;   axis([La(1), nd/nfft, -100, 10]);
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
sim('cos_bank_1',[0, 1]);




    







