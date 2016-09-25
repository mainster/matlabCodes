% Programm firpm_ord1.m zur Entwicklung eines 
% Tiefpassfilters mit firpmord- und firpm-Funktion

clear;
% -------- Spezifikationen des Tiefpassfilters 

fp = 1500;   % Durchpassfrequenz
fstop = 2000; % Sperrfrequenz
Rp = 0.01;    % Welligkeit im Durchlassbereich (Absolutwert)
Rs = 0.1;     % DŠmpfung im Sperrbereich (Absolutwert)

fs = 8000;    % Abtastfrequenz

% ------- Entwicklung des Filters
[nord, fo, mo, Wo] = firpmord([fp,fstop],[1,0],[Rp,Rs], 8000);
b_pm = firpm(nord, fo, mo, Wo);
% oder
%c = remezord([1500,2000],[1,0],[0.01,0.1], 8000, 'cell');
%b_remez1 = remez(c{:});

% Frequenzgang
nf = 1024;
[H_pm, w] = freqz(b_pm, 1, nf);

figure(1),    clf;
subplot(211),
plot(w*fs/(2*pi), abs(H_pm));
xlabel('f in Hz');    grid;
La = axis;  axis([La(1:2), 0, 1.1]);
title(['firpm-Filter (linear) (Ordnung = ',...
        num2str(nord),'; W = [',num2str(Wo'),'] )']);

subplot(212),
plot(w*fs/(2*pi), 20*log10(abs(H_pm)));
xlabel('f in Hz');    grid;
ylabel('dB');
La = axis;  axis([La(1:2), -60, 10]);
title('firpm-Filter (logarithmisch)');

figure(2),    clf;
subplot(211),
plot(w*fs/(2*pi), abs(H_pm));
xlabel('f in Hz');    grid;
La = axis;  axis([La(1:2), 0.95, 1.015]);
title(['firpm-Filter (linear) (Ordnung = ',...
        num2str(nord),'; W = [',num2str(Wo'),'] )']);

subplot(212),
plot(w*fs/(2*pi), 20*log10(abs(H_pm)));
xlabel('f in Hz');    grid;
ylabel('dB');
La = axis;  axis([La(1:2), -1, 1]);
title('firpm-Filter (logarithmisch)');





