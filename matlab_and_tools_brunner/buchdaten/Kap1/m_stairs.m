% Experiment (m_stairs.m) zum Befehl stairs

%------- Sinussignal (kontinuierlich)
t = 0:0.01:10;
x = sin(2*pi*t/6+pi/3);

%------- Abgetastetes Signal
td = 0:0.5:10;
xd = x(1:0.5/0.01:length(x));

figure(1);
subplot(211), plot(t, x, '--');    hold on
stairs(td, xd);
hold off
title('Abgetastetes Signal mit stairs dargestellt');
xlabel('s');    grid;
La = axis;    axis([La(1), La(2), -1.2, 1.2]);
