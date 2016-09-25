% Programm wellig_1.m in dem die Welligkeit eines 
% Tiefpassfilters Typ Tschebyschev I im 
% Durchlassbereich untersucht wird.
% Es wird auch der ܆bergang eines Filters ohne
% Welligkeit im Durchlassbereich untersucht

% -------- Parameter des Filters
fp = 1000;  % Durchlassfrequenz
nord = 5;   % Ordnung des Filters
Rp = 0.001;  % Welligkeit im Durchlassbereich

% -------- Ermittlung der Koeffizienten des ersten Filters
[b,a]=cheby1(nord,Rp,2*pi*fp,'s');

% -------- Frequenzgang
f = logspace(floor(log10(fp/100)),ceil(log10(fp*100)), 1000);
[H,w] = freqs(b,a,2*pi*f);

% -------- Darstellung des Amplitudengangs
figure(1);     clf;
subplot(211), semilogx(w/(2*pi), 20*log10(abs(H)));
La = axis;
axis([La(1:2), -60, 0]);

title(['Amplitudengang: Tiefpassfilter Typ Tschebyschev I (fp = ',...
        num2str(fp),' Hz)']);
xlabel('Hz');  grid
ylabel('dB')

subplot(212), semilogx(w/(2*pi), 20*log10(abs(H)));
La = axis;
axis([La(1), fp*2 -Rp*1.2, 0]);
title(['Welligkeit im Durchlassbereich = ',...
        num2str(Rp),' dB']);
xlabel('Hz');  grid
ylabel('dB')

% -------- Ermittlung der Koeffizienten des zweiten Filters
[b,a]=butter(nord,2*pi*fp,'s');

% -------- Frequenzgang
f = logspace(floor(log10(fp/100)),ceil(log10(fp*100)), 1000);
[H,w] = freqs(b,a,2*pi*f);

% -------- Darstellung des Amplitudengangs
figure(2);     clf;
subplot(211), semilogx(w/(2*pi), 20*log10(abs(H)));
La = axis;
axis([La(1:2), -60, 0]);

title(['Amplitudengang: Tiefpassfilter Typ Butterworth (fp = ',...
        num2str(fp),' Hz)']);
xlabel('Hz');  grid
ylabel('dB')

subplot(212), semilogx(w/(2*pi), 20*log10(abs(H)));
La = axis;
axis([La(1), fp*2 -5, 0]);
title(['Zoom des Durchlassbereichs']);
xlabel('Hz');  grid
ylabel('dB')

