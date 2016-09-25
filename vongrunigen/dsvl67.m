% M-File  DSVL67.M      Version für MATLAB 4.0

% Loesung zu Kap.6 Aufgabe No.7

%

% Die Daten eines FIR-Multiband-Filters einlesen und darstellen,

% daraus nach der Methode von Parks-McClellan ein FIR-Filter entwerfen

% und seinen Amplitudengang darstellen.



clear



J=1;

while J==1

  close, clc

  disp('Anhand eines Beispiels wird erklärt, wie Sie die')

  disp('Filterdaten des Multiband-FIR-Filters eingeben koennen:')

  disp(' ')

  disp('fa=2; N=40;')

  disp('fufoAw=[0 .1 0 100')

  disp('.2 .3 1 10')

  disp('.4 .6 0 100')

  disp('.7 .8 1 10')

  disp('.9 fa/2 0 100]'),disp(' ')

  disp('fa ist die Abtastfrequenz in kHz und N stellt die Filterordnung dar.')

  disp(' ')

  disp('Jede Zeile der Matrix fufoAw beschreibt ein Frequenzband.')

  disp(['In der 1.Kolonne steht die untere ',...

        'und in der 2. die obere Frequenzgrenze,'])

  disp('Kolonne 3. enthaelt den dazugehoerigen Amplitudengangwert')

  disp('und in Kolonne 4. befindet sich der Gewichtungsfaktor.'),disp(' ')

  disp('Die Filterdaten koennen mit dem Befehl "save filename fa N fufoAw"')

  disp('abgespeichert und mit dem Befehl "load filename" geladen werden.')

  disp(' ')

  disp('Laden Sie nun Ihr File oder geben Sie Ihre Filterdaten ein')

  disp('und schliessen Sie die Eingabe mit der Tastenfolge R E T U R N ab.')

  disp('(Für weitere Angaben tippen Sie "help remez".)'),disp(' '),keyboard

  



  % Die Vektoren für den Befehl remez erzeugen und den Amplitudengang berechnen



  ff=fufoAw(:,1:2); ff=ff'; ff=ff(:); F=ff/(fa/2);

  M=[fufoAw(:,3) fufoAw(:,3)]; M=M'; M=M(:);  W=fufoAw(:,4);

  b=remez(N,F,M,W); [H,Omega]=freqz(b,1,1024);

  A=abs(H); f=0.5*fa*Omega/pi;



  

  % Die Gewichtungsfunktion, den gewuenschten Amplitudengang und 

  % den Amplitudengang des entworfenen Filtes darstellen.



  WW=[W W]; WW=WW'; WW=WW(:);

  subplot(2,1,1),plot(ff,WW,'r'),axis([0 fa/2 -0.2*max(W) 1.2*max(W)]),grid

  xlabel('f in kHz'),ylabel('w(f)')

  title('Gewichtungsfunktion des FIR-Multiband-Filters')  



  subplot(2,1,2),plot(ff,M,'b'),axis([0 fa/2 -0.2*max(A) 1.2*max(A)]),grid

  xlabel('f in kHz'),ylabel('A(f)')

  title('Gewuenschter (blau) und realisierter (gelb) Amplitudengang')

  hold on,subplot(2,1,2),plot(f,A,'y'),hold off

  set(gcf,'Units','normal','Position',[0 0 1 1]), pause



  J=menu('Wollen Sie von vorne anfangen?','Ja','Nein');

end

close, clear J Omega
