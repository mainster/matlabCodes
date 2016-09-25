% klausur SS06

a=[0.94 1.28 0.53 -0.17 -0.69 -0.12 1.08 1.34 0.70 -0.01 -1.08 -0.91];
y=[1.0 1.41 1.0 -0.24 -1.0 -0.29 1.0 1.52 1.0 0.0 -1.0 -1.52];

laa=xcorr(a,a,'biased');
lay=xcorr(a,y);
lyy=xcorr(y);

delete(findall(0,'type','line'))
clf

f1=figure(1);
SUB=210;
subplot(SUB+1);
hold all;
plot([1:length(a)],y,'-o'),hold all;
plot([1:length(a)],a,'-o'),hold all;
legend('y','a')
grid on;
hold off

subplot(SUB+2);
hold all;
%plot([1:length(laa)],laa/(0.5*length(laa)),'-o'),hold all;
plot([1:length(laa)],laa,'-o')
plot([1:length(lyy)],lyy/(0.5*length(lyy)),'-o')
%plot([1:length(lyy)],laa-lyy,'-o'),hold all;
%plot([1:length(lyy)],lyy-laa,'-o'),hold all;
line([0 length(laa)],[0.7307 0.7307])   % Lösungen vom quint für laa(0)
line([0 length(laa)],[0.4758 0.4758],'Color','red')
grid
legend('laa','lyy','0.7307 laut quint','0.4758 laut quint')
grid on;
hold off

s=[];
for i=1:10
    s=[s sprintf('warum laa/(0.5*length(laa)) damit wir auf lösung vom quint kommen?????\n')];
end

