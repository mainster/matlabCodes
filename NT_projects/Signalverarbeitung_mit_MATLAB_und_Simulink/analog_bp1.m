% Programm analog_bp1.m zur Untersuchung von
% Bandpassfiltern
% Mittenfrequenz gegeben durch geometrischer Mittelwert
clear
% --------- Spezifizierung
f1 = 30000;    w1 = 2*pi*f1; 
f2 = 30500;    w2 = 2*pi*f2;

w0 = sqrt(w1*w2);    Bw = w2-w1;
nord = 6;     % Ordnung des Filters
% --------- Tiefpass-Prototypfilter + Bandpassfilter
% --------- Wahl des Filtertyps
Typ = 2;        % 1 = Bessel; 2 = Butterworth;
% 3 = Tsche4byschev I; 4 = Ellip

% ------- Felder der Koeffizienten
btp = zeros(4, nord+1);   % TP-Koeffizienten
atp = zeros(4, nord+1);

bbp = zeros(4, 2*nord+1); % BP-Koeffizienten
abp = zeros(4, 2*nord+1);
% ------- Entwicklung eines TP- und BP-Bessel-Filters
[z,p,k] = besselap(nord);
[btp(1,:),atp(1,:)] = zp2tf(z,p,k);  % TP_Prototyp
[bbp(1,nord+1:end),abp(1,:)] = lp2bp(btp(1,:),atp(1,:),w0,Bw); % BP-Bessel-Filter
% ------- Entwicklung eines TP- und BP-Butterworth-Filters
[z,p,k] = buttap(nord);
[btp(2,:),atp(2,:)] = zp2tf(z,p,k);  % TP-Prototyp
[bbp(2,nord+1:end),abp(2,:)] = lp2bp(btp(2,:),atp(2,:),w0,Bw); % BP-Butterworth-Filter
% ------- Entwicklung eines TP- und BP-Tschebyschev-Filters Typ I (mit 
% Welligkeit im Durchlaﬂbereich)
Rp = 0.1;                     % Welligkeiten in Durchlassbereich
[z,p,k] = cheb1ap(nord, Rp);
[btp(3,:),atp(3,:)] = zp2tf(z,p,k); % TP-Prototyp
[bbp(3,nord+1:end),abp(3,:)] = lp2bp(btp(3,:),atp(3,:),w0,Bw); % BP-Cheb1-Filter
% ------- Entwicklung eines TP- und BP-Elliptischen-Filters
Rp = 0.1;                    % Welligkeiten in Durchlassbereich
Rs = 60;                     % Dämpfung in Sperrbereich
[z,p,k] = ellipap(nord, Rp, Rs);
[btp(4,:),atp(4,:)] = zp2tf(z,p,k); % TP-Prototyp
[bbp(4,:),abp(4,:)] = lp2bp(btp(4,:),atp(4,:),w0,Bw); % BP-Ellip-Filter

% ------- Frequenzg‰änge der Filter
% Frequenzbereich
alpha_min = (log10(f1*0.95));
alpha_max = (log10(f2*1.05));

f = logspace(alpha_min, alpha_max, 1000);
w = 2*pi*f;

% Frequenzgang
Hbp = zeros(4,length(w));
for k = 1:4
    Hbp(k,:) = freqs(bbp(k,:), abp(k,:), w);
end;

text_{1} = 'Bessel';            
text_{2} = 'Butterworth';
text_{3} = 'Tschebyschev I';
text_{4} = 'Ellip';

figure(1);      clf;
% --------- Amplitudengang
subplot(211), semilogx(f, 20*log10(abs(Hbp(Typ,:)')),'r');
La = axis;      axis([La(1:2), -100, 10]);
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
Gr = -diff(unwrap(angle(Hbp(Typ,:).')))./diff(w');

subplot(212);
[haxis, hline1, hline2] = plotyy(f, unwrap(angle(Hbp(Typ,:).'))*180/pi, ...
    f(1:end-1), Gr, @semilogx);
title('Phasengang / Gruppenlaufzeit');
xlabel('Hz');       %grid;

axes(haxis(1));
ylabel('Grad');     %grid;

axes(haxis(2));
ylabel('Sekunden');          grid;
La = axis;      axis([La(1:2), 0, max(Gr)]);
hold on
plot([f1, f1], [0, max(Gr)],'--');
plot([f2, f2], [0, max(Gr)],'--');
hold off

