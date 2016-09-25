% Programm fenster_funk1.m in dem die Fenster-Funktionen
% untersucht werden
% Boxcar-, Bartlett-, Blackman-, Chebwin-, Hamming-, 
% Hanning-, Hann- und Kaiser-Fenster

% ------- Länge des Fensters
nk = 120;

wf = zeros(nk, 4, 2);

wf(:,1,1) = boxcar(nk);   % Boxcar-Fenster
wf(:,2,1) = bartlett(nk); % Bartlett-Fenster
wf(:,3,1) = blackman(nk); % Bartlett-Fenster

Rs = 60;                % Parameter für chebwin
wf(:,4,1) = chebwin(nk, Rs);  % Bartlett-Fenster

%***********************************************
wf(:,1,2) = hamming(nk);  % Bartlett-Fenster
wf(:,2,2) = hanning(nk);  % Bartlett-Fenster
wf(:,3,2) = hann(nk);     % Bartlett-Fenster

betha = 10;
wf(:,4,2) = kaiser(nk, betha);  % Bartlett-Fenster

% ------- Spektrum (Frequenzgang der Fenster)
wfn = wf;
for p = 1:2
    for k = 1:4
       wfn(:,k,p) = wf(:,k,p)/sum(wf(:,k,p));
    end;   
end;

nf = 2048;

Wf = zeros(nf, 4, 2);
for p = 1:2
    for k = 1:4
       [Wf(:,k,p),w] = freqz(wfn(:,k,p), 1, nf, 'whole', 1);
    end;   
end;
 

figure(1);    clf;
subplot(121),
plot(0:nk-1, wf(:,:,1));
La = axis;   axis([0, nk-1, 0, 1.1]);
legend('Boxcar', 'Bartlett', 'Blackman', 'Chebwin',4);
xlabel('k');    grid;
title('Fenster-Funktionen (Huellen)');
nd = fix(nf/10);

subplot(122),
plot(w(1:nd), 20*log10(abs(Wf(1:nd,:,1))));
La = axis;   axis([La(1:2), -80, 0]);
xlabel('f/fs');    grid;
ylabel('dB');
legend('Boxcar', 'Bartlett', 'Blackman', 'Chebwin');
title('Spektrum der Fensterfunktionen');

%*************************************
figure(2);    clf;
subplot(121),
plot(0:nk-1, wf(:,:,2));
La = axis;   axis([0, nk-1, 0, 1.1]);
legend('Hamming', 'Hanning', 'Hann', 'Kaiser',4);
xlabel('k');    grid;
title('Fenster-Funktionen (Huellen)');

nd = fix(nf/10);

subplot(122),
plot(w(1:nd), 20*log10(abs(Wf(1:nd,:,2))));
La = axis;   axis([La(1:2), -80, 0]);
xlabel('f/fs');    grid;
ylabel('dB');
legend('Hamming', 'Hanning', 'Hann', 'Kaiser');
title('Spektrum der Fensterfunktionen');


% -------- Die Fenster Eigenschaften der zweiten Gruppe 
% mit wvtool dargestellt
wvtool(wf(:,1,2),wf(:,2,2),wf(:,3,2),wf(:,4,2));
legend('Hamming', 'Hanning', 'Hann', 'kaiser');


