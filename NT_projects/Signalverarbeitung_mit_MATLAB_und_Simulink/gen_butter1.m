% Programm gen_butter1.m in dem IIR-Filter vom Typ
% Generalized-Butterworth entwickelt und untersucht
% werden

fr = 0.3;    % Durchlassfrequenz relativ zur Nyquistfreq.
nord_b = 6;  % Ordnung für den Zähler
nord_a = 3;  % Ordnung für den Nenner

% -------- Entwerfen von drei Filtern
[b1, a1] = maxflat(nord_b, nord_a, fr); % verschiedene Ordnungen

[b2, a2] = maxflat(nord_b, nord_b, fr); % gleiche Ordnungen

[b3, a3] = maxflat(nord_b, 'sym', fr);  % Filter mit linearer Phase

% -------- Frequenzgänge
[H1, w] = freqz(b1,a1);
[H2, w] = freqz(b2,a2);
[H3, w] = freqz(b3,a3);

figure(1);    clf;
subplot(211), plot(w/pi, 20*log10([abs(H1), abs(H2), abs(H3)]));
La = axis;    axis([La(1:2), -100, 10]);
title(['Amplitudengaenge der IIR-Filter (fr = ',num2str(fr),')']);
xlabel('2f/fs');   grid;

subplot(212), plot(w/pi, angle([H1, H2, H3]));
title(['Phasengaenge der IIR-Filter ']);
xlabel('2f/fs');   grid;


