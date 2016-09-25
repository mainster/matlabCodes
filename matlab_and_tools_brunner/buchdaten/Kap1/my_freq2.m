function [H, w] = my_freq2(b,a);
% Funktion(my_freq2.m)zur Berechnung und Darstellung 
% des Frequenzgangs eines digitalen Filters, 
% Argumente: b,a = Vektoren der Koeffizienten 
%            H = Komplexer Frequenzgang
%            w = Frequenzen (relativ zur Abtastfrequenz)
%
% Autor: W. Hartmann; Karlsruhe 1999
%
% Testaufruf: b = [1 1 1 1 1 1 1 1 1 1]/10;
%             a = 1;
%             my_freq2(b,a);
%

n_out = nargout; 
%------- Frequenzgang über die FFT berechnet
N = 512;          % Anzahl Bin der FFT (die größer sein muß
                  % als die Länge der Vektoren b und a)
Hz = fft(b, N);   % FFT der Koeffizienten des Zählers
Hn = fft(a, N);   % FFT der Koeffizienten des Nenners
H = Hz./Hn;       % Frequenzgang
w = (0:N-1)/N;

if n_out == 0;
   %------- Darstellung des Frequenzgangs
   figure(1);
   betrag = abs(H)/max(abs(H));
   subplot(211), plot((0:N-1)/N, 20*log10(betrag));
   title('Amplitudengang (dB)');
   xlabel('Relative Frequenz f/fs');   grid;

   subplot(212), plot((0:N-1)/N, angle(H));
   title('Phasengang (rad)');
   xlabel('Relative Frequenz f/fs');   grid;
end;