% Plot Bitstream 
% mit und ohne Pulsformung
%
delete(findall(0,'type','line'))    % Inhalte der letztem plots löschen, figure handle behalten
clc;

Nsym = 6;           % Filter order in symbol durations
beta = 0.5;         % Roll-off factor
sampsPerSym = 200;    % Upsampling factor



%We use FDESIGN.PULSESHAPING to store the specifications of the raised cosine filter.
% Shape of the pulse shaping filter
shape = 'Raised Cosine';
% Specifications of the raised cosine filter with given order in symbols
rcosSpec = fdesign.pulseshaping(sampsPerSym, shape, 'Nsym,beta', Nsym, beta)
% Pulse Shaping with Raised Cosine Filters

rcosFlt = design(rcosSpec);
rcosFlt.Numerator = rcosFlt.Numerator / max(rcosFlt.Numerator);
disp(rcosFlt)

% Parameters.
DataL = 20;             % Data length in symbols
R = 1000;               % Data rate
Fs = R * sampsPerSym;   % Sampling frequency

% Create a local random stream to be used by random number generators for
% repeatability.
hStr = RandStream('mt19937ar', 'Seed', 0);

xSt=zeros(DataL,4);
xSt(:,1)= 2*randi(hStr, [0 1], DataL, 1)-1;
xSt(:,2)=ones(DataL,1);
xSt(:,3)=zeros(DataL,1)*(-1);
xSt(:,3)=[1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 ].'; 
xSt(:,4)=[1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 ].'; 

% Time vector sampled at symbol rate in milliseconds
tx = 1000 * (0: DataL - 1) / R;
yo=zeros(length(filter(rcosFlt, upsample([xSt(:,1); zeros(Nsym/2,1)], sampsPerSym))),4);
x=xSt(:,1);
% Upsample and filter.
for k=1:4
    yo(:,k) = filter(rcosFlt, upsample([xSt(:,k); zeros(Nsym/2,1)], sampsPerSym));
end;
% Time vector sampled at sampling frequency in milliseconds
to = 1000 * (0: (DataL+Nsym/2)*sampsPerSym - 1) / Fs;


%%%%% PSD

nfft = 2^nextpow2(length(yo(:,1)));
Pxx=zeros(length(fft(yo(:,k),nfft)),4);
for k=1:4
    Pxx(:,k) = abs(fft(yo(:,k),nfft)).^2/length(yo(:,k))/Fs;
end;

sub=220;
fig2 = figure(2);

Hs=spectrum.periodogram;      % Use default values
tickF=Fs/2*linspace(0,1,nfft/2);
for n=1:4
    subplot(sub+n);
%    psd(Hs,yo(:,n),'Fs',Fs)
stem(tickF(1:1*nfft/100),Pxx((1:1*nfft/100),n));grid on;

end;


fig1 = figure(1);
sub=320;

for n=1:4
    subplot(sub+n);
    hold on;
    stairs(tx, xSt(:,n), '-o','Color','b'); 
    plot(to, yo(:,n), 'r'); grid on;       % Plot filtered data.
    hold off;
    axis([0 30 -1.7 1.7]);  xlabel('Time (ms)'); ylabel('Amplitude');
    legend('Transmitted Data', 'Upsampled Data', 'Location', 'southeast')
end