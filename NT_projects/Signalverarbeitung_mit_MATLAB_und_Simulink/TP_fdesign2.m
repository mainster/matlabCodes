% Skript TP_fdesign2.m, in dem ein FIR-Tiefpassfilter
% über fdesign-Objekt berechnet wird
clear;
% ------- Spezifikationen
fc = 0.2;        % Bandbreite relativ zu fs
Ap = 0.1;        % Welligkeit im Durchlassbereich in dB
Ast = 60;        % Dämpfung des Sperrbereichs
N = 128;         % Ordnung des Filters
% ------- Entwicklung des Filters
d = fdesign.lowpass('N,Fc,Ap,Ast', N, fc*2, Ap, Ast);
H1 = design(d,'fircls','FilterStructure','dfsymfir');
              % FIR-Filter Typ 'fircls'
%H1 = design(d,'equiripple');  
              % FIR-Filter Typ 'equiripple'
disp('Filter H1')
get(H1)
% ------- Koeffizienten b des FIR-Filters H1
b1 = H1.Numerator;
[H1f, w] = freqz(b1, 1);
%####################
figure(1);    clf;
plot(w/(2*pi), 20*log10([abs(H1f), abs(H1f)]));
title('Amplitudengang des Filters in dB');
La = axis;    axis([La(1:2), -100, La(4)]);
xlabel('Relative Frequenz  f / fs');    grid on;