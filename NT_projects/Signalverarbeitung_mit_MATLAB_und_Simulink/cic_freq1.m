function [H,w]=cic_freq1(M,R,N)
% Funktion zur Ermittlung und Darstellung des 
% Frequenzgangs eines CIC-Dezimierungsfilters
% M = Differential-Delay
% R = Dezimierungsfaktor
% N = Anzahl Stufen
%
% Testaufruf: cic_freq1(4,4,3);

fr = 0:0.001:1;    % Relative Frequenz
gain = (M*R)^N;

H = gain*exp(-j*pi*fr*(M*R-1)*N).*((sinc(fr*M*R)./sinc(fr)).^N);
betrag = abs(H);
phase = angle(H);

figure(1);   clf;
subplot(211),
plot(fr, 20*log10(betrag/gain));
La = axis;   axis([La(1:2),-40*N, 0])
title(['Amplitudengang (R = ',num2str(R),'; M = ',...
    num2str(M),'; N = ',num2str(N),'; Gain = ',num2str(gain),')']);
%--------------------------------------------------
N = N+1;
gain = (M*R)^N;

H = gain*exp(-j*pi*fr*(M*R-1)*N).*((sinc(fr*M*R)./sinc(fr)).^N);
betrag = abs(H);
phase = angle(H);

hold on
plot(fr, 20*log10(betrag/gain),'r');
La = axis;   axis([La(1:2),-40*N, 0])
xlabel('f/fs');   grid;
hold off
