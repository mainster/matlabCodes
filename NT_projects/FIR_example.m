clc 
clear 

%Ordnung n: 
n = 87; % Anzahl der Nullstellen in der kompl. Ebene 
fa = 48000; % Abtastfrequenz in Hz passend zur Signalverarbeitungs-Hardware wählen 
fn = fa/2; % Nyquistfrequenz 
%Wn = 4000/fn; % -6 dB – Grenzfrequenz in Hz 
%FIRkoeff = fir1(n, Wn, 'low'); % TP-Filter 

% Alternativ der Entwurf eines Bandpasses: 
pass1 = 2500; % -6 dB – Grenzfrequenz in Hz 
pass2 = 3800; % -6 dB – Grenzfrequenz in Hz 
Wn = [pass1/fn pass2/fn]; 
FIRkoeff = fir1(n, Wn, 'bandpass'); % BP-Filter 

% Darstellung der Koeffizienten: 
fig = figure(1); 
plot(FIRkoeff, '--') 
hold on; 
plot(FIRkoeff, '.') 
hold off 
title('Koeffizienten (Impulsantwort) des FIR-Filters') 

% Zunächst den Nennerkoeffizientenvektor erstellen: 
% (nötig zur korrekten Rechnung mit freqz, grpdelay, zplane) 
a = zeros(size(FIRkoeff)); % oder: a = zeros(1, n+1); 
a(1) = 1; 
% freqz über Aufruf mit Koeffizientenvektoren 
cntW = 4096; 
% Standardmäßig (ohne zusätzliche Parameterangabe cntW) werden nur 512 Frequenzpunkte 
% berechnet! 
[Hfir, Wfir] = freqz(FIRkoeff, a, cntW); % mit 0 <= Wfir <= pi 
df = Wfir(2)/pi*fn; % oder: df = fn/length(Wfir); 
% df (delta_f) ist der Abstand zwischen den Frequenzpunkten in Hz 
% d.h. df entspricht der Frequenzauflösung in Hz 
amplFIR = abs(Hfir); 
phaseFIR = angle(Hfir); 
% Darstellung des Amplitudengangs (linear): 
fig = figure(fig+1); 
plot(Wfir/pi*fn, 10*log10(amplFIR), 'b'); 
%axis([0 fn -0.1 1.1]); 
title('Amplitudengang des FIR-Filters') 
ylabel('Verstärkung') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
hold on; 
plot(Wn*fn,1,'rx') 
hold off; 
% Darstellung der Phase: 
fig = figure(fig+1); 
plot(Wfir/pi*fn, -unwrap(phaseFIR)/pi*180) 
title('Phasengang des FIR-Filters') 
ylabel('Phase in Grad') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 

% Darstellung des Amplitudengangs (logarithmisch): 
fig = figure(fig+1); 
%semilogx(Wfir/pi*fn, 20*log10(amplFIR), 'b'); 
axis([1 fa -105 5]); % 1 Hz bis fa, -105 dB bis +5 dB 
title('Amplitudengang des FIR-Filters') 
ylabel('Verstärkung in dB') 
xlabel(['Auflösung: ',num2str(df),' Hz Frequenz in Hz']) 
grid 
hold on; 
plot(Wn*fn,0,'rx') 
hold off; 

% Darstellung der Nullstellen in der z-Ebene: 
fig = figure(fig+1); 
zplane(FIRkoeff, a) 
title('Nullstellen des FIR-Filters') 
ylabel('Imaginaerteil') 
xlabel('Realteil') 

% Erzeugen der Koeffizientendatei: 
fid = fopen('FIRkoeff.h', 'w'); % file-id 
fprintf(fid,'const float FIRkoeff[] = {\n'); 
fprintf(fid,'%1.7e,\n',FIRkoeff(1:end-1)); 
fprintf(fid,'%1.7e};\n',FIRkoeff(end)); 
fclose(fid); 