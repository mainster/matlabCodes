function [y, t] = gibbs3(n, flag);
% Funktion (gibbs3.m) zur Darstellung der Rekonstruktion
% eines dreieckigen Signals aus n Harmonischen
% Parameter: n = Anzahl Harmonische für die Rekonstruktion
%            flag = 1 ergibt auch eine Darstellung
% Testaufruf: gibbs3(5, 1);

T = 200;                   % Periode
t = 2*(-T/2:0.1:T/2);      % Darstellungsintervall

y = zeros(1, length(t));   % Initialisierung
nt = 2*n-1;                % Maximaler Index der Harmonischen
m = 0;
for k = 1:2:nt
   y = y + ((-1)^m)*sin(k*2*pi*t/T)/(k*k);
   m = m+1;
end;
y = y*8/(pi*pi);

if flag == 1
  figure(1);        clf;
  plot(t, y);       grid;
  title(['Rekonstruktion mit n = ', num2str(fix(n)),'  Harmonischen']);
  xlabel(['Zeit in s (T = ', num2str(T), ' s)']);
end;