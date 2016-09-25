% Programm ident_verg1.m zum Vergleichen verschiedener 
% Verfahren zur Identifikation von Systemen

% -------- Erzeugung simulierter Daten
% System
A = conv([1, -0.6+j*0.3],[1, -0.6-j*0.3])
B = [0, 1, 0.5]
C = [1, -1, 0.2]

sysid1 = idpoly(A, B, C)

% Eingangsdaten
N = 2000;
u = idinput(N, 'rbs');    % Zufällige binäre Sequenz
u = iddata([], u);

% Störeingang
noise = 0.1;
e = iddata([], sqrt(noise)*randn(N,1));  % Normal verteilte unabhängige Sequenz

% Antwort des Systems
y = sim(sysid1, [u,e]); 

% Daten für die Identifikation
z = [y,u];

% --------- Darstellung der Daten (die erten 100 Werte) 
n = 1:100;
figure(1);       clf;
plot(z(n))

% --------- Identifikation des Frequenzgangs und des Spektrums
w = logspace(-2,pi,256); 
[sysfrd, stoer] = spa(z, 256, w);
get(sysfrd)
get(stoer)

betrag = abs(squeeze(sysfrd.responsedata));
phase  = unwrap(angle(squeeze(sysfrd.responsedata)));

spektrum = squeeze(stoer.spectrumdata);

figure(2);       clf;
subplot(221), loglog(w, betrag);
La1 = axis;    axis([La1(1), 1.2*pi, La1(3:4)]);
title('Betrag Frequenzgang');

subplot(223), semilogx(w, phase*180/pi);
La2 = axis;    axis([La2(1), 1.2*pi, La2(3:4)]);
title('Phase Frequenzgang');

subplot(122), loglog(w, spektrum);
La3 = axis;    axis([La3(1), 1.2*pi, La3(3:4)]);
title('Spektrum Stoerung');

% --------- Frequenzgang mit Vertrauensgrenzen
figure(3);       clf;
bode(sysfrd,'sd',3,'fill');  % Vertraunsbereich bei Varianz 3

% --------- Default Modell aus den Daten
sysid2 = pem(z),             % Das ist immer als erster Versuch
                             % zu emfehlen
% Vergleich
ze = z(1:fix(N/2));
zv = z(fix(N/2)+1:N);

figure(4);       clf;
compare(zv, sysid2);   

% --------- Testen mehrerer ARX-Strukturen 
V = arxstruc(ze, zv, struc(1:2, 1:2, 1:5));
nn = selstruc(V,0)

% --------- Optimales ARX-Modell
sysid3 = arx(ze, nn)

% --------- ARX-Modell mit IV4 (Instrumental-Variation-Verfahren)
sysid4 = iv4(ze, nn);
figure(5);       clf;
compare(zv, sysid3, sysid4);

figure(6);       clf;
bode(sysid1, sysid2, sysid3, sysid4);

% --------- ARMAX-Modell
sysid5 = armax(ze, [2, nn])
figure(7);       clf;
compare(zv, sysid5);

% -------- Box-Jenkins-Modell
sysid6 = bj(ze, [2,2,nn])
figure(8);       clf;
compare(zv, sysid6);

% -------- Fehler für ARMAX- und BJ-Modell
figure(9);       clf;
resid(zv, sysid5);
figure(10);      clf;
resid(zv, sysid6);

% -------- Akaike-Funktionen
disp(['sysid2 = pem(); aic =   ', num2str(aic(sysid2))]);
disp(['sysid3 = arx(); aic =   ', num2str(aic(sysid3))]);
disp(['sysid4 = iv4(); aic =   ', num2str(aic(sysid4))]);
disp(['sysid5 = armax(); aic = ', num2str(aic(sysid5))]);
disp(['sysid6 = bj(); aic =    ', num2str(aic(sysid6))]);


