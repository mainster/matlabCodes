% Programm teil_diff1.m in dem ein FIR-Filter
% entwickelt wird, das teilweise ein Differenzierer ist

clear
% -------- Spezifikationen
f = [0, 0.5, 0.54, 1];
m = [0, 1, 0, 0];

% -------- Lösungen für das Filter
nord = 128;
W1 = [10, 1];
[h1,feh,erg]=firgr(nord,f,m,W1,'d');

W2 = [10, 10];
[h2,feh,erg]=firgr(nord,f,m,W2,{'e1','e2'},'d');

% -------- Frequenzgänge 
nf = 1024;
[H1,w] = freqz(h1,1, nf);
[H2,w] = freqz(h2,1, nf);

phi1 = unwrap(angle(H1))' + 2*pi*(0:nf-1)/(2*nf)*(nord/2);
phi2 = unwrap(angle(H2))' + 2*pi*(0:nf-1)/(2*nf)*(nord/2);

%**************************************
figure(1),   clf;
subplot(121), 
[ax,z1,z2] = plotyy(w/pi, (abs(H1)),w/pi, phi1*180/pi);
axes(ax(1));
title(['Bewertung = ',num2str(W1)]);
xlabel('2f/fs');   grid;
ylabel('Betrag');
La = axis;    axis([La(1:2), 0, 1]);

axes(ax(2));
La = axis;    axis([La(1:2), 0, 100]);
ylabel('Grad'); 
set(ax(2), 'Ytick', [0:50:100]);

subplot(122), 
[ax,z1,z2] = plotyy(w/pi, (abs(H2)),w/pi, phi2*180/pi);axes(ax(1));
axes(ax(1));
title(['Bewertung = ',num2str(W1),' und e_1 , e_2 Option']);
xlabel('2f/fs');   grid;
ylabel('Betrag');
La = axis;    axis([La(1:2), 0, 1]);

axes(ax(2));
La = axis;    axis([La(1:2), 0, 100]);
ylabel('Grad'); 
set(ax(2), 'Ytick', [0:50:100]);

%**************************************
figure(2),   clf;
fr = 0.01;
x = cos(2*pi*fr*(0:1000));
y = filter(h1*0.25/fr, 1, x);

subplot(211),
nd = fix(length(x)/2);
stairs(0:nd-1,[x(1:nd)', y(nord/2+1:nd+nord/2)']);
title(['Eingang- und Ausgangssignal (f/fs = ', num2str(fr), ')']);
xlabel('k=t/Ts');   grid;
La = axis;    axis([La(1), nd, -2, 2]);

fr = 0.1;
x = cos(2*pi*fr*(0:1000));
y = filter(h1*0.25/fr, 1, x);

subplot(212),
nd = fix(length(x)/12);
stairs(0:nd-1,[x(1:nd)', y(nord/2+1:nd+nord/2)']);
title(['Eingang- und Ausgangssignal (f/fs = ', num2str(fr),')']);
xlabel('k=t/Ts');   grid;
La = axis;    axis([La(1), nd, -2, 2]);

