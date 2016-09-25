% Programm tp2hp2.m zur Untersuchung eines Tiefpassfilters
% und des entsprechenden Hochpassfilters, das ¸über eine 
% Transformation erhalten wird, die die Einschwing-
% eigenschaften des Tiefpassfilter beibeh‰ält.
% Arbeitet mit dem Modell tp2hp_2.mdl

clear
% ------- Spezifikationen für die Filter
nord = 6;
f_3dB = 1000;   % Durchlaﬂfrequenz 

w_3dB = 2*pi*f_3dB;

% -------- Wahl des Filtertyps
Typ = 4;        % 1 = Bessel; 2 = Butterworth;
% 3 = Tsche4byschev I; 4 = Ellip

% ------- Felder der Koeffizienten
b = zeros(4, nord+1, 2);
a = zeros(4, nord+1, 2);

% ------- Entwicklung eines TP- und HP-Bessel-Filters
[b(1,:,1),a(1,:,1)] = besself(nord, w_3dB);
b(1,:,2) = [a(1,1:end-1,1),0];
a(1,:,2) = a(1,:,1);

% ------- Entwicklung eines TP- und HP-Butterworth-Filters
[b(2,:,1),a(2,:,1)] = butter(nord, w_3dB, 's');
b(2,:,2) = [a(2,1:end-1,1),0];
a(2,:,2) = a(2,:,1);

% ------- Entwicklung eines TP- und HP-Tschebyschev-Filters Typ I (mit 
% Welligkeit im Durchlassbereich)
Rp = 0.1;                     % Welligkeiten in Durchlassbereich
[b(3,:,1),a(3,:,1)] = cheby1(nord, Rp, w_3dB, 's');
b(3,:,2) = [a(3,1:end-1,1),0];
a(3,:,2) = a(3,:,1);

% ------- Entwicklung eines TP- und HP-Elliptischen-Filters
Rp = 0.1;                    % Welligkeiten in Durchlassbereich
Rs = 60;                     % Dämpfung in Sperrbereich
[b(4,:,1),a(4,:,1)] = ellip(nord, Rp, Rs, w_3dB, 's');
b(4,:,2) = a(4,:,1)-b(4,:,1);
a(4,:,2) = a(4,:,1);

% ------- Frequenzg‰änge der Filter
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
semilogx(f, 20*log10(abs(H(Typ,:,2)')),'r');

La = axis;      axis([La(1:2), -100, 10]);
title(['Amplitudeng‰nge (', text_{Typ},' ; Ord. = ',num2str(nord),')']);
xlabel('Hz');       grid;
hold off;

subplot(212), semilogx(f, unwrap(angle(H(Typ,:,1).'))*180/pi);
hold on;

semilogx(f, unwrap(angle(H(Typ,:,2).'))*180/pi,'r');
title('Phaseng‰nge');
xlabel('Hz');       grid;
hold off
% ------- Sprungantworten (über das Modell tp2hp_1.mdl)
dt = 1e-5;
tfinal = 2.5e-3;

sim('tp2hp_1',[0:dt:tfinal]);

figure(2);      clf;
plot(tout, yout);
title(['Sprungantworten (', text_{Typ},' ; Ord. = ',num2str(nord),')'])
xlabel('Zeit in s');    grid;

