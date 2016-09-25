% Skript TP_fdesign1.m, in dem ein FIR-Tiefpassfilter
% über fdesign-Objekt berechnet wird
clear;
% ------- Spezifikationen
fc = 0.2;        % Bandbreite relativ zu fs
fw = 0.03;       % Übergangsbereich relativ zu fs
fp = fc - fw/2;  % Durchlassfrequenz
fs = fc + fw/2;  % Sperrfrequenz
Ap = 0.1;        % Welligkeit im Durchlassbereich in dB
Ast = 60;         % Dämpfung des Sperrbereichs
% ------- Entwicklung des Filters
d = fdesign.lowpass('Fp,Fst,Ap,Ast', fp*2, fs*2, Ap, Ast);
methode = designmethods(d)        % Methoden aufgelistet
H1 = design(d, methode{4});       % IIR-Filter Typ 'ellip'
H2 = design(d, methode{5});       % FIR-Filter Typ 'equiripple'

disp('Filter H1')
get(H1)
disp('Filter H2')
get(H2)
% ------- Koeffizienten b des Zählers und a des Nenners
% des IIR-Filters H1
[b1, a1] = sos2tf(H1.sosMatrix);
b1 = b1*prod(H1.ScaleValues);
[H1f, w] = freqz(b1, a1);
% ------- Koeffizienten b des FIR-Filters H2
b2 = H2.Numerator;
[H2f, w] = freqz(b2, 1);
%####################
figure(1);    clf;
plot(w/(2*pi), 20*log10([abs(H1f), abs(H2f)]));
title('Amplitudengänge der  zwei Filter in dB');
La = axis;    axis([La(1:2), -100, La(4)]);
xlabel('Relative Frequenz  f / fs');    grid on;