% Programm ittice1.m zum Vergleich einer direkten Form
% mit einer Lattice-Form für ein quantisiertes IIR-TP-Filter

% --------- Lineares FIR-Filter
nord = 7;      Rp = 0.1;     Rs = 60;       fr = 0.4;
[b,a] = ellip(nord, Rp, Rs, fr);

% --------- Direkt Struktur II
q = quantizer('Mode','fixed','OverflowMode','saturate','format',[16,15]);
q1 = quantizer('Mode','fixed','OverflowMode','saturate','format',[32,30]);

hqd = qfilt('df2',{b,a},'CoefficientFormat',q,...
                        'InputFormat',q,...
                        'OutputFormat',q,...
                        'MultiplicandFormat',q,...
                        'ProductFormat',q1,...
                        'SumFormat',q1);
hqdn = normalize(hqd);

% --------- Lattice Strukur
[kl,vl] = tf2latc(b,a);
kql = qfilt('FilterStructure','latticearma','ReferenceCoefficients',{kl,vl});

% --------- Frequenzgänge
[Hd,w] = freqz(hqdn);
[Hk,w] = freqz(kql);

figure(1);   clf;
plot(w/(2*pi), [20*log10(abs(Hd)), 20*log10(abs(Hd))]);
title('Frequenzgang fuer die Lattice und Direkte Form II');
xlabel('f/fs');     grid;

[Hdn, w, Psdd, noised] = nlm(hqdn);
[Hkn, w, Psdk, noisek] = nlm(kql);

figure(2);   clf;
subplot(121), plot(w/(2*pi), 20*log10(abs(Hdn)));
La = axis;   axis([La(1:2), -100, 10]);
title('nlm Direkt-Form II');
xlabel('f/fs');    grid;
text(0.05, -25, ['Noisefigure = ', num2str(10*log10(noised)),' dB']);

subplot(122), plot(w/(2*pi), 20*log10(abs(Hkn)));
La = axis;   axis([La(1:2), -100, 10]);
title('nlm Lattice ARMA-Form');
xlabel('f/fs');    grid;
text(0.05, -25, ['Noisefigure = ', num2str(10*log10(noisek)),' dB']);
