% Programm iir_3.m zur Untersuchung von IIR-Filtern
% entwickelt mit den Funktionen butter, cheby1, 
% cheby2 und ellip.

clear
% -------- Spezifikation
f_3dB = 1000;      % Durchlassfrequenz
ku = 2;            % Überabtastungsfaktor
nord = 6;          % Ordnung des Filters
fs = ku*2*f_3dB;   % Abtastfrequenz
fr = 2*f_3dB/fs;   % Relative Frequenz zum Nyquist-Bereich

% -------- Entwicklung der Filter
a = zeros(4, nord+1);
b = zeros(4, nord+1);

% Butterworth Filter
[b(1,:),a(1,:)] = butter(nord,fr,'high'); 

% Tschebyschev Typ I Filter
Rp = 0.1;    % Welligkeit im Durchlassbereich
[b(2,:),a(2,:)] = cheby1(nord,Rp,fr,'high'); 

% Tschebyschev Typ II Filter
Rs = 60;    % Welligkeit im Sperrbereich
[b(3,:),a(3,:)] = cheby2(nord,Rs,fr,'high'); 

% Elliptisches Filter
[b(4,:),a(4,:)] = ellip(nord,Rp,Rs,fr,'high'); 

% -------- Frequenzgänge der IIR-Filter
nf = 1000;
H = zeros(nf,4);
Gr = H;

for k = 1:4,
    H(:,k)=freqz(b(k,:),a(k,:),nf,'whole');
    Gr(:,k)=grpdelay(b(k,:),a(k,:),nf,'whole'); 
end;

figure(1),   clf;
subplot(211);
plot((0:nf-1)*fs/nf, 20*log10(abs(H)));
title(['Amplitudengaenge der digitalen IIR-Filter (Ordnung = ',...
        num2str(nord),'; f\_3dB = ',num2str(f_3dB),' Hz; fs =',...
        num2str(fs),' Hz)']);
xlabel('Hz');    grid;
La = axis;    axis([La(1:2), -100, 20]);

subplot(212);
plot((0:nf-1)*fs/nf, Gr/fs);
xlabel('Hz');    grid;
title('Gruppenlaufzeit');
ylabel('Sekunden');

