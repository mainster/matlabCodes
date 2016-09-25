function folge (nmax) % Initialisierung der Funktion mit
                       % Festlegung der einzugeben und Auszugeben
                       % Parameter
axis ([0 nmax+1 0.5 6])% axis([xmin xmax ymin ymax])
s1=zeros (1,nmax);     % Vektor der Gr??e nmax festlegen
s2=zeros (1,nmax);     % Vektor der Gr??e nmax festlegen
a=zeros (1,nmax);      % Vektor der Gr??e nmax festlegen
 
a(1)=1;                % klar
s1(1)=1;               % klar
s2(1)=1;               % klar
hold on                % Grafikelement: sage, dass alle plots in
                       % einem Fenster bleiben und 
for k=2:1:nmax;        % for-Schleife von k=1 bis nmax mit der 
                       % Schrittweite 1
    a(k)=a(k-1)*4/5;   % Rekursion (siehe fed)
    s1(k)=s1(k-1)+1/k; % Rekursion (siehe fed) <-Unsinnige Formel
    s2(k)=s2(k-1)+a(k);% Rekursion (siehe fed)
end                    % Ende der Schleife
plot (s1,'r*')         % Ausgabe des Vektors s1 in rot und
                       % nur die Datenpunkte
 
plot (s2,'b-')         % Ausgabe des Vektors s2 in blau und
                       % die Datenpunkte verbinden