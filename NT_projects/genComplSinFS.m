% Function generate Complex Sinusodial
%
%   fc:     Frequenz der Schwingung 
%   n:      n Perioden von 1/fc werden gesamplt??
%   Are:    Amplitude Re
%   Aim:    Amplitude Im
%   phi:    Phase zwischen Re und Im
%   DCre:   Gleichanteil von Re
%   DCim:   Gleichanteil von Im
%
%   [time,fsam,res]:
%   time: ... ist der Zeitvektor der erzeugt wurde unter einhaltung von
%       - n*Tc mit n el. Integers+
%       - length(t) modulo 32 = 0
%   fsam: ... ist Rückgabewert der Samplefrequenz
%   res:  ... vektor mit den erzeugten Funktionswerten
%
% function [time,res] = genComplSin(fc,fs,Are,Aim,phideg,DCre,DCim)
% Tc=1/fc;
% Ts=1/fs;
% n=20;
% 
% phi=phideg*pi/180;
% 
%     t=[0:Ts:n*Tc-Ts];  
%     time=t;
% 
%     sig=DCre+Are*cos(2*pi*fc*t) + i*(DCim+Aim*sin(2*pi*fc*t+phi));
%     res=sig.';
% 
% end

function [time,res] = genComplSin(fc,fs,n,Are,Aim,phideg,DCre,DCim)
Tc=1/fc;
Ts=1/fs;
phi=phideg*pi/180;

    t=[0:Ts:(n-1)*Ts];  
    time=t;

    sig=DCre+Are*cos(2*pi*fc*t) + i*(DCim+Aim*sin(2*pi*fc*t+phi));
    res=sig.';

end