function []=isop(M,k)
% Funktion isop.m zur untersuchung eines ISOP-Filters
% (Interpolated-Second-Order-Polynomial) füŸr die Kompensation 
% von CIC-Filtern
% M = VerspŠtung des CIC-Filters 
% k = 1 oder 2
% Testaufruf: isop(1,2);


I = k*M;
c = -9;
w = 0:0.01:2*pi;

% ------- Frequenzgang des ISOP-Filters
P = abs(c+2*cos(w*I))/abs(c+2);

figure(1);    clf;
plot(w/(2*pi),20*log10(P));
title(['Amplitudengang des ISOP-Filters (I = ',...
    num2str(I),'; c = ',num2str(c),')']);
xlabel('f/fs');
ylabel('dB');       grid;

