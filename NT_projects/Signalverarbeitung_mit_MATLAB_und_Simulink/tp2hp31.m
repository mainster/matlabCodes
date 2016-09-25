function [b, a] = tp2hp31(f_3dB)
% Function tp2hp31.m zur Berechnung von Hochpassfiltern
% mit der Durchlassfrequenz f_3dB in Hz 
% b bzw. a sind die Koeffizienten der Filter
% Testaufruf [bx,ax] = tp2hp31(100);

% ------- Spezifikationen
nord = 8;
w_3dB = 2*pi*f_3dB;
% ------- Matrix der Koeffizienten
b = zeros(5, nord+1);
a = zeros(5, nord+1);
% ------- Entwicklung eines Bessel-Filters
[b(1,:),a(1,:)] = besself(nord, w_3dB,'high');
% ------- Entwicklung eines Butterworth-Filters
[b(2,:),a(2,:)] = butter(nord, w_3dB,'high','s');
% ------- Entwicklung eines Tschebyschev-Filters Typ I (mit 
% Welligkeit im Durchlassbereich)
Rp = 0.1;                     % Welligkeiten in Durchlassbereich
[b(3,:),a(3,:)] = cheby1(nord, Rp, w_3dB,'high','s');
% ------- Entwicklung eines Elliptischen-Filters
Rp = 0.1;                    % Welligkeiten in Durchlassbereich
Rs = 60;                     % D‰ämpfung in Sperrbereich
[b(4,:),a(4,:)] = ellip(nord, Rp, Rs, w_3dB,'high','s');
% ------- Entwicklung eines Tschebyschev-Filters Typ II (mit 
% Welligkeit im Sperrbereich)
Rs = 60;                     % Dämpfung in Sperrbereich
[b(5,:),a(5,:)] = cheby2(nord, Rs, w_3dB,'high','s');
% ------- Frequenzg‰änge und Gruppenlaufzeiten der Filter
% Frequenzbereich
alpha_min = floor(log10(f_3dB/10));
alpha_max = ceil(log10(f_3dB*10));
f = logspace(alpha_min, alpha_max, 1000);
w = 2*pi*f;
% Frequenzgang
H = zeros(5,length(w));
for k = 1:5
    H(k,:) = freqs(b(k,:), a(k,:), w);
end;
figure(1);      clf;
subplot(211), semilogx(f, 20*log10(abs(H)'));
La = axis;      axis([La(1:2), -100, 10]);
title('Amplitudeng‰änge');
xlabel('Hz');       grid;

subplot(212), semilogx(f, angle(H.')*180/pi);
title('Phaseng‰änge');
xlabel('Hz');       grid;
% Gruppenlaufzeit
%Gr = diff(unwrap(angle(H.')))./[diff(w'),diff(w'),...
%diff(w'),diff(w'),diff(w')];
Gr = -diff(unwrap(angle(H.')))./[diff(w')*ones(1,5)];

figure(2);      clf;
subplot(211), semilogx(f, 20*log10(abs(H)'));
La = axis;      axis([La(1:2), -100, 10]);
title('Amplitudeng‰änge');
xlabel('Hz');       grid;
%legend('Bessel','Butterworth','Tschebyschev I',...
%    'Tschebyschev II','Ellip');
subplot(212), semilogx(f(1:end-1), Gr);
La = axis;      axis([La(1:2), 0, max(max(Gr))]);
title('Gruppenlaufzeiten');
xlabel('Hz');       grid;
