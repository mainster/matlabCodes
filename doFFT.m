function varargout = doFFT (SIG, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @@@MDB
%   function varargout = doFFT (SIG, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SIG         time domain signal vector
%   TIME        vector of timesteps
%   HG_HANDLE   handle to which doFFT should plot its results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isnumeric(SIG)
    error('First argument needs to be a numeric vector')
end

t=[];

if nargin > 1
    if ~isnumeric(varargin{1})
        error('Second argument needs to be a numeric vector')
    end
    if length(SIG) ~= length(varargin{1})
        error('Vectors must be the same length')
    else
        t = varargin{1};
    end
end
if nargin > 2
    if ~ishghandle(varargin{2})
        error('Third argument needs to be a plot/hg- handle')
    end
    h = varargin{2};
else
    h = figure(99);
end
    

% kein Zeitvektor übergeben?
if isempty(t)
    t=[0:1:length(SIG)-1];
end

% calc sampletime
Ts = (t(end)-t(1))/(length(SIG)-1);
Fs = 1/Ts;
L = length(SIG);

fprintf('Ts=%g\nFs=%5.3g\nL=%5.3g\n', Ts, Fs, L)


figure(h);
cla;
subplot(211);

KSAM=250;

plot(t( (end-KSAM)/2:(end+KSAM)/2),SIG((end-KSAM)/2:(end+KSAM)/2),'x-')
title('time domain signal ')
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y1 = fft(SIG,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

figure(h);
subplot(212);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y1(1:NFFT/2+1))/Ts) 
title('frequency domain signal')
grid on;
% 
% %%
% Fs = 1000;                    % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 1000;                     % Length of signal
% t = (0:L-1)*T;                % Time vector
% % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% 
% x = 3*sin(2*pi*50*t);% + sin(2*pi*120*t); 
% y = x + 2*randn(size(t));     % Sinusoids plus noise
% 
% p1=figure(1);
% plot(Fs*t(1:end),y(1:end))
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('time (milliseconds)')
% %%
% % It is difficult to identify the frequency components by looking 
% % at the original signal. Converting to the frequency domain, the 
% % discrete Fourier transform of the noisy signal y is found by 
% % taking the fast Fourier transform (FFT):
% 
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(y,NFFT)/L;
% f = Fs/2*linspace(0,1,NFFT/2+1);
% 
% p2=figure(2);
% % Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

end