function [b,a]=analog_bp11(f1,f2,nord,Typ)
% Funktion analog_bp11.m zur Berechnung der Koeffizienten
% eines Bandpassfilters
% f1, f2 = Grenzen des Durchlassbereichs
% nord = Ordnung des Filters
% Typ = 1, Bessel, 2 = Butterworth; 3 = Tschebyschev I, 4 = Elliptisch

w1 = 2*pi*f1;        w2 = 2*pi*f2;
w0 = sqrt(w1*w2);    Bw = w2-w1;
% --------- Tiefpass-Prototypfilter + Bandpassfilter
if Typ == 1
% ------- Entwicklung eines TP- und BP-Bessel-Filters
[z,p,k] = besselap(nord);
[b,a] = zp2tf(z,p,k);     % TP_Prototyp
[b,a] = lp2bp(b,a,w0,Bw); % BP-Bessel-Filter
elseif Typ == 2
% ------- Entwicklung eines TP- und BP-Butterworth-Filters
[z,p,k] = buttap(nord);
[b,a] = zp2tf(z,p,k);  % TP-Prototyp
[b,a] = lp2bp(b,a,w0,Bw); % BP-Butterworth-Filter
elseif Typ == 3
% ------- Entwicklung eines TP- und BP-Tschebyschev-Filters Typ I (mit 
% Welligkeit im Durchlaﬂbereich)
Rp = 0.1;                     % Welligkeiten in Durchlassbereich
[z,p,k] = cheb1ap(nord, Rp);
[b,a] = zp2tf(z,p,k);     % TP-Prototyp
[b,a] = lp2bp(b,a,w0,Bw); % BP-Cheb1-Filter
else
% ------- Entwicklung eines TP- und BP-Elliptischen-Filters
Rp = 0.1;                    % Welligkeiten in Durchlassbereich
Rs = 60;                     % Dämpfung in Sperrbereich
[z,p,k] = ellipap(nord, Rp, Rs);
[b,a] = zp2tf(z,p,k);     % TP-Prototyp
[b,a] = lp2bp(b,a,w0,Bw); % BP-Ellip-Filter
end;
% ------- Frequenzg‰änge der Filter
% Frequenzbereich
alpha_min = (log10(f1*0.9));   alpha_max = (log10(f2*1.1));
fmin = 10^alpha_min;            fmax = 10^alpha_max;
f = logspace(alpha_min, alpha_max, 1000);
w = 2*pi*f;

% Frequenzgang
Hbp = freqs(b, a, w);

text_{1} = 'Bessel';            
text_{2} = 'Butterworth';
text_{3} = 'Tschebyschev I';
text_{4} = 'Ellip';

figure(1);      clf;
% --------- Amplitudengang
subplot(211), semilogx(f, 20*log10(abs(Hbp)),'r');
axis([fmin, fmax, -100, 10]);
title(['Amplitudengang (', text_{Typ},' ; Ord. = ',num2str(nord),...
        '; f1 = ',num2str(f1),' Hz; f2 = ',num2str(f2),' Hz)']);
xlabel('Hz');       grid;
text(f1*1.005, -70, 'f1'); 
text(f2*1.005, -70, 'f2'); 

hold on
plot([f1, f1], [-100, 10],'--');
plot([f2, f2], [-100, 10],'--');
hold off
% --------- Phasengang & Gruppenlaufzeit
Gr = -diff(unwrap(angle(Hbp.')))./diff(w');

subplot(212);
[haxis, hline1, hline2] = plotyy(f, unwrap(angle(Hbp))*180/pi, ...
    f(1:end-1), Gr, @semilogx);
title('Phasengang / Gruppenlaufzeit');
xlabel('Hz');         %grid;
La = axis; axis([fmin, fmax, La(3:4)]);

axes(haxis(1));
ylabel('Grad');       %grid;

axes(haxis(2));
ylabel('Sekunden');          grid;
axis([fmin, fmax, 0, max(Gr)]);
hold on
plot([f1, f1], [0, max(Gr)],'--');
plot([f2, f2], [0, max(Gr)],'--');
hold off

