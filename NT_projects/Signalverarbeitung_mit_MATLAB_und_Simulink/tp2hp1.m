% Programm tp2hp1.m zur Untersuchung eines Tiefpassfilters
% und des entsprechenden Hochpassfilters
% Arbeitet mit dem Modell tp2hp_1.mdl

clear
% ------- Spezifikationen füŸr die Filter
nord = 5;
f_3dB = 1000;   % Durchlassfrequenz 

w_3dB = 2*pi*f_3dB;

% -------- Wahl des Filtertyps
Typ = 1;        % 1 = Bessel; 2 = Butterworth;
% 3 = Tschebyschev I; 4 = Ellip

% ------- Matrix der Koeffizienten
b = zeros(4, nord+1, 2);
a = zeros(4, nord+1, 2);

% ------- Entwicklung eines Bessel-Filters
[b(1,:,1),a(1,:,1)] = besself(nord, w_3dB);
[b(1,:,2),a(1,:,2)] = besself(nord, w_3dB, 'high');

% ------- Entwicklung eines Butterworth-Filters
[b(2,:,1),a(2,:,1)] = butter(nord, w_3dB, 's');
[b(2,:,2),a(2,:,2)] = butter(nord, w_3dB, 'high', 's');

% ------- Entwicklung eines Tschebyschev-Filters Typ I (mit 
% Welligkeit im Durchlaßbereich)
Rp = 0.1;                     % Welligkeiten in Durchlassbereich
[b(3,:,1),a(3,:,1)] = cheby1(nord, Rp, w_3dB, 's');
[b(3,:,2),a(3,:,2)] = cheby1(nord, Rp, w_3dB, 'high', 's');

% ------- Entwicklung eines Elliptischen-Filters
Rp = 0.1;                    % Welligkeiten in Durchlassbereich
Rs = 60;                     % DŠmpfung in Sperrbereich
[b(4,:,1),a(4,:,1)] = ellip(nord, Rp, Rs, w_3dB, 's');
[b(4,:,2),a(4,:,2)] = ellip(nord, Rp, Rs, w_3dB, 'high','s');

% ------- FrequenzgäŠnge der Filter
% Frequenzbereich
alpha_min = floor(log10(f_3dB/10));
alpha_max = ceil(log10(f_3dB*10));

f = logspace(alpha_min, alpha_max, 1000);
w = 2*pi*f;

% Frequenzgang
H = zeros(4,length(w),2);
for k = 1:4
    H(k,:,1) = freqs(b(k,:,1), a(k,:,1), w);
    H(k,:,2) = freqs(b(k,:,2), a(k,:,2), w);
end;

text_{1} = 'Bessel';            
text_{2} = 'Butterworth';
text_{3} = 'Tschebyschev I';
text_{4} = 'Ellip';

figure(1);      clf;
subplot(211), semilogx(f, 20*log10(abs(H(Typ,:,1)')));
hold on;
semilogx(f, 20*log10(abs(H(Typ,:,2)')));

La = axis;      axis([La(1:2), -100, 10]);
title(['Amplitudengänge (', text_{Typ},' ; Ord. = ',num2str(nord),')']);
xlabel('Hz');       grid;
hold off;

subplot(212), semilogx(f, unwrap(angle(H(Typ,:,1).')*180/pi));
hold on;

semilogx(f, (- angle(H(Typ,end,2).')*180/pi + angle(H(Typ,:,2).')*180/pi));
title('Phasengänge');
xlabel('Hz');       grid;
hold off

% ------- Sprungantworten (üŸber das Modell tp2hp_1.mdl)
dt = 1e-5;
tfinal = 2.5e-3;

sim('tp2hp_1',[0:dt:tfinal]);

figure(2);      clf;
plot(tout, yout);
title(['Sprungantworten (', text_{Typ},' ; Ord. = ',num2str(nord),')'])
xlabel('Zeit in s');    grid;

