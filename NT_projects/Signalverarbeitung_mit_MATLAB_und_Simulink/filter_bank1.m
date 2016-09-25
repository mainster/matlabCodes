% Programm filter_bank1.m Filter-Bank

% ------- Prototyp-Filter
N = 10;     % Anzahl Bänder
nf = 64;   % Ordnung des Filters
hp = fir1(nf, 1/(2*N));


% ------- Bandpassfilter
hk = zeros(N, nf+1);
cos_m = zeros(N, nf+1); % Cosinus Matrix

for k = 0:N-1
   hk(k+1,:) = hp.*cos(2*pi*(2*k+1)*((0:nf)-nf/2)/(4*N));
   cos_m(k+1,:) = cos(2*pi*(2*k+1)*((0:nf)-nf/2)/(4*N));
end;

% -------- Frequenzgänge der Bandpassfilter
nfft = 1024;
Hk = fft(hk',nfft);

figure(1),    clf;
plot((0:nfft-1)/nfft, 20*log10(abs(Hk)));
La = axis;   axis([La(1:2),-80,La(4)]);

CN = zeros(N,N);
for k = 0:N-1,
    CN(k+1,:) = cos((2*k+1)*pi*(0:N-1)/(2*N));
end;

CN
CN*inv(CN)





