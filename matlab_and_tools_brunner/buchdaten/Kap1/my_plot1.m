% Formen des Plot-Befehls

t = 0:0.1:10;

y1 = 3*sin(2*pi*t/2.5+pi/3);
y2 = 7.5*cos(2*pi*t/1.6);

%------- Erste Form
figure(1);       
plot(t,y1,t,y2);
title('Sinus- und Cosinusfunktionen');
xlabel('Zeit in s');      grid;

%------- Zweite Form
y =[y1', y2'];
figure(2);
plot(t, y);
title('Sinus-und Cosinusfunktionen');
xlabel('Zeit in s');      grid;
legend('y1 = Sinus', 'y2 = Cosinus',-1);

figure(3);
plot(t, y,'LineWidth',2);
title('Sinus-und Cosinusfunktionen');
xlabel('Zeit in s');      grid;
legend('y1 = Sinus', 'y2 = Cosinus',-1);

figure(4);
plot(t, y,'*','MarkerSize',4);
title('Sinus-und Cosinusfunktionen');
xlabel('Zeit in s');      grid;
legend('y1 = Sinus', 'y2 = Cosinus',-1);

figure(5);
plot(t, y1,'r--','LineWidth',2);   hold on;
plot(t, y2,'g--','LineWidth',1);
hold off;
title('Sinus-und Cosinusfunktionen');
xlabel('Zeit in s');      grid;
legend('y1 = Sinus', 'y2 = Cosinus',-1);



