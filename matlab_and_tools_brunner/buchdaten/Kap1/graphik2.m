% Experiment (graphik2.m) zur Handhabung der graphischen
% Objekten

%-------- Figure-Objekt mit zwei Axes-Kindern

figure(1);    clf;
n = 0:99;
subplot(211), plot(n, randn(1,100));
title('Zufallsfolge');
xlabel('n');      grid;

t = 0:200; 
y = sin(2*pi*t/40+pi/3);

subplot(212), plot(t,y);
title('sinus');  
xlabel('Zeit');   grid;

%-------- Ändern einiger Eigenschaften des laufenden Bildes (gcf)

set(gcf,'Color',[0.6,0.6,0.6]);
set(gcf,'PaperType','A4');

%-------- Handle für die Axes-Kinder
zeiger_axes = get(gcf,'Children')

get(zeiger_axes(1));       % Eigenschaften des Kindes 1
get(zeiger_axes(2));       % Eigenschaften des Kindes 2


