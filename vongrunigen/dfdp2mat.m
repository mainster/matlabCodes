function [b,a]=dfdp2mat(infile)



% DFDP2MAT Importieren von Filterkoeffizienten aus einer DFDP-Datei

%

%          [b,a]=DFDP2MAT('dateiname') ermittelt die Filterkoeffizienten

%          des in der DFDP-Datei 'dateiname.FLT' enthaltenen Filters.

%

%          DFDP ist ein Digitalfilter-Entwurfsprogramm (Digital Filter

%          Design Package) der Fa. Atlanta Signal Processors Inc. in

%          Atlanta USA [43].

%          Die Filterdatei kann durch die DFDP-Module IIR, KFIR und

%          PMFIR erstellt worden sein. Wurden in DFDP die Koeffizienten

%          quantisiert, so werden die quantisierten Koeffizienten

%          eingelesen, andernfalls werden die exakten Koeffizienten

%          eingelesen.

%          Die ermittelten Filterkoeffizienten werden in den beiden

%          Vektoren a und b zurueckgeliefert. Der Vektor a enthaelt

%          dabei die Koeffizienten des Nennerpolynoms und der Vektor b 

%          enthaelt die Koeffizienten des Zaehlerpolynoms der Ueber-

%          tragungsfunktion H(z).

%          Die Filterkoeffizientenvektoren koennen direkt in den Befehlen

%          FILTER und FREQZ verwendet werden.

%

%          15.5.92 M.Christinat



%Kontrolle ob ein Argument mitgegeben wurde

if nargin==0

  % Argument fehlt, also Fehler ausgeben

  error('Argument fehlt ! (Hilfe mit ''help dfdp2ml'')');

end



% Kontrolle ob die Variable 'infile' einen String enthaelt

if isstr(infile)==0

  % Kein String, also Fehlermeldung ausgeben und abbrechen

  error('Das Argument ist kein String! ''..'' verwenden !');

end



% Test ob Filterdatei existiert

if exist([infile, '.FLT'])~=2

  % Datei existiert nicht, also Fehlermeldung ausgeben und abbrechen

  error(['DFDP-Datei ''', infile, '.FLT'' existiert nicht !']);

end



% DFDP-Filterdatei in Variable mit dem gleichen Namen wie der Dateiname

% ohne Extension laden

eval(['load ', infile, '.FLT']);



% DFDP-Daten in die Variable DFDP_Daten kopieren

DFDP_Daten = eval(infile);



% Der Dateiaufbau ist abhaengig davon, ob das Filter mit dem

% IIR-Modul oder mit einem FIR-Modul (PMFIR,KFIR) generiert wurde



% Kontrolle ob eine IIR-Filterdatei vorliegt

if DFDP_Daten(1)==1



  % Filterdatei ist fuer ein IIR-Filter

  

  % Anzahl der Filterstufen zweiter Ordnung bestimmen

  N = (DFDP_Daten(2)-1)/7;

  % Koeffizientenvektoren initialisieren

  a = [1];

  b = [1];

  % Kontrolle ob die Koeffizienten in Quantisierter Form vorliegen

  if DFDP_Daten(3+DFDP_Daten(2))==1

    % Offset auf die quantisierten Filterkoeffizienten ermitteln

    i = DFDP_Daten(2)+24; 

  else

    % Offset auf die unquantisierten Filterkoeffizienten ermitteln

    i = DFDP_Daten(2)+5*N+24; 

  end





  % Koeffizienten der einzelnen Stufen extrahieren und

  % Koeffizientenvektor des gesammten Filters berechnen

  for j=0:N-1

    p = i+5*j;

    a = conv( a, [ 1 DFDP_Daten(p:p+1)' ] );

    b = conv( b, DFDP_Daten(p+2:p+4)' );

  end



elseif DFDP_Daten(1)==2 | DFDP_Daten(1)==3



  % Filterdatei ist fuer ein FIR-Filter



  % Anzahl der Koeffizienten bestimmen

  N = DFDP_Daten(2);

  % Kontrolle ob die Koeffizienten in quantisierter Form vorliegen

  if DFDP_Daten(4+DFDP_Daten(2))==1

    % Ja, Offset auf die quantisierten Filterkoeffizienten ermitteln

    i = N+7; 

  else

    % Nein, Offset auf die unquantisierten Filterkoeffizienten ermitteln

    i = 2*N+7; 

  end

  % a-Koeffizientenvektor initialisieren. Das erste Element muss

  % auf 1 gesetzt werden, die restlichen Elemente auf 0.

  a    = zeros(1,N);

  a(1) = 1;

  % b-Koeffizientenvektor extrahieren

  b    = DFDP_Daten(i:i+N-1)';



else



  % Falls keine gueltige DFDP-Datei vorliegt eine Fehlermeldung ausgeben

  error ('Keine gueltige DFDP-Datei !');



end


