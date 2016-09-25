function [varargout] = korr(varargin)
% Funktionsroutine (korr.m) als Beispiel für Funktionen 
% mit variabler Anzahl von Argumenten
%
% Testauftuf: x1 = randn(1,10);   y1 = randn(1,10)
%             x2 = sin(2*pi*(0:19)/5);
%             y2 = cos(2*pi*(0:19)/5+pi/3);
%    [k1,k2,k3,k4] = korr(x1, y1, x2, y2, x1, y2, x2, y1);

for k = 1:2:length(varargin)-1
   korrel{(k-1)/2+1} = xcorr(varargin{k},varargin{k+1});
end; 

korrel,   korrel{1},   korrel{2},
n1 = length(korrel{1});       n2 = length(korrel{2});

figure(1);
subplot(211), stem(-(n1-1)/2:(n1-1)/2, korrel{1});
title('Korrelationsfunktionen');
xlabel('k');          grid;
subplot(212), stem(-(n2-1)/2:(n2-1)/2, korrel{2});
xlabel('k');          grid;

varargout = korrel;    % Ausgangsargumente als Zellen 