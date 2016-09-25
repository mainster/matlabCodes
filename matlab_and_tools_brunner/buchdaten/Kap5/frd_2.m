% Programm frd_2.m in dem ein FRD-Modell erzeugt
% und untersucht wird

% ------- Künstliche Daten
% SISO-System
my_kuenstlich1 = tf(1,[0.1^2, 0.2*0.1, 1]);
my_kuenstlich2 = tf([0.1, 1],[0.1^2, 0.2*0.1, 1]);
my_kuenstlich3 = tf(1,[0.1, 1]);
my_kuenstlich4 = tf(1,[0.2^2, 0.5*0.2, 1]);
my_kuenstlich5 = tf(1,[0.5, 1]);
my_kuenstlich6 = tf([0.2, 1],[0.1^2, 0.2*0.1, 1]);

my_kuenstlich = [my_kuenstlich1, my_kuenstlich2;...
                 my_kuenstlich3, my_kuenstlich4;...
                 my_kuenstlich5, my_kuenstlich6];
            
f = logspace(-1,2,500);
G = freqresp(my_kuenstlich, 2*pi*f);
G = squeeze(G(1,1,:));

% In f sind 500 Frequenzen und in G 3 x 2 x 500 Werte der Frequenzgäge enthalten
% und diese bilden die künstlichen Daten für die Erzeugung eines FRD-Modells

% -------- Erzeugung eines FRD-Modells
% aus den Daten
my_sys = frd(G, f, 'Units','Hz');

disp('FRD-System aus den Daten');
get(my_sys)

% oder durch Umwandlung
my_sys1 = frd(my_kuenstlich, f, 'Units','Hz');

disp('FRD-System aus der Umwandlung eines TF-Systems');
get(my_sys1)

