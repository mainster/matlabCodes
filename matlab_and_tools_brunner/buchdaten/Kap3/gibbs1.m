function [y, t] = gibbs1(n, flag);
% Funktion (gibbs1.m) zur Darstellung der Rekonstruktion
% eines rechteckigen Signals aus n Harmonischen, die das
% Gibbs-Phänomen zeigt
% Parameter: n = Anzahl Harmonische für die Rekonstruktion
%            flag = 1 ergibt auch eine Darstellung
% Testaufruf: gibbs1(5, 1);

T = 200;                   % Periode
t = (-T/2:0.1:T/2);      % Darstellungsintervall

y = zeros(1, length(t));   % Initialisierung
nt = 2*n-1;                % Maximaler Index der Harmonischen
m = 0;
for k = 1:2:nt
   y = y + ((-1)^m)*cos(k*2*pi*t/T)/k;
   m = m+1;
end;
y = y*4/pi;

if flag == 1
  figure(1);        clf;
  plot(t, y);       grid;
  title(['Rekonstruktion mit n = ', num2str(fix(n)),'  Harmonischen']);
  xlabel(['Zeit in s (T = ', num2str(T), ' s)']);
end;