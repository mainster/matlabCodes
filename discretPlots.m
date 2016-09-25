% discret plots
delete(findall(0,'type','line'))    % Inhalte der letzten plots löschen, figure handle behalten

f1=figure(1);
X1 = linspace(-2,3,26)';
Y = (tanh(X1+pi/4)*0.8);
n=[1:7];
p=[8:length(Y)];

hold on;
plot(X1,Y,'r');
stem(X1(n),Y(n),'b','-v','MarkerFaceColor','b');
stem(X1(p),Y(p),'b','-^','MarkerFaceColor','b'); grid on;
set(gca,'XTick',([-2:1:5]));
grid(gca,'minor')
hold off;

% f2=figure(2);
% subplot(2,2,1)
% plot(rand(1,20))
% title('grid off')
% subplot(2,2,2)
% plot(rand(1,20))
% grid on
% title('grid on')
% subplot(2,2,[3 4])
% plot(rand(1,20))
% grid(gca,'minor')
% title('grid minor')