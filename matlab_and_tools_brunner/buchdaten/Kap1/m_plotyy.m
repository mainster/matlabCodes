% Experiment (m_plotyy.m) zum Befehl plotyy
%
%------- Digitales Filter
Nh = 64;
h = fir1(Nh, 0.5);

%------- Frequenzgang
N = max(length(h), 512);
H = fft(h, N);

%------- Darstellung mit plotyy
figure(1);
plotyy((0:N-1)/N, 20*log(abs(H)),(0:N-1)/N, unwrap(angle(H)));
title('Betrag und Phase eines FIR-Tiefpassfilters');
xlabel('f/fs');     grid;
ylabel('Betrag in dB / Phase in rad');       

