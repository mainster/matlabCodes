% Programm hilbert_1.m zur Entwicklung von
% FIR-Hilbertfiltern mit den Funktionen firpm und firls

clear;
% -------- Spezifikationen des Hilbert-Filters 
nord = 21;    % Ordnung (ungerade)
f = [0.05, 1];
m = [1, 1];

% ------- Entwicklung der Filter
b_pm=firpm(nord,f,m,'hilbert');
b_ls=firls(nord,f,m,'hilbert');

% Frequenzgänge
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf);
[H_ls, w] = freqz(b_ls, 1, nf);

figure(1),    clf;
subplot(221),
plot(w/(2*pi), [abs(H_pm), abs(H_ls)]);
xlabel('f/fs');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Hilbert-Filter (nord = ',...
        num2str(nord),')']);

% -------- Spezifikationen des Hilbert-Filters 
nord = 20;    % Ordnung (ungerade)
f = [0.05, 0.95];
m = [1, 1];

% ------- Entwicklung der Filter
b_pm_g=firpm(nord,f,m,'hilbert');
b_ls_g=firpm(nord,f,m,'hilbert');

% Frequenzgänge
nf = 1024;
[H_pm, w] = freqz(b_pm_g, 1, nf);
[H_ls, w] = freqz(b_ls_g, 1, nf);

subplot(222),
plot(w/(2*pi), [abs(H_pm), abs(H_ls)]);
xlabel('f/fs');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Hilbert-Filter (nord = ',...
        num2str(nord),')']);

% -------- Koeffizienten der Remez-Filter
subplot(223), stem(0:length(b_pm)-1, b_pm);
La = axis; axis([La(1), length(b_pm)-1, La(3:4)]);
title('Koeffizienten des Filters'); grid;

subplot(224), stem(0:length(b_pm_g)-1, b_pm_g);
La = axis; axis([La(1), length(b_pm_g)-1, La(3:4)]);
title('Koeffizienten des Filters'); grid;
