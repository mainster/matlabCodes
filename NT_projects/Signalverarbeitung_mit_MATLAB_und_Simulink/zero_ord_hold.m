% Programm zero_ord_hold, um das Bild 1_31b zu 
% erzeugen

x = 0:0.01:2;
figure(1);   clf;
plot(x, 20*log10(abs(sinc(x))));
La = axis; axis([La(1:2), -50, La(4)]);
grid;
ylabel('dB');
xlabel('f/fs');
hold on
plot([0.5 0.5],[-50 0]);
title('Amplitudengang des Halteglieds-Nullter-Ordnung (sinx/x)');
hold off
