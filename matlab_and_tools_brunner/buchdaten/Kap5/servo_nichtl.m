% Programm servo_nichtl.m zur Untersuchung der Nichtlinearität
% aus dem Modell servo2.mdl

% -------- Nichtlinearität
x = -5:0.01:5;
y = tanh(x)*2;

% -------- Steigung (Verstärkung)
y1 = diff(y);

figure(1);    clf;
subplot(211), plot(x,y)
title(' Nichtlinearitaet');
grid;
subplot(212), plot(x, [y1(1), y1]);
title('Steigung der Nichtlinearitaet');
grid;
