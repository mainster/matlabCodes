% Programm cic_dezim2.m in dem eine Dezimierung
% mit CIC- und ISOP-Filter (Interpolated-Second-Order-Polynomial) 
% untersucht wird

clear

% -------- Parameter des CIC-Filters
R = 10;     % Dezimierungsfaktor  
M = 1;      % Versp‰ätung im Kamm-Filter (Differetial-Delay)
N = 5;      % Anzahl der Stufen

% -------- CIC-Filter über die Funktion mfilt.cicdecim
Hm = mfilt.cicdecim(R,M,N);    % Hm ein Objekt
gain = Hm.gain;   % Verstärkung des Filters 
nfft = 2048;
[Hcic,w]=freqz(Hm,nfft,'whole');% Frequenzgang des Filters

figure(1);      clf;
subplot(211);
plot(w/(2*pi), 20*log10(abs(Hcic)/gain));
title(['Amplitudengang des CIC- und CFIR-Filters',...
 ' (R = ',num2str(R),'; M = ',num2str(M),'; N = ',num2str(N),')']);
xlabel('f/fs');   grid;
La = axis;     axis([La(1:2), -120, 20]);

% -------- ISOP-Filter (Kompensationsfilter)
fnutz = 0.01;   % Nutzbandbreite relativ zur hohen Abtastfrequenz 
%I = 2;
%c = -16;
I = 1;
c = -6;
hc = [1, zeros(1,I-1), c, zeros(1,I-1), 1]/abs(c+2);

% -------- ‹Überlagerte Darstellung der Frequenzgänge
fn = 0:R/(nfft-1):R;    % Frequenzbereich für das ISOP-Filter
wn = exp(j*2*pi*fn);    % bis R.fs'
Hc = polyval(hc,wn)';   % Frequenzgang von 0 bis R.fs' (fs' = fs/R) 

hold on
plot(fn/R, 20*log10(abs(Hc)));
hold off

% -------- Darstellung des gesammten Frequenzgangs
Hg = Hcic/gain.*Hc;  % Gesamt Frequenzgang

subplot(212);
plot(fn/R, 20*log10(abs(Hg)));
title('Amplitudengang der Zusammensetzung CIC- und ISOP-Filters');
xlabel('f/fs');   grid;
La = axis;     axis([La(1:2), -120, 10]);

% -------- Frequenzgang des Kompensationsfilters und des Gesamtfilters
figure(2);      clf;
Hc = fft(hc,nfft);

subplot(221), plot((0:nfft-1)/nfft, 20*log10(abs(Hc)));
title(['Amplitudengang des ISOP-Filters (I=',...
    num2str(I),'; c =',num2str(c),')']);
xlabel('f/fs''=(f/fs)*R');   grid;
La = axis;     axis([La(1:2), -10, 10]);
hold on;
La = axis;
plot([fnutz*R,fnutz*R],[La(3), La(4)],...
    [1-fnutz*R, 1-fnutz*R],[La(3), La(4)]);
hold off;

subplot(222), 
plot(fn/R, 20*log10(abs(Hg)));
title('CIC-, ISOP- und CIC*ISOP-Filter');
xlabel('f/fs');   grid;
faus = 0.02;
La = axis;     axis([0, faus, -1, 1]);
hold on;
La = axis;
nd = fix(nfft*faus);
plot((0:nd-1)/nfft, 20*log10(abs(Hcic(1:nd))/gain));

plot((0:nfft-1)/(R*nfft), 20*log10(abs(Hc)));

plot([fnutz,fnutz],[La(3), La(4)],...
    [1-fnutz, 1-fnutz],[La(3), La(4)]);

hold off;

subplot(223), 
plot(fn/R, 20*log10(abs(Hg)));
title('Zusammensetzung des CIC- und ISOP-Filters');
xlabel('f/fs');   grid;
La = axis;     axis([0, 1/R, -150, 10]);
hold on;
La = axis;
plot([fnutz,fnutz],[La(3), La(4)],...
    [0.1-fnutz, 0.1-fnutz],[La(3), La(4)]);
hold off;

subplot(224),
axis([1 100 0 100]);    axis('off');
text(5,90,['Dezimierungsfaktor R = ',num2str(R)]);
text(5,75,['Differential-Delay M = ',num2str(M)]);
text(5,60,['Anzahl der CIC-Stufen N = ',num2str(N)]);
text(5,45,['Nutzbandbreite fp/fs = ',num2str(fnutz)]);
text(5,30,['Nutzbandbreite fp/fs'' = (f/fs)*R = ',...
    num2str(fnutz*R)]);



