% M-File  DSVL66A.M      Version für MATLAB 4.0

%

% Loesung zu Kap.6 Aufgabe No.6 a)

%

% Mit Hilfe des M-Files APPROXBP.M ein Bandpassfilter entwerfen.

% Anschliessend ein Rechtecksignal mit einer gewuenschten Frequenz

% generieren und darstellen. Dieses Rechtecksignal verstaerken,

% mit dem Bandpassfilter filtern und darstellen.



clear, close, clc



K=1;

while K==1      % Solange K=1 ist, soll das Programm DSVL66.M in Aktion bleiben



  approxbp      % Bandpassfilter entwerfen



  L=1;

  while L==1    % Solange L=1 ist, soll ein neues Rechtecksignal generiert

                % und verstaerkt werden koennen



    % Zeitvektor t fuer 4 Perioden des Rechtecksignals erzeugen.

    % T0 ist die Periodendauer des Rechtecksignals.



    disp(' '),disp(' ')

    f0=input(['Geben Sie die Frequenz des Rechtecksignals in kHz ein',...

              '   f0= ']);disp(' ')

    T=1/fa; T0=1/f0; tstart=0; tend=4*T0-T; t=tstart:T:tend; 



   

    % Rechtecksignal x generieren, mit v verstaerken und dann filtern



    disp(' '), v=input('Geben Sie die Verstaerkung ein  v= '); disp(' ')

    x=2.5*(1+square(2*pi*f0*t)); [y,zf]=filter(v*b,a,x); 





    % Eingangs- und Ausgangssignal darstellen und neu berechnen



    J=1; n=0;           % n=0 :Initialisierung des Zaehlindexes

    while J==1;         % Solange J=1 ist, sollen 4 neue Perioden dargestellt 

                        % und berechnet werden koennen



      % Eingangs- und Ausgangssignal darstellen

      close,subplot(2,1,1),plot(t,x,'b'),axis([tstart tend -1 6]),grid

      xlabel('t in ms'),ylabel('x(n)')

      title(['Rechtecksignal,   f0= ',num2str(f0),' kHz,   ',...

             't= ',num2str(tstart),' ms ... ',num2str(tend),' ms'])

      subplot(2,1,2),plot(t,y,'g'),axis([tstart tend 1.2*min(y) 1.2*max(y)])

      grid,xlabel('t in ms'),ylabel('y(n)')

      title(['Gefiltertes Rechtecksignal,   v= ',num2str(v),...

             ',   t= ',num2str(tstart),' ms ... ',num2str(tend),' ms'])

      set(gcf,'Units','normal','Position',[0 0 1 1]), pause

    

      % Bei Bedarf weitere Rechteckperioden generieren und filtern

      J=menu('Wollen Sie weitere Rechteckperioden generieren und filtern?',...

             'Ja','Nein');      % Bei Nein wird J=2: Programm geht zum

                                % naechsten end

      n=n+1;   % Zaehlindex zur Generierung von 4 neuen Perioden um 1 erhoehen

      tstart=n*4*T0; tend=(n+1)*4*T0-T; t=tstart:T:tend;

      x=2.5*(1+square(2*pi*f0*t)); [y,zf]=filter(v*b,a,x,zf); 

    end



    L=menu('Wollen Sie eine neue Rechteck-Frequenz f0 eingeben?',...

           'Ja','Nein, aber neu anfangen','Nein, Programm beenden');



    if L<=2

      K=1; clc,close            % L=1 und K=1: f0 neu einlesen 

    else                        % L=2 und K=1: Programm neu starten

      K=2;                      % K=2: Programm beenden

    end



  end



end



close, clear J K L n Omega
