
Nsym = 6;           % Filter order in symbol durations
beta = 0.5;         % Roll-off factor
sampsPerSym = 8;    % Upsampling factor



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
% Generate random data.
x = 2*randi(hStr, [0 1], DataL, 1)-1;
x = ones(max(size(x)),1);
x(1:4)=[0 0 0 0]';
% Time vector sampled at symbol rate in milliseconds
tx = 1000 * (0: DataL - 1) / R;


% Upsample and filter.
yo = filter(rcosFlt, upsample([x; zeros(Nsym/2,1)], sampsPerSym));
% Time vector sampled at sampling frequency in milliseconds
to = 1000 * (0: (DataL+Nsym/2)*sampsPerSym - 1) / Fs;
% Plot data.
fig1 = figure;
stem(tx, x, 'kx'); hold on;
% Plot filtered data.
plot(to, yo, 'b-'); hold off;
% Set axes and labels.
axis([0 30 -1.7 1.7]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data', 'Upsampled Data', 'Location', 'southeast')