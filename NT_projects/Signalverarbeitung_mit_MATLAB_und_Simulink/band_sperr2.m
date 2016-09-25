% Programm band_sperr2.m, in dem ein analoges elliptisches
% Bandsperre-Filter entwickelt wird 
clear;
f1 = 1000;          f2 = 2000;   % Bandsperrebereich
Rp = 0.1;           Rs = 60;     % Welligkeit im Durchlaﬂ- bzw. Sperrbereich
nor = 4;                         % Ordnung des TP-Prototyps
[zaehler, nenner] = ellip(nor, Rp, Rs, [f1, f2]*2*pi,...
    'stop','s');                 % Das Bandsperre-Filter

[Hbs, wbs] = freqs(zaehler, nenner, 2*pi*logspace(2,4,500));      % Frequenzgang des Bandsperre-Filter
fbs = wbs/(2*pi);

figure(1);      clf;
subplot(211), semilogx(fbs, 20*log10(abs(Hbs)));
title('Bandsperre-Filter');     grid;
subplot(212), semilogx(fbs, angle(Hbs)*180/pi);
xlabel('Hz');                   grid;

% -------- Null- Polstellenverteilung
[z,p,k] = tf2zp(zaehler, nenner);

figure(2);      clf;
zplane(z,p);
title('Null- Polstellenverteilung');


