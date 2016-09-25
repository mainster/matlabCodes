% Programm frd_1.m in dem ein FRD-Modell erzeugt
% und untersucht wird

% ------- Künstliche Daten
% SISO-System
my_kuenstlich = tf(1,[0.1^2, 0.2*0.1, 1]);

f = logspace(-1,2,500);
G = freqresp(my_kuenstlich, 2*pi*f);
G = squeeze(G(1,1,:));

figure(1);     clf;
subplot(211), semilogx(f, 20*log10(abs(G)));
title('Amplitudengang ');    xlabel('Hz');     grid on;
ylabel('dB');
subplot(212), semilogx(f, angle(G)*180/pi);
title('Phasengang');    xlabel('Hz');     grid on;
ylabel('Grad');

% In f sind 500 Frequenzen und in G 500 Werte des Frequenzgangs enthalten
% und diese bilden die künstlichen Daten für die Erzeugung eines FRD-Modells

% -------- Erzeugung eines FRD-Modells

my_sys = frd(G, f, 'Units','Hz');

disp('FRD-System aus den Daten');
get(my_sys)

% oder durch Umwandlung
my_sys1 = frd(my_kuenstlich, f, 'Units','Hz');

disp('FRD-System aus der Umwandlung eines TF-Systems');
get(my_sys1)

