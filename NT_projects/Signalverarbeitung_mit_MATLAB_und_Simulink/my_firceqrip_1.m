% Programm my_firceqrip_1 zur Untersuchung eines
% FIR-Filters zur Kompensation eines
% Amplitudengangs der mit (sinx/x)^p abfällt

clear

% -------- Spezifikation des FIR-Filters
nord = 20;    % Ordnung des Filters
p = 5;        % Potenz für die sinx/x-Funktion
w = 0.5;      % Faktor für das Argument der sinx/x-Funktion
Apass = 5.7565e-4;   % 0.01 dB Welligkeit im Durchlassbereich
Astop = 0.01;        % 40 dB Welligkeit im Sperrbereich
Fpass = 0.16;        % Durchgangsfrequenz

% -------- Filter Entwicklung
Aslope = 10;         % 10 dB Slope 
h = firceqrip(nord, Fpass, [Apass, Astop],'passedge','slope',...
     Aslope, 'invsinc', [w,p]);

Aslope = 60;         % 60 dB Slope 
h1 = firceqrip(nord, Fpass, [Apass, Astop],'passedge','slope',...
     Aslope, 'invsinc', [w,p]);

nfft = 2048; 
H = fft(h,nfft);
H1 = fft(h1,nfft);

% -------- Frequenzgang Darstellung
figure(1);    clf;
subplot(221), plot((0:nfft-1)/nfft, 20*log10([abs(H)',abs(H1)']));
title('Amplitudengang');
xlabel('f/fs');   grid;

subplot(222), plot((0:nfft-1)/nfft, 20*log10([abs(H)',abs(H1)']));
title('Amplitudengang (Ausschnitt)');
xlabel('f/fs');   grid;
La = axis;   axis([La(1), Fpass*1.6, -1, 1]);
     
     
     
     
