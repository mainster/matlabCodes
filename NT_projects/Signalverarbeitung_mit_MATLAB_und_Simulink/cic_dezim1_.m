% Programm cic_dezim1_.m zur Untersuchung einer 
% Dezimierung mit CIC-Filtern

clear
% ------- CIC-Filter
R = 8;                       % Decimation factor
M = 1;
N = 4;
Hm = mfilt.cicdecim(R,M,N);      % Use default Number 
       % of Stages & Differential Delay
disp(['Gain = ', num2str(Hm.gain)])
gain = (R*M)^N
[H,w]=freqz(Hm);

figure(1);     clf;
subplot(211), plot(w/(2*pi), 20*log10(abs(H)/Hm.gain));
title(['Amplitudengang; R = ',num2str(R),'; M = ',num2str(M),...
    ';N = ', num2str(N),' Gain = ',num2str(Hm.gain)]);
xlabel('f/fs'); grid;

subplot(212), plot(w/(2*pi), angle(H));
title(['Phasengang']);
xlabel('f/fs'); grid;

% ------- PFIR-Filter
nord = 128;
hpfir = fir1(nord, 0.1*2);

figure(2),     clf;
subplot(211),

plot(w*R/(2*pi), 20*log10(abs(H)/Hm.gain));
title(['Amplitudengang CIC und PCIC; R = ',num2str(R),'; M = ',num2str(M),...
    ';N = ', num2str(N),' Gain = ',num2str(Hm.gain)]);
xlabel('f/fs'); grid;

hold on
Hpfir = polyval(hpfir,exp(-j*pi*(0:length(w)-1)*R/length(w)));
plot(w*R/(2*pi), 20*log10(abs(Hpfir)));
hold off

subplot(212);
Hg = (H/Hm.gain).*Hpfir.';
plot((0:length(w)-1)*R/(2*length(w)), 20*log10(abs(Hg)));
grid;

%fvtool(Hm);
