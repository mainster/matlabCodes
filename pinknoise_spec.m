
Fs=2000;
tt=[0:1/Fs:1000-1/Fs];
pnt=pinknoise(length(tt)+1);
pnt=pnt(2:end);

f1=figure(1);
plot(tt,pnt); grid on
title('pink noise - time domain');
xlabel('t/s');

NFFT = 2^nextpow2(length(pnt)); % Next power of 2 from length of y
pnf = fft(pnt,NFFT)/length(pnt);
ff = Fs/2*linspace(0,1,NFFT/2+1);
% 
% f2=figure(2);
% % Plot single-sided amplitude spectrum.
% plot(ff,2*abs(pnf(1:NFFT/2+1))) 
% title('pink noise single-sided amplitude spectrum')
% xlabel('f/Hz');
% 
% 
% f3=figure(3);
% % Plot single-sided amplitude spectrum.
% plot(ff,10*log10(abs(pnf(1:NFFT/2+1)))) 
% title('pink noise single-sided amplitude spectrum [dB]')
% xlabel('f/Hz');
% 
% hold all;
% % Plot single-sided amplitude spectrum.
% plot(ff,20*log10(abs(pnf(1:NFFT/2+1))),'g') 
% hold off


f4=figure(4);
% Plot single-sided amplitude spectrum.
%plot(ff,10*log10(abs(pnf(1:NFFT/2+1)))) 
pnf=abs(pnf);
pnfn=pnf./(max(pnf));
loglog(ff,pnfn(1:NFFT/2+1));
title('pink noise single-sided amplitude spectrum [dB]')
xlabel('f/Hz');
% ylim([5e-5, 5e-3])
% xlim([1,1e3])