% Programm differenzier_1.m zur Entwicklung von
% FIR-Differenzierfiltern mit den Funktionen firpm und firls

clear;
% -------- Spezifikationen des Differenzierers 
fs = 8000;    % Abtastfrequenz
nord = 21;    % Ordnung (ungerade)

% ------- Entwicklung der Filter
b_pm=firpm(nord,[0,1],[0,1],'differentiator');
b_ls=firls(nord,[0,1],[0,1],'differentiator');

% Frequenzgänge
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf);
[H_ls, w] = freqz(b_ls, 1, nf);

figure(1),    clf;
subplot(221),
plot(w*fs/(2*pi), [abs(H_pm), abs(H_ls)]);
xlabel('f');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Diff.-Filter (nord = ',...
        num2str(nord),')']);

% -------- Spezifikationen des Differenzierers 
fs = 8000;    % Abtastfrequenz
nord = 20;    % Ordnung (gerade)

% ------- Entwicklung der Filter
b_pm_g=firpm(nord,[0,0.9],[0,1],'differentiator');
b_ls_g=firls(nord,[0,0.9],[0,1],'differentiator');

% Frequenzgänge
nf = 1024;
[H_pm, w] = freqz(b_pm_g, 1, nf);
[H_ls, w] = freqz(b_ls_g, 1, nf);

subplot(222),
plot(w*fs/(2*pi), [abs(H_pm), abs(H_ls)]);
xlabel('f');    grid;
%La = axis;  axis([La(1:2), 0, 1.1]);
title(['Diff.-Filter (nord = ',...
        num2str(nord),')']);

% -------- Koeffizienten der firpm-Filter
subplot(223), stem(0:length(b_pm)-1, b_pm);
La = axis; axis([La(1), length(b_pm)-1, La(3:4)]);
title('Koeffizienten des Filters'); grid

subplot(224), stem(0:length(b_pm_g)-1, b_pm_g);
La = axis; axis([La(1), length(b_pm_g)-1, La(3:4)]);
title('Koeffizienten des Filters'); grid
