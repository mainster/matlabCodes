% corr

clf

tt=[0:0.01:10];
tt2=[-10:0.01:10];

ys=-sin(2*pi*tt);
yc=cos(2*pi*tt);

f1=figure(1);
SUB=310;

subplot(SUB+1);

hold all;
plot(tt,ys);
plot(tt,yc);
grid on;

subplot(SUB+2);
cor=xcorr(ys,yc);

hold all;
plot(tt2,cor);
grid on;
legend('corSinCos')

subplot(SUB+3);
corCos=xcorr(yc,yc);
corSin=xcorr(ys,ys);

hold all;
plot(tt2,corCos);
plot(tt2,corSin);
legend('corCos','corSin')
grid on;





