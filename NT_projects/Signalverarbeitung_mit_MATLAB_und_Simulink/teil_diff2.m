% Programm teil_diff2.m zur Untersuchung eines
% FIR-Differenzierers
% Arbeitet mit dem Modell teil_diff_2.mdl

clear
% -------- Spezifikationen
f = [0, 0.5, 0.54, 1];
m = [0, 1, 0, 0];

% -------- Lösungen für das Filter
nord = 128;
W1 = [2, 1];
[h1,feh,erg]=firgr(nord,f,m,W1,{'e1','e2'},'d');

% -------- Frequenzgang
nf = 1024;
[H1,w] = freqz(h1,1, nf);

phi1 = unwrap(angle(H1))' + 2*pi*(0:nf-1)/(2*nf)*(nord/2);

%**************************************
figure(1),   clf;
[ax,z1,z2] = plotyy(w/pi, (abs(H1)),w/pi, phi1*180/pi);
axes(ax(1));
title(['Bewertung = ',num2str(W1)]);
xlabel('2f/fs');   grid;
ylabel('Betrag');
La = axis;    axis([La(1:2), 0, 1]);

axes(ax(2));
La = axis;    axis([La(1:2), 0, 100]);
ylabel('Grad'); 
set(ax(2), 'Ytick', [0:50:100]);

% --------- Initialisierung des Modells 
fs = 1000;
Ts = 1/fs;

frausch = 0.8*fs/4; % Bandbreite des Rauschsignals
fst = 0.7*fs/2; % Frequenz der Störung
K = (pi/2)*fs;  % Verstärkungsfaktor 
delay = (nord/2)*Ts;

% -------- Aufruf der Simulation
my_options = simset('OutputVariables', 'ty');
[t,x,y] = sim('teil_diff_2', [0,1],my_options);

% Darstellung der realen und der geschätzten
% Beschleunigung

figure(2);     clf;
subplot(211),
nd = fix(length(t)/5);
plot(t(nd:2*nd), y(nd:2*nd,:));
La = axis;   axis([min(t(nd:2*nd)), max(t(nd:2*nd)),...
        La(3:4)]);
title(['Reale und geschaetzte Beschleunigung (f_{rausch} = ',...
        num2str(frausch),' Hz; f_s = ',num2str(fs),' Hz)']);  
xlabel('Zeit in s');   grid;

subplot(212),
nd = fix(length(t)/20);
plot(t(3*nd:4*nd), y(3*nd:4*nd,2));
hold on;
stairs(t(3*nd:4*nd), y(3*nd:4*nd,1));
hold off;
La = axis;   axis([min(t(3*nd:4*nd)), max(t(3*nd:4*nd)),...
        La(3:4)]);
title('Ausschnitt');
xlabel('Zeit in s');   grid;

% -------- Frequenzgang in logarithmischen Koordinaten
figure(3),   clf;
plot(w/pi, 20*log10((abs(H1))));
title(['Amplitudengang logarithmisch; Bewertung = ',num2str(W1)]);
xlabel('2f/fs');   grid;
ylabel('dB');
%La = axis;    axis([La(1:2), 0, 1]);

