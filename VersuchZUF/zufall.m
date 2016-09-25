function [x, fAbtast] = zufall(bereich, len)

% zufall ................. erzeugt die Musterfunktionen des Prozesses
%		  X(t) =  cos(2*pi*1000*t + THETA).
%
%	X = zufall([a1,a2,...]) verwendet die Werte {a1,a2,...} als Werte für 
%		die gleichverteilte Zufallsvariable THETA.
%
%     	X(n,k) ist der Wert der n-ten Musterfunktion zur Zeit t entsprechend 
%       t= k/fabtast (in Sekunden).
%       fabtast = 100 kHz
%       Beispiel: X(1, 4000) ist der Wert für des Prozesses zum Zeitpunkt 
%       t=4000/100000 sec = 0.04 sec = 40 ms 
%       für die Realisierung a1
%

fTraeger = 1000;  
fAbtast = 100000;   

leng = len/1000; %% Eingabe der Zeit in msec

t = 0:1/fAbtast:leng-1/fAbtast;
dimens = length(bereich);
for ii = 1:dimens
  x(ii,:) = cos(2*pi*fTraeger*t + bereich(ii));
end
