function [l_xx, t_out] = zeit_akf(x,t_l, fs);

% ZEIT_AKF ... bestimmt die zeitliche AKF 
%
%	[l_xx, t_out] = ZEIT_AKF(X,t_l) bestimmt die AKF des Zufallsprozesses X
%		als zeitliches Mittel.
%       Die AKF wird f�r alle Verschiebungen im Bereich [-t_l, t_l],
%       angegeben in msec, berechnet.
%       Das Ergebnis wird in dem Vektor l_xx geliefert. Zus�tzlich wird
%       noch der Vektor t_out mit den Zeit-St�tzpunkten geliefert. 
%       Die Funktion stellt das Ergebnis auch graphisch dar. 


% wir berechnen dopplet so viel wie gew�nscht, damit wir
% die wegwerfen k�nnen, wo sich die Signale nicht mehr voll �berlappen 
t_lag = t_l/1000; %% Eingabe der Zeit in msec
nsize = fix(2*t_lag*fs);
[row col] = size(x);
if(row>col)
    x=x';
    n=row;
else
    n=col;
end

if(nsize > n)
    nsize = n;
end;

k = fix((n)/(nsize));	    %Anzahl Fenster

umin  = nsize/2; %% Bereich der Werte, in dem wir volle �berlappung haben, wo wir also so tun 
umax = 3*nsize/2; %% k�nnen, als ob unser Signal unendlich w�re

l_xx  = zeros(1,2*nsize-1);
index = 1:nsize;
for i=1:k
    rx = xcorr(x(index),'unbiased');
     index = index + (nsize);
     l_xx = l_xx + rx;
end
l_xx = l_xx/k;

% die am Rand brauchen wir nicht (wir haben ja doppelt so breit angesetzt)
l_xx = l_xx(nsize/2 : 3*nsize/2);
t_out = -t_lag : 1/fs : t_lag;

% plot(t_out,l_xx),         ...
% title('l_{xx}'),        ...
% xlabel('Zeit [sec]'), ...
% grid on, axis tight;
