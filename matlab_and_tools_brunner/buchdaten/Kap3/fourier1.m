% Programm (fourier1.m) zur Darstellung eines 
% Leistungsspektrums eines periodischen Signals in dB
% Als Signal wird ein symmetrisches rechteckiges Signal
% ohne Mittelwert vorausgesetzt

n = 1:2:50;                       % Ungeraden Harmonischen

betrag_An = 1./(2*n-1);           % Amplituden für ein Signal
betrag_An = betrag_An*4/pi;       % mit Werten +1 und -1

betrag_max = max(betrag_An);

betrag_dB = 20*log10(betrag_An/betrag_max);   % dB

figure(1);          clf;
subplot(211), stem(n, betrag_An);
title('Amplituden');     grid;
xlabel('k Index der Komponenten (Harmonischen)');
set(gca,'Xtick',[1:2:50]);

subplot(212), stem(n, betrag_dB);
title('20*log10(Amplituden / max(Amplituden))');     grid;
xlabel('k Index der Komponenten (Harmonischen)');
ylabel('dB')
set(gca,'Xtick',[1:2:50]);

