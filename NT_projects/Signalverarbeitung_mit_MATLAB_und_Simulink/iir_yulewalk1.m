% Programm iir_yulewalk1.m zur Entwicklung und Untersuchung 
% eines Multiband-IIR-Filters 

clear
% -------- Spezifikation
f = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 1];     % Frequenz Eckpunkte
                                       % relativ zur Nyquistfrequenz
m = [0  0   1   1   0   0   1   1   0  0];     % Amplitudengangswerte
nord = 10; % Ordnung des Filters

fs = 2000;   % Abtastfrequenz

% -------- Entwicklung des Filters
[b,a] = yulewalk(nord, f, m);

% -------- Frequenzgang
nf = 1000;
[H,w] = freqz(b,a,1000,'whole');
Gr = grpdelay(b,a,nf,'whole'); 

figure(1),   clf;
subplot(211);
plot([f, 2-f(end-1:-1:1)], [m, m(end-1:-1:1)],...
    w/pi, abs(H));
title(['Amplitudengang des IIR-Filters (Ordnung = ',...
        num2str(nord),')']);
xlabel('2f/fs');    grid;
La = axis;    axis([La(1:2), 0, 1.2]);

subplot(212);
plot((0:nf-1)*2/nf, unwrap(angle(H))*180/pi);
xlabel('2f/fs');    grid;
title('Phasengang');
ylabel('Grad');
%La = axis;    axis([La(1:2), -1e-3, 5e-3]);

figure(2),   clf;
subplot(211);
plot((0:nf-1)*fs/nf, 20*log10(abs(H)));
title(['Amplitudengang des IIR-Filters (Ordnung = ',...
        num2str(nord),'; fs = ',num2str(fs),' Hz)']);
xlabel('Hz');    grid;
La = axis;    axis([La(1:2), -50, 10]);

subplot(212);
plot((0:nf-1)*fs/nf, Gr/fs);
xlabel('Hz');    grid;
title('Gruppenlaufzeit');
ylabel('Sekunden');
La = axis;    axis([La(1:2), -0.5e-3, 3.5e-3]);

