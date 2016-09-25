% Programm handle_1.m, in dem der Umgang mit graphischen Objekten
% über Zeigern untersucht wird
clear;
% ------- Erzeugung eines Bilds mit zwei Achsen-Objekte
fig_1 = figure(1);		clf;
p1 = subplot(211), plot(0:99, randn(1,100));
title('Zufallsfolge');		
xlabel('Index');		grid;
p2 = subplot(212), plot(0:200, 5*sin(2*pi*(0:200)/40+pi/4));
title('Sinussignal');		
xlabel('Zeit in s');	grid;

% ------- Zeiger des Bilds
hb = get(fig_1, 'Children')    % Ergibt zwei Zeiger zu den Axen
% der zwei Subplots hb(1)=p2 zu subplot(212) und hb(2)=p1 zu subplot(211)
% ------- Zeiger der zwei Axes des Bilds
ha1 = get(hb(1), 'Children')       % Ergibt ein Zeiger für den 
% Inhalt des subplot(212) 
ha2 = get(hb(2), 'Children')       % Ergibt ein Zeiger für den 
% Inhalt des subplot(211) 
% ------- Wahl der Axes mit Abszisse zwischen 0 und 100
h_1 = findobj('Xlim',[0,100])
% ------- Kinder dieser Axen
h_1_k = get(h_1(1), 'Children')
% ------- Typ der Kinder
get(h_1_k, 'Typ')
% Verlassen dieser Stelle mit Carraige-Return
pause(5);   % pause 5 Sekunden um das ursprüngliche Bild zu
% beobachten
% ------- Ä€nderung der Eigenschaften mit set
set(ha1, 'Linewidth', 2);
set(ha1, 'Color', [1 0 0]);
set(h_1_k, 'Marker', '*');
