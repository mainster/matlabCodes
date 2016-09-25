function [] = delta_w1(omega_b, t);
% Programm (delta_w1.m) mit dem gezeigt wird, daß
% das Integral einer Exponentialfunktion zur Delta-
% Funktion führt
% Parameter: omega_b = Bereich der Kreisfrequenz
%            t = Zeitvektor
% Testaufruf: delta_w1(5, 0:0.1:2);
%
nw = 200;            	% Anzahl Punkte für Omega
d_omega = omega_b/nw;
omega = -omega_b:d_omega:omega_b;
length(omega);

nt = length(t);         % Länge des Zeitvektors

%------ Einzelne Cosinus-Komponenten
delta = zeros(nt,2*nw+1);
for k = 1:nt
   delta(k,:) = cos(omega*t(k));
end;

%------ Approximation der Delta-Funktion')
delta_o = sum(delta)*(t(2)-t(1))/pi;

figure(1);		clf;
subplot(211), plot(omega, delta);
title('Cosinuskomponenten');
xlabel('omega  rad/s');	grid;

subplot(212), plot(omega, delta_o);
title('Delta-Funktion');
xlabel('omega  rad/s');	grid;
% keyboard;

%------ Fläche der angenäherten Delta-Funktion
flaeche = sum(delta_o)*d_omega;
text(omega_b/3,max(delta_o)/2,['Fläche = ',...
      num2str(flaeche)]);  


