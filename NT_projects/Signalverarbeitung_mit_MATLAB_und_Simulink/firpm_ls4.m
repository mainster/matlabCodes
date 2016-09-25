% Programm firpm_ls4.m zur Untersuchung der 
% firpm- und firls-Filter

clear;

% -------- Einfaches Beispiel für ein Tiefpassfilter 
nord = 64;
f = [0 0.1 0.15 0.25 0.3 0.4 0.45 0.55 0.6 0.7 0.75 0.85 0.9 1];
m = [1  1   0    0    1   1   0    0    1   1   0    0    1  1];

b_pm = firpm(nord, f, m);
b_ls = firls(nord, f, m);

% Frequenzgänge
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf);
[H_ls, w] = freqz(b_ls, 1, nf);

figure(1),    clf;
subplot(211),
plot(w/pi, [abs(H_pm), abs(H_ls)]);
xlabel('2f/fs');    grid;
La = axis;  axis([La(1:2), 0, 1.1]);
title(['firpm- und firls-Filter (linear) (Ordnung = ',...
        num2str(nord),')']);

subplot(212),
plot(w/pi, [20*log10(abs(H_pm)), 20*log10(abs(H_ls))]);
xlabel('2f/fs');    grid;
ylabel('dB');
La = axis;  axis([La(1:2), -60, 10]);
title('firpm- und firls-Filter (logarithmisch)');






