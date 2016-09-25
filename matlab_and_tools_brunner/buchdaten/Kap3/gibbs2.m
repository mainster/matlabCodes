% Programm (gibbs2.m) zur Darstellung des rekonstruierten
% rechteckigen Signals mit begrenzter Anzahl von Harmonischen
% über die Funktion gibbs1.m

figure(1);     clf;
n = 2;
[y1, t1] = gibbs1(n, 0);
subplot(311), plot(t1,y1);
title(['Rekonstruktion mit n = ',num2str(n),...
      ' Harmonischen']);
grid;
%-----------------------------
n = 10;
[y2, t2] = gibbs1(n, 0);
subplot(312), plot(t2,y2);
title(['Rekonstruktion mit n = ',num2str(n),...
      ' Harmonischen']);
grid;
%-----------------------------
n = 20;
[y3, t3] = gibbs1(n, 0);
subplot(313), plot(t3,y3);
title(['Rekonstruktion mit n = ',num2str(n),...
      ' Harmonischen']);
grid;
xlabel('Zeit in s ');

figure(2);      clf;
plot(t1,[y1',y2',y3']);
title('Rekonstruktion mit 2, 10 und 20 Harmonischen');
grid;
