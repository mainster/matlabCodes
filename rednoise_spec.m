
Fs=2000;
tt=[0:1/Fs:1000-1/Fs];
rn=rednoise(length(tt)+1);
rn=rn(2:end);

f1=figure(1);
plot(tt,rn); grid on
title('red noise - time domain');
xlabel('t/s');

NFFT = 2^nextpow2(length(rn)); % Next power of 2 from length of y
rnf = fft(rn,NFFT)/length(rn);
ff = Fs/2*linspace(0,1,NFFT/2+1);

%f5=figure(5);
% Plot single-sided amplitude spectrum.
figure(4);
hold all;
rnfn=rnf./(max(rnf));

loglog(ff,rnfn(1:NFFT/2+1));
title('red/pink noise single-sided amplitude spectrum [dB]')
xlabel('f/Hz');
%ylim([5e-5, 5e-3])
%xlim([1,1e3])