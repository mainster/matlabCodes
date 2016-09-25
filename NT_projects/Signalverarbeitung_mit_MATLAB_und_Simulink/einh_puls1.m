% Programm einh_puls1.m in dem die Einheitspulsantworten
% und Sprungantworten der Tiefpassfilter entwickelt mit 
% analog_tp1.m ermittelt wird.

% Entwicklung der Filter mit analog_tp1
analog_tp1;
text_{1} = 'Bessel';            
text_{2} = 'Butterworth';
text_{3} = 'Tschebyschev I';
text_{4} = 'Ellip';

% ------- Impulsantwort
k1 = 1;     k2 = 0;
dt = 1e-5;      % Dauer des Pulses
d_t = 1e-6;     % Maximale Schrittweite der Simulation;
my_options = simset('MaxStep', d_t);

figure(3);      clf;
for Typ = 1:4
    sim('einh_puls_1', [0:dt:0.01], my_options);
    subplot(2,2,Typ),plot(tout, yout/dt)
    title(text_{Typ});  grid
    La = axis;      axis([min(tout), max(tout), La(3:4)]);
    xlabel('Zeit in s')
end;    

% ------- Sprungantwort als Integral der Impulsantwort
figure(4);      clf;
for Typ = 1:4
    sim('einh_puls_1', [0:dt:0.01]);
    subplot(2,2,Typ),plot(tout, cumsum(yout/dt)*dt)
    title(text_{Typ});  grid
    La = axis;      axis([min(tout), max(tout), La(3:4)]);
    xlabel('Zeit in s')
end;    

% ------- Sprungantwort Ÿber Sprung am Eingang
k1 = 0;     k2 = 1;
figure(5);      clf;
for Typ = 1:4
    sim('einh_puls_1', [0:dt:0.01], my_options);
    subplot(2,2,Typ),plot(tout, yout)
    title(text_{Typ});  grid
    La = axis;      axis([min(tout), max(tout), La(3:4)]);
    xlabel('Zeit in s')
end;    





