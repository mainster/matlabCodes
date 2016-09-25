% Klausur NT 2014

xx=[-1:0.01:1];
y=0.25*(xx+1);

f1=figure(1);
clf

SUB=210;
subplot(SUB+1);
hold all;
plot(xx,y)
plot(xx,fliplr(y))
grid on;

y2=conv(y,y);
y3=conv(y,fliplr(y));
y4=xcorr(y,y);
subplot(SUB+2);
hold all;
plot([0:length(y2)-1],y2)
plot([0:length(y2)-1],y3,'LineWidth',4)
plot([0:length(y2)-1],y4)
hold off;
grid on;
legend('conv(y,y)','conv(y,fliplr(y))','xcorr(y,y)')



