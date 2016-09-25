% Programm analog_tp2.m zur Entwicklung von analogen
% TP-Filtern f¸ür deren Untersuchung mit dem Simulink-Modell 
% analog_tp_2.mdl

clear
% ------- Spezifikationen f¸ür die Filter
nord = 8;
f_3dB = 1000;   % Durchlaﬂfrequenz der Tiefp‰sse

% Hier ist das Tschebyschev-Filter Typ II so eingestellt,
% dass der Durchlaﬂbereich auch bei ca 1000 Hz liegt
w_3dB = 2*pi*f_3dB;

% ------- Spezifikationen der Generatoren
frausch = 500;  % Bandbreite des Rauschsignals
f1 = 100;       % Frequenz Sinus_1
f2 = 300;       % Frequenz Sinus_2
f3 = 500;       % Frequenz Sinus_2
frechteck = 20; % Frequenz Rechteckgenerator

Krausch = 1;    % Verst‰rker Rauschgenerator
K1 = 0;         % Verst‰rker Sinus_1
K2 = 0;         % Verst‰rker Sinus_2
K3 = 0;         % Verst‰rker Sinus_3
Krechteck = 0;  % Verst‰rker Rechteckgenerator
Kdreieck = 0;   % Verst‰rker Dreieckgenerator

% -------- Wahl des Filtertyps
Typ = 2;        % 1 = Bessel; 2 = Butterworth;
% 3 = Tschebyschev I; 4 = Tschebyschev II; 5 = Ellip

% ------- Matrix der Koeffizienten
b = zeros(5, nord+1);
a = zeros(5, nord+1);

% ------- Entwicklung eines Bessel-Filters
[b(1,:),a(1,:)] = besself(nord, w_3dB);

% ------- Entwicklung eines Butterworth-Filters
[b(2,:),a(2,:)] = butter(nord, w_3dB, 's');

% ------- Entwicklung eines Tschebyschev-Filters Typ I (mit 
% Welligkeit im Durchlaﬂbereich)
Rp = 0.1;                     % Welligkeiten in Durchlassbereich
[b(3,:),a(3,:)] = cheby1(nord, Rp, w_3dB, 's');

% ------- Entwicklung eines Tschebyschev-Filters Typ II (mit 
% Welligkeit im Sperrbereich)
Rs = 60;                     % D‰mpfung in Sperrbereich
[b(4,:),a(4,:)] = cheby2(nord, Rs, 1.5*w_3dB, 's');

% ------- Entwicklung eines Elliptischen-Filters
Rp = 0.1;                    % Welligkeiten in Durchlassbereich
Rs = 60;                     % Dämpfung in Sperrbereich
[b(5,:),a(5,:)] = ellip(nord, Rp, Rs, w_3dB, 's');

% ------- Frequenzgänge und Gruppenlaufzeiten der Filter
% Frequenzbereich
fmin = floor(f_3dB/10);
fmax = ceil(f_3dB*10);
f = logspace(log10(fmin), log10(fmax), 1000);
w = 2*pi*f;
% Frequenzgang
H = zeros(5,length(w));
for k = 1:5
    H(k,:) = freqs(b(k,:), a(k,:), w);
end;

figure(1);      clf;
subplot(211), semilogx(f, 20*log10(abs(H)'));
La = axis;      axis([La(1:2), -100, 10]);
title('Amplitudengaenge');
xlabel('Hz');       grid;

subplot(212), semilogx(f, angle(H.')*180/pi);
title('Phasengaenge');
xlabel('Hz');       grid;

% Gruppenlaufzeit
%Gr = diff(unwrap(angle(H.')))./[diff(w'),diff(w'),...
%diff(w'),diff(w'),diff(w')];
Gr = -diff(unwrap(angle(H.')))./[diff(w')*ones(1,5)];

figure(2);      clf;
subplot(211), semilogx(f, 20*log10(abs(H)'));
La = axis;      axis([La(1:2), -100, 10]);
title('Amplitudengaenge');
xlabel('Hz');       grid;
legend('Bessel','Butterworth','Tschebyschev I',...
    'Tschebyschev II','Ellip');
subplot(212), semilogx(f(1:end-1), Gr);
La = axis;      axis([La(1:2), 0, max(max(Gr))]);
title('Gruppenlaufzeiten');
xlabel('Hz');       grid;

% -------- Aufruf der Simulation
K = [Krausch, K1, K2, K3, Krechteck, Kdreieck];
ik = find(K ~= 0);

freq = [frausch, f1, f2, f3, frechteck];
fmin = min(freq(ik));
tfinal = 20/fmin;
dt = 1/(10*fmin);
delay = 1e-3; % Verzögerung (Gruppenlaufzeit im Durchlaßbereich)

sim('analog_tp_2', [0, tfinal]);

% -------- Darstellung des Ergebnises
if Typ == 1; text_ = 'Bessel'; end;
if Typ == 2; text_ = 'Butterworth'; end;
if Typ == 3; text_ = 'Tschebyschev I'; end;
if Typ == 4; text_ = 'Tschebyschev II'; end;
if Typ == 5; text_ = 'Ellip'; end;
   
figure(3);      clf;
plot(tout, yout);
La = axis;      axis([min(tout), max(tout), La(3:4)]);
title(['Eingangs- und Fiterausgangssinal (', text_, ' -Filter)']);
xlabel('Zeit in s');    grid;

