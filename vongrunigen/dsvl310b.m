% M-File  DSVL310b.M      Version für MATLAB 4.0

%

% Loesung zu Kap.3 Aufgabe No.10 b)

%

% Pol-Nullstellen-Diagramm von 10 Polen,

% Schrittantwort zum Polpaar mit dem Radius 0.85

% und in Abhaengigkeit der 10 Polpaare

% die 10 Schrittantworten dreidimensional darstellen.



clear, close, clc





% Radius r der 10 Polpaare bestimmen



r=0.05+0.1*[9:-1:0];





% Polpaare p1 und p2 bestimmen und plotten



Theta=pi/4;  % Theta: 45Grad-Winkel der Polpaare

p1=r*(cos(Theta)+j*sin(Theta)); p2=conj(p1);

pn_plot([p1 p2],[])

xlabel('Re(z)'), ylabel('Im(z)')

title('10 Polpaare mit 45Grad-Winkel')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% b0 und a berechnen.

% b0 enthaelt die 10 Koeffizienten des Zaehlers

% und a enthaelt die 10 Koeffizientenvektoren des Nenners

% des LTD-Systems 2.Ordnung



b0=[ones(10,1)-2*r'*cos(Theta)+r'.*r'];

a=[ones(10,1)  -2*r'*cos(Theta)  r'.*r'];





% Einheitsschritt-Vektor u und diskreter Zeitvektor n bestimmen



u=[zeros(1,10) ones(1,51)]; n=-10:50;





% Die 2. Schrittantwort berechnen und plotten



y=filter(b0(2),a(2,:),u);

subplot(2,1,1),disploto(n,y)

axis([-10 50 -1 2]), grid

title('Schrittantwort zum Polpaar mit dem Radius 0.85')

xlabel('n'), ylabel('y(n)')





% Alle 10 Schrittantworten dreidimensional darstellen



for i=1:10

	Y(i,:)=filter(b0(i),a(i,:),u);

end

subplot(2,1,2)

C=r'*ones(size(n)); colormap(hot)

h=mesh(n,r,Y,C);   % Als Alternative den Befehl "waterfall" verwenden

view([-10 10]), caxis([0 1])

xlabel('n'), ylabel('r'),zlabel('y(n)')

title('Schrittantworten zu den 10 Polpaaren')
