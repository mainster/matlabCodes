%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Diskrete Faltung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NT WS11-12 A3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Die Sendesymbole y eines Nachrichtenübertragungssystems sind
% unkorreliert, d.h. lyy(n) = δ0(n).
% Der Übertragungskanal hat die Impulsantwort h(n) = [1  0.5].

h=[1 0.5];		% Impulsantwort des Kanals
y=1;
lyy=1;
% a) Berechnen Sie die Autokorrelationsfunktion der Empfangssymbole x
%
% lxx(n) = conv( lyy(n), lhh(n) )

lhh = xcorr(h);
lxx = conv(lyy, lhh)

f1=figure(1);
clf;
SUB=220;

nn=[-1:4];
subplot(SUB+1);
stem(lyy); xlim([-1,4]); grid on; 
title('Eingangssignal lyy[n]');
subplot(SUB+3);
stem(lhh); xlim([-1,4]); grid on; 
title('System akf lhh[n]');


