% Programm (my_freq1.m)zur Berechnung und Darstellung 
% des Frequenzgangs eines digitalen Filters, 
% dessen Koeffizieneten in den Vektoren b(für den Zähler)
% und a (für den Nenner)enthalten sind.
% Es wird die Konvention der Signal-Processing-TB 
% vorausgesetzt
%
% Autor: W. Hartmann; Karlsruhe 1999
%
% Testaufruf: b = [1 1 1 1 1 1 1 1 1 1]/10;
%             a = 1;
%             my_freq1;
%

%------- Frequenzgang über die FFT berechnet
N = 512;          % Anzahl Bin der FFT (die größer sein muß
                  % als die Länge der Vektoren b und a)
Hz = fft(b, N);   % FFT der Koeffizienten des Zählers
Hn = fft(a, N);   % FFT der Koeffizienten des Nenners
H = Hz./Hn;       % Frequenzgang

%------- Darstellung des Frequenzgangs
figure(1);
betrag = abs(H)/max(abs(H));
subplot(211), plot((0:N-1)/N, 20*log10(betrag));
title('Amplitudengang (dB)');
xlabel('Relative Frequenz f/fs');   grid;

subplot(212), plot((0:N-1)/N, angle(H));
title('Phasengang (rad)');
xlabel('Relative Frequenz f/fs');   grid;
