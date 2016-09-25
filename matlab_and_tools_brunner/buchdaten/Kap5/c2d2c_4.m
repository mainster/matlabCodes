function [sysc] = c2d2c_4(sysd, typ)
% Funktion c2d2c_4.m zum Experimentieren mit 
% Umwandlungsfunktionen d2c
% sysd = kontinuierliches SISO-System
% typ = 1,2,3 für zoh, tustin, prewarp
% Ts = Abtastperiode
%
% Testaufruf c2d2c_4(c2d(tf(1,[1,0.5,1]), 1), 1);

% ------- Umwandlung c2d
switch typ
   case 1 
       string = 'zoh';
       critical_freq = [];
   case 2 
       string = 'tustin';
       critical_freq = [];
   otherwise 
       string = 'prewarp';
       critical_freq = 0.4;
end;

sysc = d2c(sysd, string, critical_freq);

figure(1);     clf;
[yd,td] = step(sysd);
[yc,tc] = step(sysc);

stairs(td,yd);
hold on;
plot(tc, yc);
hold off;

title(['Sprungantwort (Verfahren = ',string, ' )']);
xlabel('Zeit in s');    grid on;
