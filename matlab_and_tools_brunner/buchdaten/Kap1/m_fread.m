% Experiment (m_read.m) zum Lesen und Schreiben
% von Binär-Dateien 
%-------- Daten
A = randn(5,5)*50;
t = 0:99;
b = sin(2*pi*t/20+pi/3);
c = cos(2*pi*t/20);

%------- Speichern der Daten
fid = fopen('my.bin','w');
precision = 'double';
fwrite(fid,A,precision);     fwrite(fid,b,precision);
fwrite(fid,c,precision);     fwrite(fid,t,precision);
fclose(fid);

clear;
%------- Lesen der daten
fid = fopen('my.bin','r');
precision = 'double';
A = fread(fid,[5,5],precision);      b = fread(fid,[1,100],precision);
c = fread(fid,[1,100],precision);    t = fread(fid,[1,100],precision);

figure(1);
subplot(211), image(A);
title('Matrix A');
subplot(223), plot(t, b);
title('Variable b');
subplot(224), plot(t,c);
title('Variable c');
