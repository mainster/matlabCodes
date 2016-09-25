% Tiefpass - Bandpass 
% NT


fc=0.1;
t=[0:0.01:10];
x= @(t) sin(2*pi*fc*t);

x1=x(t);
plot(t,x1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ------ FFT-Analyse der modulierten Bitfolgen

%FFT-Parameter festlegen
L = length(t);
% Ts = simoutTime.signals.values(2)-simoutTime.signals.values(1);
% Fs = 1/Ts;
window = blackman(L);
NFFT = 2^nextpow2(L);
%f = Fs/2*linspace(-1,1,NFFT);
% 
% % GMSK-Signal
 X = fft(x1,NFFT)/L;
 
 f=[1:1:size(X)];
 plot(f,X)
% Y_Gmsk = Y_Gmsk/max(abs(Y_Gmsk)); % Normierung
% Y_Gmsk_dB = 10*log10(abs([Y_Gmsk(end/2:end);Y_Gmsk(1:end/2-1)]).^2);