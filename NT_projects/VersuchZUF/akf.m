function [cor] = akf(x,t1,t2,fs);

% AKF ... bestimmt die AKF zu den gegebenen Zeitpunkten
%
%	AKF(X,t1,t2) bestimmt die AKF des Zufallsprozesses X
%		als Scharmittel.
%       Voraussetzung: X ist gleichverteilt. 
%       Die Zeiten t1 und t2 werden in msec angegeben.
%       fs ist die Abtastfrequenz

n1 = fix(t1/1000*fs + 0.1)+1;
n2 = fix(t2/1000*fs + 0.1)+1;
[zeilen spalten] = size(x);
if n1 > spalten | n2 > spalten
    error('Musterfunktionen sind k�rzer als ein angegebener Zeitpunkt');
end

x1 = x(:,n1);
x2 = x(:,n2);
cor = x1'*x2/zeilen;

%fprintf('E{x(%5.3f),x(%5.3f)} = %e.\n',t1,t2,cor);
