% Programm fir_vergleich1.m zum Vergleich der 
% der Antworten von FIR-Tiefpassfiltern

clear
% -------- Ermittlung von 2 Gruppen von
% FIR-Filtern mit der Funktion fir_fenster21.m

my_text{1,1} = 'Hamming';
my_text{2,1} = 'Hanning';
my_text{3,1} = 'Gausswin';
my_text{4,1} = 'Tukey (r = 0.95)';

my_text{1,2} = 'Barthannwin';
my_text{2,2} = 'Blackmanhariss';
my_text{3,2} = 'Nuttallwin';
my_text{4,2} = 'Hann';


fs = 1000;
fmax = 300;
fr = 2*fmax/fs;

nord = 50;
delay = nord/2;

b = fir_fenster21(fr, nord);
% Liefert in dem dreidimensionalen Feld b(nf,1:4,1:2) zwei Gruppen von
% FIR-Tiefpassfiltern. Es werden auch figure(1) und (2) erzeugt

test = 1;  % 1 = Recheckige Pulse
           % 2 = Sinus-Eingang
           % 3 = Bandbegrenztes Rauschen
if test == 1,
    % ------- Aufruf der Simulation
    % Antwort auf rechteckige Pulse 
    fpuls = 50;    ki = 1;   tf = 0.1;
    fsin = 100;   % dummy Variablen fürs Modell
    frausch = 100;
elseif test == 2;
    % Antwort auf sinusförmige Signale 
    fsin = 50;     ki = 2;   tf = 0.1;
    frausch = 100;   % dummy Variablen fürs Modell
    fpuls = 100;
else    
    % Antwort auf Bandbegrenztes-Rauschen 
    frausch = 100;  ki = 3;  tf = 0.2;
    fpuls = 100;   % dummy Variablen fürs Modell
    fsin = 100;
end;

figure(3),   clf;
for k = 1:4,
    bf = b(:,k,1)'; % Filter Wahl aus erster Gruppe
    % (Zeilen Vektor)
    sim('fir_vergleich_1',[0,tf]);
    subplot(2,2,k), stairs(tout, yout(:,1));
    hold on
    stairs(tout, yout(:,2),'r');
    hold off
    La = axis;  axis([La(1), tf,...
            1.1*min(yout(:,1)), 1.1*max(yout(:,1))]);
    title(my_text{k,1});  grid;
end;    

figure(4),   clf;
for k = 1:4,
    bf = b(:,k,2)'; % Filter Wahl aus zweiter Gruppe
    % (Zeilen Vektor)
    sim('fir_vergleich_1',[0,tf]);
    subplot(2,2,k), stairs(tout, yout(:,1));
    hold on
    stairs(tout, yout(:,2),'r');
    hold off
    La = axis;  axis([La(1), tf,...
            1.1*min(yout(:,1)), 1.1*max(yout(:,1))]);
    title(my_text{k,2});  grid;
end;
