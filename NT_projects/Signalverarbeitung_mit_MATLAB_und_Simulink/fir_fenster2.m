% Programm fir_fenster2 zum Vergleich der FIR-Filter
% entwickelt mit Fenster-Verfahren

% ------- FIR-Tiefpassfilter entwickelt mit verschiedenen Fenster
nord = 50;  % Ordnung des Filters
fr = 0.4;   % Relative Bandbreite (zur Nyquist-Frequenz)  

b = zeros(nord+1, 4, 2);    % Feld für zwei Gruppen
    % je 4 Filter mit verschiedenen Fenster-Funktionen
    
b(:,1,1) = fir1(nord,fr);                 % Default-Fenster
b(:,2,1) = fir1(nord,fr,hanning(nord+1)); % Hanning-Fenster
b(:,3,1) = fir1(nord,fr,gausswin(nord+1));% Gausswin-Fenster
par = 0.95;
b(:,4,1) = fir1(nord,fr,tukeywin(nord+1,par));% Tukey-Fenster

b(:,1,2) = fir1(nord,fr,barthannwin(nord+1));% Barthannwin
b(:,2,2) = fir1(nord,fr,blackmanharris(nord+1)); % Blackmanhariss
b(:,3,2) = fir1(nord,fr,nuttallwin(nord+1));% Nuttallwin
b(:,4,2) = fir1(nord,fr,hann(nord+1));% Hann

% -------- Frequenzgänge
nf = 1024;
Hf = zeros(nf, 4, 2);      % der zwei Gruppen

for p = 1:2
    for k = 1:4
       [Hf(:,k,p),w] = freqz(b(:,k,p), 1, nf, 1);
    end;   
end;

figure(1),    clf;
subplot(121), 
plot(w, 20*log10(abs(Hf(:,:,1))));
La = axis;   axis([La(1:2), -100, 10]);
xlabel('f/fs');   grid;
legend('Default', 'Hanning', 'Gausswin', 'Tukey',3);
ylabel('dB');
title(['Amplitudengaenge (Ordnung = ',num2str(nord),')']);

subplot(122),
plot(w, 20*log10(abs(Hf(:,:,2))));
La = axis;   axis([La(1:2), -100, 10]);
xlabel('f/fs');   grid;
legend('Barthannwin', 'Blackmanharris', 'Nuttallwin', 'Hann',3);
ylabel('dB');
title(['Amplitudengaenge (Ordnung = ',num2str(nord),')']);

figure(2),    clf;
nd = fix(nf/2);

subplot(121), 
plot(w(1:nd), 20*log10(abs(Hf(1:nd,:,1))));
La = axis;   axis([La(1:2), -0.4, 0.4]);
xlabel('f/fs');   grid;
legend('Default', 'Hanning', 'Gausswin', 'Tukey',3);
ylabel('dB');
title('Amplitudengaenge (Ausschnitt)');

subplot(122),
plot(w(1:nd), 20*log10(abs(Hf(1:nd,:,2))));
La = axis;   axis([La(1:2), -0.4, 0.4]);
xlabel('f/fs');   grid;
legend('Barthannwin', 'Blackmanharris', 'Nuttallwin', 'Hann',1);
ylabel('dB');
title('Amplitudengaenge (Ausschnitt)');




