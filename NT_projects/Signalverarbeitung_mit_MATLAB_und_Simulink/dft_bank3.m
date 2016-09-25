% Programm dft_bank3.m zur Darstellung des Frequenzgangs
% eines rektanguläŠren Fensters undder Frequenzgänge der 
% DFT-Filterbank
%
% Das Programm dient auch der Parametrierung des Modell dft_bank_3.mdl

clear

fs = 1000;
Ts = 1/fs;

% ------- Fenster
N = 10;
h0 = ones(1,N)/N;   % Fenster oder gleitender Mittelwert-Filter

% ------- Frequenzgang
nfft = 1024;
H0 = fftshift(fft(h0, nfft));

% Darstellung
figure(1),   clf;
subplot(211), plot((-nfft/2+1:nfft/2)/nfft, 20*log10(abs(H0)));
title(['Amplitudengang H0 (N = ',num2str(N),')']);
xlabel('f/fs');    grid;
La = axis;   axis([La(1:2), -40, La(4)]);

subplot(212), plot((-nfft/2+1:nfft/2)/nfft, angle(H0));
title('Phasengang');
xlabel('f/fs');    grid;

% -------- DFT-Filterbank
hi = zeros(N,N);
for i = 1:N
    hi(i,:) = h0.*exp(j*2*pi*(0:N-1)*i/N);
end;

Hi = fft(hi,nfft);
% Darstellung
figure(2),   clf;
plot((0:nfft-1)/nfft, 20*log10(abs(Hi)));
title(['Amplitudengaenge Hi (N = ',num2str(N),')']);
xlabel('f/fs');    grid;
La = axis;   axis([La(1:2), -40, La(4)]);


% -------- WN Matrix füŸr die DFT-Filterung
% und Analyseseite des Filterbanksystems
WN = zeros(N,N);
for p = 1:N
    WN(p,:) = exp(j*2*pi*(p-1)*(0:N-1)/N)/N;
end;
% WN = dftmtx(N)/N;

% -------- WNt Matrix füŸr die Syntheseseite des 
% Filterbanksystems
WNt = WN'*N;
% WNt = dftmtx(N)';

% --------- Subbandverarbeitungsmatrix
nselekt = N;
sub_diag = [ones(1, nselekt), zeros(1, N-nselekt)];
% eye(N,N);
Ksub = diag(sub_diag);

% -------- Aufruf der Simulation
sim('dft_bank_3',[0, 1]);


