%%%%%%%%%%%%%%%%%%%%%%%%
% Korrelation awgn()
%%%%%%%%%%%%%%%%%%%%%%%%

delete(findall(0,'type','line'));

noise=wgn(1e4,1,1);

f1=figure(1);
SUB=320;


subplot(SUB+1);
plot(noise);
grid on;


lxx=xcorr(noise,noise);

subplot(SUB+2);
plot(lxx);
grid on;

noiseN=noise./max(abs(noise));

subplot(SUB+3);
plot(noiseN);
grid on;


lxxN=xcorr(noiseN);

subplot(SUB+4);
plot(lxxN);
grid on;

huell1=hilbert(noise);

subplot(SUB+5);
plot(huell1);
grid on;


lxxH=xcorr(huell1);

subplot(SUB+6);
plot(real(lxxH),imag(lxxH),'o-');
grid on;




















