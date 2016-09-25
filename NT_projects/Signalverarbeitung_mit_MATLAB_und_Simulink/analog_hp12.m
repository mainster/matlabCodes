% Programm analog_hp12.m in dem das Modell analog_hp_12.mdl,
% mit den Filtern entwickelt im Programm tp2hp31.m, 
% mehrmals aufgerufen wird und das Eingangssignal
% aus Rauschen mit begrenzter Bandbreite besteht.

% Entwicklung der Filter mit analog_tp1
[b,a] = tp2hp31(100);

text{1} = 'Bessel';            
text{2} = 'Butterworth';
text{3} = 'Tschebyschev I';
text{4} = 'Ellip';

verz = zeros(4);
verz(1) = 0.3e-3;          % Verzšgerung des Bessel-Filters
verz(2) = 0.3e-3;          % Verzšgerung des Butterworth-Filters
verz(3) = 0.3e-3;          % Verzšgerung des Tschebyschev-Filters Typ I
verz(4) = 0.3e-3;           % Verzšgerung des Ellip-Filters

dt = 1e-6;

figure(3);      clf;
for Typ = 1:4
    delay = verz(Typ);
    sim('analog_hp_12', [0:dt:0.04]);
    nt = length(tout);
    nd = fix(nt*0.9):fix(nt);
    subplot(2,2,Typ), plot(tout(nd), yout(nd,:))
    title(text{Typ});  grid
    La = axis;      axis([min(nd)*dt, max(nd)*dt, La(3:4)]);
    xlabel('Zeit in s')
end;    

