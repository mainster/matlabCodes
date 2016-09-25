% Skript farrow_2.m in dem eine Signalfilterung mit
% Farrow-Filter untersucht wird
% Arbeitet mit Modell farrow2.mdl
clear;

del = 0.5;    % Verspätung
Hf_cub = fdesign.fracdelay(del,3);  % Kubische Interpolation
Hcub = design(Hf_cub, 'Lagrange');  % Typ Lagrange

% ------- Einheitspulsantwort
C = Hcub.Coefficients
lcub = C*[del^3, del^2, del, 1]';   % Parameter lk
hcub = flipud(lcub)';               % Einheitspulsantwort FIR-Filter
% hcub = [del^3, del^2, del, 1]*C'

figure(1);   clf;
stem(0:length(hcub)-1, hcub, 'Linewidth', 2);
title('Einheitspulsantwort des Kubischen-Filters');
xlabel('Index');   grid on;

% ------- Frequenzgang
[Hfcub, w] = freqz(hcub,1);
figure(2);   clf;
subplot(211), plot(w/(2*pi), 20*log10(abs(Hfcub)));
title('Amplitudengang');
xlabel('Relative Frequenz');   grid on;
subplot(212), plot(w/(2*pi), angle(Hfcub));
title('Phasengang');
xlabel('Relative Frequenz');   grid on;

% ------- Beispiel für eine Interpolierung
Ts = 2;      Tfinal = 500;
t = 0:Ts:Tfinal-Ts;
nt = length(t);

% ------- Bandbegrenztes Eingangssignal 
randn('seed', 9375);
noise = randn(1,nt);
nord = 128;
x = filter(fir1(nord,0.4), 1, noise);  % Eingangssignal
% ------- Fractional-delay Filterung
y = filter(hcub, 1, x);

figure(3);   clf;
nd = 100:110;
subplot(211), stem(t(nd), x(nd));
hold on;
stem(t(nd), y(nd), 'r*');
title(['Kubische Lagrange-Interpolation mit den Werten an den Berechnungsstellen',...
    ' (Delta = ',num2str(del),' )']);
xlabel(['Zeit in s (Ts = ',num2str(Ts),' s)']);    grid on;
hold off

hold off;
subplot(212), stem(t(nd), x(nd));
hold on;
stem(t(nd)-(2*Ts-del*Ts), y(nd), 'r*');
title(['Kubische Lagrange-Interpolation mit den Werten korrekt platziert',...
    ' (Delta = ',num2str(del),' )']);
xlabel(['Zeit in s (Ts = ',num2str(Ts),' s)']);    grid on;
hold off

% -------- Erzeugung eines Modells
realizemdl(Hcub, 'Destination', 'current', 'OverwriteBlock', 'on',...
    'Blockname','Farrow Filter');
% -------- Aufruf der Simulation
simin = [t', x'];      % Anregung im Simulink-Modell farrow2.mdl
sim('farrow2', [0, Tfinal]);

ts = ysim.time;
xs = ysim.signals.values(:,1);
ys = ysim.signals.values(:,2);

figure(4);    clf;
subplot(211), stairs(ts, xs);
hold on;      stairs(ts,  ys, 'r');
title(['Kubische Lagrange-Interpolation mit den Werten an den Berechnungsstellen',...
    ' (Delta = ',num2str(del),' )']);
xlabel(['Zeit in s (Ts = ',num2str(Ts),' s)']);    grid on;
hold off
subplot(212), stairs(ts, xs);
hold on;      stairs(ts -(2*Ts-del*Ts),  ys, 'r');
axis tight;
title(['Kubische Lagrange-Interpolation mit den Werten korrekt platziert',...
    ' (Delta = ',num2str(del),' )']);
xlabel(['Zeit in s (Ts = ',num2str(Ts),' s)']);    grid on;
hold off