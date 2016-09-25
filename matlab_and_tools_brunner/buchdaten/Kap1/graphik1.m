% Experiment (graphik1.m) zur Handhabung der graphischen
% Objekten

%-------- Figure-Objekt mit zwei Axes-Kindern

figure(1);    clf;
subplot(211), plot(0:99, randn(1,100));
title('Zufallsfolge');
xlabel('n');    grid;

a = randn(20,20);
a1 = filter2(ones(5,5)/25, a);

subplot(212), surf(a1);
title('surf');

%-------- Ändern einiger Eigenschaften des laufenden Bildes (gcf)

set(gcf,'Color',[0.6,0.6,0.6]);
set(gcf,'PaperType','A4');

%-------- Handle für die Axes-Kinder
zeiger_axes = get(gcf,'Children')

get(zeiger_axes(1));       % Eigenschaften des Kindes 1
get(zeiger_axes(2));       % Eigenschaften des Kindes 2


