
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% erzeugen von unkorrelierten prozessen so dass r_N1_N2(tau)=m1*m2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','line'));

m1=1.5;
m2=2;

N1= wgn(1000, 1, 1);
N2= wgn(1000, 1, 1);

N1 = m1+N1-mean(N1);    % durch endlich viele wgn sampels entsteht ungewollter 
N2 = m2+N2-mean(N2);    % Mittelwert . Diesen subtrahieren bevor gewollter mw addiert wird

N1add=awgn(N1,5,'measured');
N1add=N1add-(abs(mean(N1)-mean(N1add)));
mean(N1)
mean(N2)
mean(N1add)

cor12 = xcorr(N1, N2); 
cor11add = xcorr(N1, N1add); 

f1=figure(1);
clf('reset');
SUB=310;

subplot(SUB+1);
hold all;
plot([N1 N2 N1add]);
hold off;
grid on;
legend(sprintf('N1: %.1f + wgn',m1), sprintf('N2: %.1f + wgn',m2),'N1add: awgn(N1,5)');

m1m2(1:length(cor12))=max(cor12/length(N1));
sams=[1:length(cor12)];
subplot(SUB+2);
hold all;
[ax2 ph2(1) ph2(2)]=plotyy(sams,cor12, sams, m1m2);
hold off;
grid on;
set(ph2(2),'Color','red','Linestyle','--');
set(ax2(2),'YColor','red');
legend('cor12',sprintf('max(cor12/%.0f)=%.2f',length(N1),max(cor12/length(N1))));
title(sprintf('Kreuzkorrelation der mittelwert- behafteten, \nunkorrelierten Rauschprozesse N1 und N2'))

max(cor12/length(N1))

subplot(SUB+3);
hold all;
plot(cor11add);
hold off;
grid on;
legend('cor11add: xcorr(N1, N1add)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AKF Probeklausur NT SS2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tt=[0:0.01:10];
f0=1;

f2=figure(2);
clf 'reset'
SUB=310;

phi=0;
fun1=sin(2*pi*f0*tt+phi);
phi=0.5;
fun2=sin(2*pi*f0*tt+phi);

subplot(SUB+1);
hold all;
plot(tt, fun1);
plot(tt, fun2);
hold off;
grid on;

akf1=xcorr(fun1);
akf2=xcorr(fun2);
subplot(SUB+2);
hold all;
plot(akf1);
plot(akf2);
hold off;
grid on;
axis tight;
legend('akf1','akf2');

ar=sort(findall(0,'type','figure'));
% set(ar,'WindowStyle','docked');


