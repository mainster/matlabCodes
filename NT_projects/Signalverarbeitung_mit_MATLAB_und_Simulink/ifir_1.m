% Programm ifir_1.m zur Erkl‰ärung des Prinzips
% der Interpolated-FIR-Filter

% -------- Gew¸ünschte Parameter des Gesamtfilters
fp = 0.05;   % Relative Durchlassfrequenz
fs = 0.065;  % Sperrbereich

% -------- Das zu expandierende Filter
L = 5;
nord_exp = 50;
h=firpm(nord_exp,[0,fp*L,fs*L,0.5]*2,[1,1,0,0],[1,10]);

% Frequenzgang
nfft = 1024;
[H,w]=freqz(h,1,nfft,'whole');

% -------- Das expandierte Filter
hexp=zeros(1,length(h)*L);
hexp(1:L:end)=h;
% Frequenzgang
[Hexp,w]=freqz(hexp,1,nfft,'whole');

figure(1);    clf;
subplot(311), plot(w/(2*pi), abs(H));
title('Das zu expandierende Filter');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:3),1.2]);

subplot(312), plot(w/(2*pi), abs(Hexp));

% -------- Image-Suppressor-Filter
nord_image = 60;
himage = firpm(60, [0,fp,2.7*fp,0.5]*2, [1,1,0,0],[10,1]); % oder
%himage = firpm(60, [0,fp, 2.7*fp, 5.2*fp, 6.6*fp, 0.5]*2, [1,1,0,0,0,0],[10,1,1]);

% Frequenzgang
[Himage,w]=freqz(himage,1,nfft,'whole');

hold on
plot(w/(2*pi), abs(Himage));
hold off
title('Expandiertes und Image-Suppressing-Filter');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:3),1.2]);

% -------- Gesamtfilter hexp*himage
Hg = Hexp.*Himage;

subplot(313), plot(w/(2*pi), abs(Hg));
title('Amplitudengang des Gesamtfilters');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:3),1.2]);

% --------- Frequenzgänge in logarithmischen Koordinaten
figure(2);    clf;
subplot(311), plot(w/(2*pi), 20*log10(abs(H)));
title('Das zu expandierende Filter');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:2),-100,10]);

subplot(312), plot(w/(2*pi), 20*log10(abs(Hexp)));
hold on
plot(w/(2*pi), 20*log10(abs(Himage)));
hold off
title('Expandiertes und Image-Suppressing-Filter');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:2),-100,10]);

% -------- Gesamtfilter hexp*himage
Hg = Hexp.*Himage;

subplot(313), plot(w/(2*pi), 20*log10(abs(Hg)));
title('Amplitudengang des Gesamtfilters');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:2),-100,10]);

% ------- Konventioneller Entwurf
nord = 240;
hkonv = firpm(nord, [0,fp,fs,0.5]*2,[1,1,0,0],[1,10]);

% Frequenzgang
[Hkonv,w]=freqz(hkonv,1,nfft,'whole');

figure(3);    clf;

subplot(221),
plot(w/(2*pi),20*log10(abs(Hg)), w/(2*pi),20*log10(abs(Hkonv))); 
title('IFIR und Konventionelles FIR-Filter (Ausschnitt)');
xlabel('f/fs');     grid;
La = axis;    axis([0,0.15, -100,10]);

subplot(222),
plot(w/(2*pi),20*log10(abs(Hg)), w/(2*pi),20*log10(abs(Hkonv))); 
title('IFIR und Konventionelles FIR-Filter (Ausschnitt)');
xlabel('f/fs');     grid;
La = axis;    axis([0,0.1,-0.15,0.1]);


