% Programm analog_hp11.m in dem das Modell analog_hp_11.mdl,
% mit den Filtern entwickelt im Programm tp2hp31.m, 
% mehrmals aufgerufen wird, um den Einfluss auf ein Eingangssignal,
% bestehend aus sinusföšrmigen Komponenten zu untersuchen.

% Entwicklung der Filter mit tp2hp31
[b,a] = tp2hp31(1000);  % Hier wird figure(1) und figure(2) erzeugt

verz = zeros(4);           % Verzögerungen für das Modell
verz(1) = 0.04e-3;         % Verzöšgerung des Bessel-Filters
verz(2) = 0.04e-3;         % Verzöšgerung des Butterworth-Filters
verz(3) = 0.04e-3;         % Verzöšgerung des Tschebyschev-Filters Typ I
verz(4) = 0.04e-3;         % Verzöšgerung des Ellip-Filters

filter_typ = {'Bessel', 'Butterworth', 'Tschebyschev I', 'Ellip'};
figure(3);      clf;
for Typ = 1:4
    delay = verz(Typ);
    sim('analog_hp_11', [0:0.00001:0.01]); % Aufruf der Simulation
    nt = length(tout);               % Dargestellter Ausschnitt   
    nd = nt-200:nt;
    subplot(2,2,Typ), plot(tout(nd), yout(nd,:))
    title(filter_typ{Typ});  grid
    La = axis;      axis([min(tout(nd)), max(tout(nd)), La(3:4)]);
    xlabel('Zeit in s')
end;    