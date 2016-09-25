% Programm komb_1.m zum Entwerfen von FIR-Filtern
% durch Kombination von einfachen Filtern

clear;
%************************************************************
% -------- Bandpassfilter aus Tiefpassfilter
fr1 = 0.4;      fr2 = 0.6;
nord = 60;

h1 = fir1(nord, fr1);   h2 = fir1(nord, fr2);
hbp = h2 - h1;

% ------ Frequenzgang
nf = 1024;
[H1, w] = freqz(h1,1,nf,'whole');
[H2, w] = freqz(h2,1,nf,'whole');
[Hbp, w] = freqz(hbp,1,nf,'whole');

figure(1),   clf;
subplot(221), plot(w/pi,[20*log10(abs(H1)),20*log10(abs(H2))]);
La = axis;   axis([La(1:2), -100, 10]);
title('TP1 und TP2');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hbp))]); 
La = axis;   axis([La(1:2), -100, 10]);
title('BP = TP2 - TP1');
xlabel('2f/fs');     grid;

subplot(322), stem(0:nord, h1);
title('TP1');    grid;
subplot(324), stem(0:nord, h2);
title('TP2');    grid;
subplot(326), stem(0:nord, hbp);
title('BP=TP2-TP1');    grid;

%************************************************************
% --------  Bandpass durch Modulation der
% Einheitspulsantwort
fr = 0.2;   % Bandbreite 0.4
nord = 100;
htp = fir1(nord, fr);

fmitte = 0.6;
hbp = 2*htp.*cos(2*pi*(-nord/2:nord/2)*fmitte/2);

% Frequenzgang
nf = 1024;
[Htp, w] = freqz(htp,1,nf,'whole');
[Hbp, w] = freqz(hbp,1,nf,'whole');

figure(2),   clf;
subplot(221), plot(w/pi,[20*log10(abs(Htp))]); 
La = axis;   axis([La(1:2), -100, 10]);
title('TP');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hbp))]);
La = axis;   axis([La(1:2), -100, 10]);
title('BP aus TP durch Modulation');
xlabel('2f/fs');     grid;

subplot(222), stem(0:nord, htp);
title('TP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(224), stem(0:nord, hbp);
title('BP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

%************************************************************
% -------- Hochpassfilter aus Allpass und Tiefpassfilter
fr = 0.4;   % Bandbreite 0.4
nord = 100;  % muss eine ungerade Anzahl Koeffizienten sein
htp = fir1(nord, fr);
hhp = [zeros(1, nord/2),1,zeros(1, nord/2)]-htp; 

% Frequenzgang
nf = 1024;
[Htp, w] = freqz(htp,1,nf,'whole');
[Hhp, w] = freqz(hhp,1,nf,'whole');

figure(3),   clf;
subplot(221), plot(w/pi,[20*log10(abs(Htp))]); 
La = axis;   axis([La(1:2), -100, 10]);
title('TP');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hhp))]);
La = axis;   axis([La(1:2), -100, 10]);
title('HP=1-TP');
xlabel('2f/fs');     grid;

subplot(222), stem(0:nord, htp);
title('HP aus 1-TP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(224), stem(0:nord, hhp);
title('HP=1-TP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

%************************************************************
% -------- Sperrfilter aus Tief- und Hochpassfilter
frtp = 0.3;     frhp = 0.6;
nord = 100;  % muss eine gerade Ordnung sein 
      % (wegen des Hochpassfilters)
htp = fir1(nord, frtp); 
hhp = fir1(nord, frhp, 'high');

hbs = htp + hhp;

% ------ Frequenzgang
nf = 1024;
[Htp, w] = freqz(htp,1,nf,'whole');
[Hhp, w] = freqz(hhp,1,nf,'whole');
[Hbs, w] = freqz(hbs,1,nf,'whole');

figure(4),   clf;
subplot(221), plot(w/pi,[20*log10(abs(Htp)),20*log10(abs(Hhp))]);
La = axis;   axis([La(1:2), -100, 10]);
title('TP und HP');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hbs))]); 
La = axis;   axis([La(1:2), -100, 10]);
title('BS = TP + HP');
xlabel('2f/fs');     grid;

subplot(322), stem(0:nord, htp);
title('TP');    grid;
subplot(324), stem(0:nord, hhp);
title('HP');    grid;
subplot(326), stem(0:nord, hbs);
title('BS=TP+HP');    grid;

