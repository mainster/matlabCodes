% 3D-Experiment (my_stem3.m) mit dem Befehl stem3

%------- Mittelwertfilter
h = ones(1,10);

omega = 0:0.1:2*pi;
x = cos(omega);         y = sin(omega);

%------- FFT der Impulsantwort
H = fft(h,length(omega));

figure(1);
stem3(x,y,abs(H),'d','fill');
xlabel('Real');    ylabel('Imag');    zlabel('Betrag');
title('FFT der Impulsantwort eines FIR-Tiefpassfilters');
hold on
plot3(x,y,zeros(1,length(omega)),'r');
hold off
grid on
view([-70, 50]);