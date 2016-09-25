% Programm ifir_high1.m zur Entwicklung eines 
% IFIR-Hochpassfilters mit der Funktion ifir

% -------- Gewünschte Parameter
fs = 0.06;  % Sperrfrequenz
fp = 0.075;  % Durchlassfrequenz

% -------- IFIR-Filter mit der Funktion ifir
L = 5;
[hup, hsupp, d]=ifir(L, 'high',[fs, fp]*2,[0.0001, 0.001]);
disp(['Verspaetung fuer den parallelen Pfad = ',...
    num2str(length(d)-1)]);

% Frequenzgänge
nfft=1024;
Hup = fft(hup,nfft);    Hsupp = fft(hsupp,nfft);

figure(1);    clf;
subplot(221), plot((0:nfft-1)/nfft, 20*log10(abs(Hup)));
title('Expandiertes FIR-Tiefpassfilter');
xlabel('f/fs');     grid;
La = axis;   axis([La(1:2), -100, 10]);

subplot(223), plot((0:nfft-1)/nfft, 20*log10(abs(Hsupp)));
title('Image-Suppressing FIR-Filter');
xlabel('f/fs');     grid;
La = axis;   axis([La(1:2), -100, 10]);

subplot(222), plot((0:nfft-1)/nfft, 20*log10(abs(Hup.*Hsupp)));
title('IFIR-Tiefpassfilter');
xlabel('f/fs');     grid;
La = axis;   axis([La(1:2), -100, 10]);

subplot(224), plot((0:nfft-1)/nfft, 20*log10(abs((1-abs(Hup.*Hsupp)))));
title('IFIR-Komplementaer-Filter (HP-IFIR)');
xlabel('f/fs');     grid;
La = axis;   axis([La(1:2), -100, 10]);

figure(2);
subplot(211), stem(0:length(hup)-1, hup);
k = find(hup==0);
n_koeff = length(hup)-length(k);
title(['Einheitspulsantwort des expandierten Filters (Anzahl-Koeff. verschieden von null = ',...
    num2str(n_koeff),')']);
xlabel('n');    grid;
La = axis;   axis([La(1), length(hup)-1, La(3:4)]);

n_koeff_supp = length(hsupp);
subplot(212), stem(0:length(hsupp)-1, hsupp);
title(['Einheitspulsantwort des Image-Suppressing-Filters (Anzahl-Koeff. = ',...
    num2str(n_koeff_supp),')']);
xlabel('n');    grid;
La = axis;   axis([La(1), length(hsupp)-1, La(3:4)]);