%************************************************************
% -------- Sperrfilter aus Bandpassfilter
fr1 = 0.3;     fr2 = 0.7;
nord = 100;  % muss eine gerade Ordnung sein

hbp = fir1(nord, [fr1, fr2]); 
hbs = [zeros(1, nord/2),1,zeros(1, nord/2)] - hbp; 

% Frequenzgang
nf = 1024;
[Hbp, w] = freqz(hbp,1,nf,'whole');
[Hbs, w] = freqz(hbs,1,nf,'whole');

figure(5),   clf;
subplot(221), plot(w/pi,[20*log10(abs(Hbp))]); 
La = axis;   axis([La(1:2), -100, 10]);
title('BP');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hbs))]);
La = axis;   axis([La(1:2), -100, 10]);
title('BS = 1 - BP');
xlabel('2f/fs');     grid;

subplot(222), stem(0:nord, hbp);
title('BP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(224), stem(0:nord, hbs);
title('BS=1-BP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

%************************************************************
% -------- Hochpassfilter durch Modulation 
% der Einheitspulsantwort eines Tiefpassfilters
frtp = 0.6;     
nord = 101;   

htp = fir1(nord, frtp); 
if rem(nord,2) == 0
    hhp = htp.*((-1).^(-(nord/2):(nord/2)));
else
    hhp = htp.*((-1).^(1:nord+1));
end;

% Frequenzgang
nf = 1024;
[Htp, w] = freqz(htp,1,nf,'whole');
[Hhp, w] = freqz(hhp,1,nf,'whole');

figure(6),   clf;
subplot(221), plot(w/pi,[20*log10(abs(Htp))]); 
La = axis;   axis([La(1:2), -100, 10]);
title('TP');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hhp))]);
La = axis;   axis([La(1:2), -100, 10]);
title('HP durch Modulation');
xlabel('2f/fs');     grid;

subplot(222), stem(0:nord, htp);
title('TP');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(224), stem(0:nord, hhp);
title('HP durch Modulation');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

%************************************************************
% -------- Sperrfilter durch Modulation eines Tiefpassfilter
frtp = 0.8;     
nord = 101;
fmitt = 0.5;

htp = fir1(nord, frtp);
h1 = htp.*exp(-j*2*pi*((-nord/2):(nord/2))*fmitt/2);
    % Komplexes Filter
h2 = htp.*exp(j*2*pi*((-nord/2):(nord/2))*fmitt/2);
    % Komplexes Filter
hbs = real(conv(h1, h2)); % Reales Filter
if rem(length(hbs),2)==0
    n = length(hbs)/4;
    hbs = hbs(n+1:3*n);
else n = (length(hbs)-1)/4    
    hbs = hbs(n+1:end-n);
end;

nf = 1024;
[H1, w] = freqz(h1,1,nf,'whole');
[H2, w] = freqz(h2,1,nf,'whole');
[Hbs, w] = freqz(hbs,1,nf,'whole');

% ------ Frequenzgang
nf = 1024;
[H1, w] = freqz(h1,1,nf,'whole');
[H2, w] = freqz(h2,1,nf,'whole');
[Hbs, w] = freqz(hbs,1,nf,'whole');

figure(7),   clf;
subplot(221), plot(w/pi,[20*log10(abs(H1)),20*log10(abs(H2))]);
La = axis;   axis([La(1:2), -80, 10]);
title('TPrechts und TPlinks');
xlabel('2f/fs');     grid;

subplot(223), plot(w/pi,[20*log10(abs(Hbs))]); 
La = axis;   axis([La(1:2), -80, 10]);
title('BS=TPrechts.TPlinks');
xlabel('2f/fs');     grid;

subplot(343), stem(0:nord, real(h1));
title('TP \rightarrow links (Realteil)');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(344), stem(0:nord, imag(h1));
title('TP \rightarrow links (Imag.-Teil)');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(347), stem(0:nord, real(h2));
title('TP \rightarrow rechts (Realteil)');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(348), stem(0:nord, imag(h2));
title('TP \rightarrow rechts (Imag.-Teil)');    grid;
La = axis;   axis([La(1), nord, La(3:4)]);

subplot(326), stem(0:length(hbs)-1, hbs);
title('BP=conv(TPrechts,TPlinks)');    grid;
La = axis;   axis([La(1), length(hbs)-1, La(3:4)]);











