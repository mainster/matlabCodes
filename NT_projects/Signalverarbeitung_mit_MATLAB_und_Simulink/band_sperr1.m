% Programm band_sperr1.m, in dem ein analoges elliptisches
% Bandsperre-Filter entwickelt wird 

% ------- Tiefpass-Prototyp-Filter
Rp = 0.1;       % 0,1 dB Welligkeit im Durchlaﬂbereich
Rs = 60;        % 60 dB Dampfung im Sperrbereich
nord = 4;       % Ordnung des Tiefpassprototyp-Filters (8/2)

[z,p,k] = ellipap(nord, Rp, Rs);    % Null- Polstellen des Prototyps
[b,a] = zp2tf(z,p,k);               % Parameter der ‹bertragungsfunktion des Prototyps

[Hap,wap] = freqs(b,a, 2*pi*logspace(-1,1,500)); % Frequenzgang des Prototyps
fap = wap/(2*pi);

% ------- Transformation zu Bandsperrefilter
f1 = 1000;          f2 = 2000;
fm = sqrt(f1*f2);   B = f2 - f1;
%fm = (f1 + f2)/2;   B = f2 - f1;

[zaehler, nenner] = lp2bs(b,a,fm*2*pi,B*2*pi);  % Das Bandsperre-Filter

[Hbs,wbs] = freqs(zaehler,nenner,2*pi*logspace(2,4,500)); % Frequenzgang des Bandsperre-Filter
fbs = wbs/(2*pi);

figure(1);      clf;
subplot(221), semilogx(fap, 20*log10(abs(Hap)));
title('TP-Prototyp');   grid;
subplot(223), semilogx(fap, angle(Hap)*180/pi);
xlabel('Hz');           grid;

subplot(222), semilogx(fbs, 20*log10(abs(Hbs)));
title('Bandsperre-Filter');     grid;
subplot(224), semilogx(fbs, angle(Hbs)*180/pi);
xlabel('Hz');                   grid;


