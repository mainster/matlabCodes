% 3D-Experiment mit plot3 (my_plot3.m)
% Darstellung der Übertragungsfunktion (Betrag) eines digitalen
% Filters entlang des Einheitskreises

%------- Omega von 0 bis 2*pi
omega = 0:0.05:2*pi;

%------- Impulsantwort des digitalen Filters
h = fir1(32,[0.25, 0.75]);

%------- Komplexe Übertragungsfunktion entlang des Kreises
H = polyval(h,exp(j*omega));

%------- xy Koordinaten des Kreises
x = cos(omega);
y = sin(omega);

%------- Darstellung
figure(1);
subplot(121), plot3(x,y,(abs(H)));
xlabel('Real');   ylabel('Imag');   zlabel('Betrag');
grid;         hold on
plot3(x,y,zeros(1,length(omega)),'r');    % Kreis in der xy-Ebene
title('Betrag entlang des Einheitskreises');
view(-50, 20);          % Betrachtungsrichtung
hold off

%------- Betrag und Phase in Form eines Frequenzgangs
subplot(222), plot(omega, abs(H));
La = axis;    axis([La(1), max(omega), La(3), La(4)]);
xlabel('Omega');      grid;
title('Betrag');

subplot(224), plot(omega, angle(H));
La = axis;    axis([La(1), max(omega), La(3), La(4)]);
xlabel('Omega');      grid;
title('Phase');
