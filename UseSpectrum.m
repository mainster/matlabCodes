Fs=1000;
t=0:1/Fs:.3;
x=cos(2*pi*t*200)+randn(size(t));
Hs=spectrum.periodogram;      % Use default values
psd(Hs,x,'Fs',Fs)