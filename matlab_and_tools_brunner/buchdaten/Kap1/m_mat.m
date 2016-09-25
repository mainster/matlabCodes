% Experiment (m_mat.m) zum Lesen und Schreiben
% von mat-Dateien (Binärdateien)

%-------- Daten
A = randn(5,5)*50;
t = 0:99;
b = sin(2*pi*t/20+pi/3);
c = cos(2*pi*t/20);

%------- Speichern der Daten
save my A b c t
% save my.mat A b c t
% save my A b c t -mat

clear;
%------- Lesen der daten
load my
% load my.mat
% load my.mat -mat

figure(1);
subplot(211), image(A);
title('Matrix A');
subplot(223), plot(t, b);
title('Variable b');
subplot(224), plot(t,c);
title('Variable c');
