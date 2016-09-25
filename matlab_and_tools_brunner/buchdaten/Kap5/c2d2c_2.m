function [sysd] = c2d2c_2(sysc, Ts, typ)
% Funktion c2d2c_2.m zum Experimentieren mit 
% Umwandlungsfunktionen c2d 
% sysc = kontinuierliches SISO-System
% typ = 1,2,3,4,5 für zoh, foh, tustin, prewarp, matched
% Ts = Abtastperiode
%
% Testaufruf c2d2c_2(tf(1,[1,0.5,1]), 1, 1);

% ------- Umwandlung c2d
switch typ
   case 1 
       string = 'zoh';
       critical_freq = [];
   case 2 
       string = 'foh';
       critical_freq = [];
   case 3 
       string = 'tustin';
       critical_freq = [];
   case 4
       string = 'prewarp';
       critical_freq = 0.5;
   otherwise
       string = 'matched';
       critical_freq = [];
end;

sysd = c2d(sysc, Ts, string, critical_freq);

figure(1);     clf;
[yc,tc] = step(sysc);
[yd,td] = step(sysd);

plot(tc,yc);
hold on;
stairs(td, yd);
hold off;

title(['Sprungantwort (Verfahren = ',string, ' )']);
xlabel('Zeit in s');    grid on;
