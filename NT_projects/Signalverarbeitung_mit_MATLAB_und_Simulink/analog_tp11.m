% Programm analog_tp11.m in dem das Modell analog_tp_11.mdl,
% mit den Filtern entwickelt im Programm analog_tp1.m, 
% mehrmals aufgerufen wird und das Eingangssignal
% aus sinusfšrmigen Komponenten besteht.

% Entwicklung der Filter mit analog_tp1
analog_tp1;

text_{1} = 'Bessel';            
text_{2} = 'Butterworth';
text_{3} = 'Tschebyschev I';
text_{4} = 'Ellip';

verz = zeros(4);
verz(1) = 0.95e-3;          % Verzöšgerung des Bessel-Filters
verz(2) = 0.85e-3;          % Verzöšgerung des Butterworth-Filters
verz(3) = 1.05e-3;          % Verzöšgerung des Tschebyschev-Filters Typ I
verz(4) = 0.7e-3;           % Verzöšgerung des Ellip-Filters

figure(3);      clf;
for Typ = 1:4
    delay = verz(Typ);
    sim('analog_tp_11', [0, 0.025]);
    subplot(2,2,Typ), plot(tout, yout)
    title(text_{Typ});  grid
    La = axis;      axis([min(tout), max(tout), La(3:4)]);
    xlabel('Zeit in s')
end;    
nt = length(tout);
nd = fix(nt*0.43):fix(nt*0.65); % Eingeschwungener Bereich
figure(4);      clf;
for Typ = 1:4
    delay = verz(Typ);
    sim('analog_tp_11', [0, 0.025]);
    subplot(2,2,Typ), plot(tout(nd), yout(nd,:))
    title(text_{Typ});  grid
    La = axis;      axis([min(tout(nd)), max(tout(nd)), ...
            0.65, max(max(yout(nd,:)))]);
    xlabel('Zeit in s')
end;    
