% Programm ifir_dezim1.m zur Parametrierung des Modells
% ifir_dezim_1.mdl in dem eine Dezimierung mit 
% IFIR-Filter in der aequivalente Form simuliert wird

% -------- Gewünschte Parameter des Gesamtfilters
fp = 0.05;   % Relative Durchlassfrequenz
fs = 0.065;  % Sperrbereich

Ts = 1/10000;
hsig = fir1(128, 0.02*2);   % FIR-Filter für das Eingangssignal

% -------- Das zu expandierende Filter
L = 5;
nord_exp = 50;
h=firpm(nord_exp,[0,fp*L,fs*L,0.5]*2,[1,1,0,0],[1,10]);

% Frequenzgang
nfft = 1024;
[H,w]=freqz(h,1,nfft,'whole');

% -------- Image-Suppressor-Filter
nord_image = 60;
himage = firpm(60, [0,fp,2.7*fp,0.5]*2, [1,1,0,0],[10,1]);

% Frequenzgang
[Himage,w]=freqz(himage,1,nfft,'whole');

% -------- Das expandierte Filter
hexp=zeros(1,length(h)*L);
hexp(1:L:end)=h;
% Frequenzgang
[Hexp,w]=freqz(hexp,1,nfft,'whole');

%####################
figure(1);    clf;
subplot(211), plot(w/(2*pi), 20*log10(abs(H)));
title('Das zu expandierende Filter');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:2),-100,10]);

subplot(212), plot(w/(2*pi), 20*log10(abs(Hexp)));
hold on
plot(w/(2*pi), 20*log10(abs(Himage)));
hold off
title('Expandiertes und Image-Suppressing-Filter');
xlabel('f/fs');     grid;
La = axis;    axis([La(1:2),-100,10]);

% -------- Verspätung für die Darstellung
delay = fix((length(himage)-1)/2 + 5*(length(h)-1)/2);

% -------- Aufruf der Simulation
sim('ifir_dezim_1',[0,1]);




