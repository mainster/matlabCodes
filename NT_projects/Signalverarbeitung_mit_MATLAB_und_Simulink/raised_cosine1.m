% Programm raised_cosine1.m zur Untersuchung 
% der Raised-Cosine-Einheitspulsantwort

% --------- Spezifikationen
Ts = 1e-3;  fs = 1/Ts;
ku = 10;

Tsymb = ku*Ts;      fsymb = 1/Tsymb;
m = 4;
nord = 2*m*ku;

fc = 0.5*fsymb;     % In der Kommunikationstechnik 

% --------- Raised-Cosine-Antwort
alpha = zeros(3,1); % Roll-Off-Faktor
hrc = zeros(3, nord+1);  

for p = 1:3,
    alpha(p) = (p-1)/2;
    hrc(p,:) = firrcos(nord,fc,alpha(p),fs, 'rolloff');
end;

% ---------- Frequenzgang
nf = 1024;
Hrc = zeros(nf,3);
for p = 1:3,
    [Hrc(:,p),w] = freqz(hrc(p,:),1,nf,'whole'); 
end;

nd = fix(nf/5);
figure(1),    clf;
subplot(211), plot(0:nord, hrc);
xlabel('k');    grid;
title('Raised-Cosine-Antwort \alpha = 0, 0.5, 1');
legend('\alpha = 0', '\alpha = 0.5', '\alpha = 1');

subplot(223), plot(w(1:nd)*fs/(fsymb*2*pi), (abs(Hrc(1:nd,:))));
xlabel('f*Tsymb');   grid;
La = axis;   axis([La(1:3), 1.2]);
legend('\alpha = 0', '\alpha = 0.5', '\alpha = 1');
title('Amplitudengang (linear)');

subplot(224), plot(w(1:nd)*fs/(fsymb*2*pi), 20*log10((abs(Hrc(1:nd,:)))));
xlabel('f*Tsymb');   grid;
La = axis;   axis([La(1:2), -80, 10]);
legend('\alpha = 0', '\alpha = 0.5', '\alpha = 1');
title('Amplitudengang (dB)');

