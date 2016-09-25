% Programm fir_ueberg1.m zur Entwicklung und Analyse eines 
% FIR-Tiefpassfilters mit Übergangsbereich

clear;
fr = 0.15;     % Durchlassfrequenz relativ zu fs
nord = 42;     % Ordnung
Delta = 0.1;   % Übergang vom Durchlass- im Sperrbereich

b = fir1(nord, 2*fr);  % FIR-Filter mit Default-Fenster

bn = b.*sinc(Delta*(-nord/2:nord/2)); % mit Übergangsbereich
bn = bn/sum(bn); % Normierung für 0 dB bei f = 0

figure(1),   clf;
subplot(211), stem(0:length(b)-1, b);
title(['Koeffizienten des Filters entwickelt mit Hamming-Fenster',...
        ' (Ordnung = ',num2str(nord),')']);

subplot(212), stem(0:length(bn)-1, bn);
title(['Koeffizienten des Filters entwickelt mit Hamming-Fenster',...
        ' und Uebergang \Delta = ',num2str(Delta),...
        ' (Ordnung = ',num2str(nord),')']);

% -- Frequenzgänge 
nf = 1024;
H = zeros(nf,1);   % Default-Fenster
Hn = zeros(nf,1);  % Filter mit Uebergang

[H,w]  = freqz(b, 1, nf, 1);
[Hn,w] = freqz(bn, 1, nf, 1);

figure(2),   clf;
subplot(121),
plot(w, 20*log10([abs(H),abs(Hn)]));
La = axis;   axis([La(1:2), -100, 10]);
xlabel('f/fs');   grid;
legend('Default', 'Ueberg.',1);
ylabel('dB');
title(['Amplitudengaenge, Uebergang \Delta = ',num2str(Delta),...
        '; Ordnung = ',num2str(nord)]); 

subplot(222),
nd = fix(length(w)/2);

plot(w(1:nd),20*log10([abs(H(1:nd)),abs(Hn(1:nd))]));
La = axis;   axis([La(1:2), -0.1, 0.1]);
xlabel('f/fs');   grid;
legend('Default', 'Ueberg.',1);
ylabel('dB');
title(['Amplitudengaenge (Ausschnitt)']);

subplot(224),
nd = fix(length(w)/2);

plot(w(1:nd),20*log10([abs(H(1:nd)),abs(Hn(1:nd))]));
La = axis;   axis([La(1:2), -10, 1]);
xlabel('f/fs');   grid;
legend('Default', 'Ueberg.',3);
ylabel('dB');
title(['Amplitudengaenge (Ausschnitt)']);
