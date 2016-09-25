% Programm raised_cosine3.m zur 
% Untersuchung einer †bertragung mit
% Raised-Cosine-Filter
% Arbeitet mit dem Modell raised_cosine_3.mdl

% --------- Spezifikationen
Ts = 1e-3;  fs = 1/Ts;
ku = 10;

Tsymb = ku*Ts;      fsymb = 1/Tsymb;
m = 4;
nord = 2*m*ku;

fc = 0.5*fsymb;     % In der Kommunikationstechnik 

% --------- Raised-Cosine-Antwort
alpha = 0.5; % Roll-Off-Faktor
hrc = firrcos(nord,fc,alpha,fs, 'rolloff');
% hrc = rcosfir(alpha, [-m,m], ku, 1);  % Funktion aus der 
% hrc = hrc/sum(hrc);        % Communication-Toolbox

% ---------- Frequenzgang
nf = 1024;
[Hrc,w] = freqz(hrc,1,nf,'whole'); 

nd = fix(nf/5);

figure(1),    clf;
subplot(211), plot(0:nord, hrc);
xlabel('k');    grid;
title(['Raised-Cosine-Antwort \alpha = ',num2str(alpha)]);

subplot(223), plot(w(1:nd)*fs/(fsymb*2*pi), (abs(Hrc(1:nd,:))));
xlabel('f*Tsymb');   grid;
La = axis;   axis([La(1:3), 1.2]);
title('Amplitudengang (linear)');

subplot(224), plot(w(1:nd)*fs/(fsymb*2*pi), 20*log10((abs(Hrc(1:nd,:)))));
xlabel('f*Tsymb');   grid;
La = axis;   axis([La(1:2), -80, 10]);
title('Amplitudengang (dB)');

% --------- Aufruf der Simulation
hrc_puls = deconv(hrc, ones(ku,1));
tfinal = 5;
sim('raised_cosine_3',[0, tfinal]);


figure(2),    clf;
nd = fix(length(yout)/10);
subplot(211), plot(tout(1:nd), yout(1:nd,:));
xlabel('Zeit in s');    grid;
title('Binaere und Raised-Cosine gefilterte Signale');

% -------- Augendiagramm
subplot(212),
nmax = fix(length(yout)/30);
for k = 1:nmax
    ytemp = yout((k-1)*ku*3+5:(k-1)*ku*3+34,1);
    plot(0:29, ytemp);
    hold on
end;
hold off;
La = axis;    axis([La(1), 29, La(3:4)]);
title('Augendiagramm');
grid;


