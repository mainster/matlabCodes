function [] = abtast1(f0, null_phase, fs, k)
% Funktion zur Untersuchung der Komponenten, die 
% durch Abtastung gleiche Abtastwerte ergeben
%
% f0; null_phase = Frequenz und Nullphase der Grundwelle
% fs = Abtastfrequenz
% k = Vektor der Werte aus f = f0 + k*fs
%
% Testaufruf: abtast1(4, pi/3, 6, [-1, 0, 1]);
%
%------ Initialisierungen für die Darstellung
fmax = max([f0, fs, abs(f0 + k*fs)]);
fmin = min([f0, fs, abs(f0 + k*fs)]);

Tmin = 1/fmax;
d_t = Tmin/20;           % Schrittweite der Simulation
Tmax = 1/fmin;

%------ Grundwelle
Ts = 1/fs;
T0 = 1/f0;

t = 0:d_t:Tmax;          % Kontinuierliche Zeit
tn = 0:Ts:Tmax;          % diskrete Zeit

x = cos(2*pi*t/T0+null_phase);      % Kontinuierliche Grundwelle
xn = cos(2*pi*tn/T0+null_phase);    % Diskrete Komponente
y = zeros(length(t), length(k));    % Initialisierung der Matrix 
                         % die die kontinuierlichen Komponenten 
                         % mit gleichen diskreten Werte enthält

%------ Kontinuierlichen Komponenten
for p = 1:length(k)
   f(p) = f0 + k(p)*fs;
   y(:,p) = cos(2*pi*t'*f(p)+null_phase);
end;

figure(1);      clf;
plot(t, y);             % Kontinuierliche Komponenten
hold on;
set(gcf, 'DefaultLineLineWidth', 2);
stem(tn, xn);           % Diskrete Abtastwerte
grid;
hold off;

ktext = '';
for p = 1:length(k)
   ktext = [ktext, num2str(k(p)),';'];
end;

title(['f0 = ',num2str(f0),';  ',...
      'fs = ',num2str(fs),';  ',...
      'k = ', ktext,'  Nullphase = ',num2str(null_phase), ' rad']);
xlabel('Zeit in s');
set(gcf, 'DefaultLineLineWidth', 1);

 

