% Programm fmasse_var_2.m zur Simulation eines 
% Feder-Masse_Systems mit zwei Massen angeregt durch 
% die Unebenheiten einer Fahrbahn über das Modell
% fmasse_var2.mdl

m1 = 100;    m2 = 1000;     % Massen
f1 = 10;     f2 = 1;        % Kennfrequenzen
d1 = 0.01;   d2 = 0.3;      % Dämpfungsmass


D1 = ((2*pi*f1)^2)*m1;    D2 = ((2*pi*f2)^2)*m2;       % Federsteifigkeiten
r1 = d1*2*sqrt(D1*m1);    r21 = d2*2*sqrt(D2*m2);    r22 = 3*r21;
%                           % Proportionale Dämpfungsfaktoeren

V = 100*1000/3600;          % Geschwindigkeit Fahrzeug 100 Km/h

% -------- Simulationsdauer
t0 = 0;
tfinal = 50;
d_t = 0.01;

% -------- Parameter des Rauschgenerators
W = 100;        % Leistungsspektraldichte 100 mm^2/zyklus/m 
%                                 (Unebenheiten des Bodens)
W1 = 100/V;     % Leistungsspektraldichte in mm^2/Hz
Varianz = W/(2*d_t)/V;

% -------- Sprungantwort (eine steile Rampe)
a = 1;          
hoehe = 10;     % 10 mm Rampe
laenge = 2.5;   % 2,5 m Länge der Rampe

rampe = hoehe/(laenge/V);    % Faktor für den Integrator, der die 
%                            Rampe ergibt

my_options = simset('OutputVariables', ' ','SrcWorkspace' ,'current');
[t,x,y] = sim('fmasse_var2',[t0:d_t:tfinal/30], my_options);

figure(1);     clf;
subplot(121), plot(simout(:,4), [simout(:,1), simout(:,3)]);
title('Sprungantwort für Weg 1');
xlabel('Zeit in s');    grid on;
subplot(122), plot(simout(:,4), [simout(:,2), simout(:,3)]);
title('Sprungantwort für Weg 2');
xlabel('Zeit in s');    grid on;

% -------- Antwort auf weißen Rauschen
a = -1;         % Weißes-Rauschen am Eingang
my_options = simset('OutputVariables', ' ','SrcWorkspace' ,'current');
[t,x,y] = sim('fmasse_var2',[t0:d_t:tfinal], my_options);

% -------- Standardabweichungen der zwei Massen
Varianz_eingang = std(simout(:,3))^2
Varianz_signal1 = std(simout(:,1))^2
Varianz_signal2 = std(simout(:,2))^2


% -------- Darstellung der Ergebnisse
figure(2);       clf;
subplot(311), plot(simout(:,4), simout(:,3));
ylabel('Eingang');   grid;    
subplot(312), plot(simout(:,4), simout(:,1));
ylabel('Weg Masse 1');   grid;    
subplot(313), plot(simout(:,4), simout(:,2));
ylabel('Weg Masse 2');   grid;    

% -------- Leistungsspektraldichten
Nfft = 256;
Nfft_2 = Nfft/2;
fs = 1/d_t;
delta_f = fs/Nfft;

[p0,f] = psd(simout(:,3),Nfft, fs, hanning(Nfft), Nfft/4);
[p1,f] = psd(simout(:,1),Nfft, fs);
[p2,f] = psd(simout(:,2),Nfft, fs);

% -------- Normierung der mit psd erhaltene Leistungsspektraldichte
p0 = 2*p0/fs;
p1 = 2*p1/fs;
p2 = 2*p2/fs;

figure(3);       clf;
subplot(211), plot(f, p0);
title('Leistungsdichte des Eingangs (mm^2/Hz)');
xlabel('Hz');      grid on;
subplot(223), plot(f, p1);
title('Leistungsdichte des Wegs 1 (mm^2/Hz)');
xlabel('Hz');      grid on;
subplot(224), plot(f, p2);
title('Leistungsdichte des Wegs 2 (mm^2/Hz)');
xlabel('Hz');      grid on;

Varianz_eingang_psd = sum(p0)*delta_f
Varianz_signal1_psd = sum(p1)*delta_f
Varianz_signal2_psd = sum(p2)*delta_f

Daempfung_Eingang_Masse1 = Varianz_eingang_psd/Varianz_signal1_psd
Daempfung_Masse1_Masse2  = Varianz_signal1_psd/Varianz_signal2_psd
Daempfung_Eingang_Masse2 = Varianz_eingang_psd/Varianz_signal2_psd

