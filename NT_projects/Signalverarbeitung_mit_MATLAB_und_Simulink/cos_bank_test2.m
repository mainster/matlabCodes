% Programm cos_bank_test2.m zur Zerlegung eines Audio-
% Signals in 32 Spektralen Komponenten mit dem
% Modell cos_bank_21.mdl

clear
% ------- Parametrierung des Modells üŸber das 
% Programm cos_bank2.m
cos_bank2;  % Hier werden Figure 1,2,3 erzeugt
% N = 32;
% ------- Eingangssequenz
% 5 Symphonie von Beethoven
fs = 11025;   % Abtastfrequenz der Wav-Datei
Ts = 1/fs;
nN = fix(1/Ts);

[x,fs,nbit] = wavread('Beeth5th', nN);

% ------- Eingangssequenz füŸr das Modell 
simin = [((0:length(x)-1)*Ts)',x]; 

% ------- Subbandverarbeitungsmatrix
Ksub = eye(N,N);    % Ohne Verarbeitung
%Ksub = diag([1,1,1,zeros(1,N-3)]);

% ------- Aufruf der Simulation
sim('cos_bank_21',[((0:length(x)-1)*Ts)']);
y = squeeze(simout)'; 

figure(4);     clf;
subplot(4,1,1), plot((0:nN-1)*Ts, x);
title('Eingangssequenz');   xlabel('s');    grid;

nspk = length(spk)
for ki=1:6
    subplot(4,2,(ki+2)), plot((0:nspk-1)*N*Ts, spk(:,ki));
    ylabel(['Spkt-Komp. ',num2str(ki)]);
end;

figure(5);     clf;
for ki=7:14
    subplot(4,2,(ki-6)), plot((0:nspk-1)*N*Ts, spk(:,ki));
    ylabel(['Spkt-Komp. ',num2str(ki)]);
end;



