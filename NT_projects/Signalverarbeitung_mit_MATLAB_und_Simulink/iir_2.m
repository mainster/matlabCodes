% Programm iir_2.m zur Untersuchung von IIR-Filtern.
% Arbeitet mit dem Modell iir2.mdl

clear

% ------- Ermittlung der Filter mit iir_1.m
iir_1;    % In den Feldern zaehler und nenner sind die 
          % Koeffizienten der Filter hinterlegt
          % hier werden figure(1) bis figure(3) erzeugt
% Es werden nur die Filter, die mit der Bilineare-
% Transformation diskretisiert sind, benutzt

b1 = zaehler(1,:,2);      a1 = nenner(1,:,2);  % Bessel
b2 = zaehler(2,:,2);      a2 = nenner(2,:,2);  % Butter.
b3 = zaehler(3,:,2);      a3 = nenner(3,:,2);  % Tscheby. I
b4 = zaehler(5,:,2);      a4 = nenner(5,:,2);  % Ellip
b5 = zaehler(4,:,2);      a5 = nenner(4,:,2);  % Tscheby. II

my_text{1} = 'Bessel-Filter';
my_text{2} = 'Butterworth-Filter';
my_text{3} = 'Tschebyschev-Filter Typ I';
my_text{4} = 'Elliptisches-Filter';

disp(['Abtastfreq = ',num2str(fs)])

% Dummy Parameter für das Modell iir2.mdl
frausch = 200;     % Bandbreite des Rauschsignals
f1 = 50; f2 = 150;  f3 = 250;
kr = 0;
k1 = 1;  k2 = 1/3;  k3 = 1/5;
k4 = 0;
k5 = 0;
frechteck = 10;

% -------- Untersuchung der Antwort auf 
% bandbegrenztes Rauschen
kr = 1;
k1 = 0;  k2 = 0;  k3 = 0;  k4 = 0;  k5 = 0;

% -------- Aufruf der Simulation
frausch = 1000;
delay = 2;  % Verspätung des Eingangssignals 

t = [0:1e-4:0.1];
nd = length(t) - fix(length(t)/8);

figure(4);    clf;
for k = 1:4,
    sim('iir2',t);
    subplot(2,2,k), plot(tout(nd:end), yout(nd:end,:));
    La = axis;   axis([tout(nd), La(2:4)]);
    title(my_text{k});
    grid;
end;  
% Angaben der Parameter in der Darstellung
h = axes('position', [0.1, 0.015, 0.8, 0.05]);
set(h,'Visible','off');
m_text = ['fs = ', num2str(fs),'Hz;  frausch = ',...
  num2str(frausch),'Hz;   ku = ', num2str(fs/(2*frausch))];
text(0.05, 0.5, m_text);
    
% -------- Aufruf der Simulation
frausch = 500;
delay = 2;  % Verspätung des Eingangssignals 

t = [0:1e-4:0.1];
nd = length(t) - fix(length(t)/8);

figure(5);    clf;
for k = 1:4,
    sim('iir2',t);
    subplot(2,2,k), plot(tout(nd:end), yout(nd:end,:));
    La = axis;   axis([tout(nd), La(2:4)]);
    title(my_text{k});
    grid;
end;    
% Angaben der Parameter in der Darstellung
h = axes('position', [0.1, 0.015, 0.8, 0.05]);
set(h,'Visible','off');
m_text = ['fs = ', num2str(fs),'Hz;  frausch = ',...
  num2str(frausch),'Hz;   ku = ', num2str(fs/(2*frausch))];
text(0.05, 0.5, m_text);

% -------- Untersuchung der Antwort auf 
% sinusförmige Signale
kr = 0;
k1 = 1;  k2 = 1;  k3 = 1;  k4 = 0;  k5 = 0;

% -------- Aufruf der Simulation
f1 = 200;  f2 = 600;   f3 = 1000;
delay = 2;  % Verspätung des Eingangssignals 

t = [0:1e-4:0.1];
nd = length(t) - fix(length(t)/8);

figure(6);    clf;
for k = 1:4,
    sim('iir2',t);
    subplot(2,2,k), plot(tout(nd:end), yout(nd:end,:));
    La = axis;   axis([tout(nd), La(2:4)]);
    title(my_text{k});
    grid;
end;    
% Angaben der Parameter in der Darstellung
h = axes('position', [0.1, 0.015, 0.8, 0.05]);
set(h,'Visible','off');
m_text = ['fs = ', num2str(fs),'Hz;  f1 = ',num2str(f1),...
        'Hz;  f1 = ',num2str(f2),'Hz;  f3 = ',...
        num2str(f3),'Hz;  ku = ',num2str(fs/(2*f3))];
text(0.05, 0.5, m_text);
    
% -------- Aufruf der Simulation
f1 = 100;  f2 = 300;   f3 = 500;
delay = 2;  % Verspätung des Eingangssignals 

t = [0:1e-4:0.1];
nd = length(t) - fix(length(t)/8);

figure(7);    clf;
for k = 1:4,
    sim('iir2',t);
    subplot(2,2,k), plot(tout(nd:end), yout(nd:end,:));
    La = axis;   axis([tout(nd), La(2:4)]);
    title(my_text{k});
    grid;
end; 
% Angaben der Parameter in der Darstellung
h = axes('position', [0.1, 0.015, 0.8, 0.05]);
set(h,'Visible','off');
m_text = ['fs = ', num2str(fs),'Hz;  f1 = ',num2str(f1),...
        'Hz;  f1 = ',num2str(f2),'Hz;  f3 = ',...
        num2str(f3),'Hz;  ku = ',num2str(fs/(2*f3))];
text(0.05, 0.5, m_text);

