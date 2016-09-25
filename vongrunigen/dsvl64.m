% M-File  DSVL64.M      Version für MATLAB 4.0

%

% Loesung zu Kap.6 Aufgabe No.4

%

% Ein Butterworth-Bandpassfilter 4.Ordnung entwerfen und

% seinen Amplitudengang und seine Gruppenlaufzeit darstellen.

% Eine Wellengruppe bestehend aus der Ueberlagerung von

% zwei Sinusschwingungen erzeugen, deren Frequenzen innerhalb

% des Durchlassbereiches liegen. Diese Wellengruppe dient als

% Eingangssignal des Butterworth-Filters.

% Eingangs- und Ausgangssignal darstellen und damit die Wirkung der

% Gruppenlaufzeit demonstrieren.





L=1;

while L==1



  clear, close, clc



  % Die Abtastfrequenz und die beiden Durchlassfrequenzen eingeben



  fa=input('Geben Sie die Abtastfrequenz in Hz ein:  fa= ');

  disp(' '),disp(' ')

  disp('Geben Sie die untere und die obere Durchlassfrequenz')

  disp('des Bandpassfilters in Hz ein.')

  disp('(Die beiden Frequenzen sollten ca. 20 mal kleiner als')

  disp('die Abtastfrequenz sein.)')

  fu=input('fu= ');fo=input('fo= ');disp(' '),disp(' '), T=1/fa;





  % Die Koeffizienten des Butterworth-Bandpassfilters bestimmen



  [b a]=butter(2,[fu/(0.5*fa) fo/(0.5*fa)]);





  % Amplitudengang und Gruppenlaufzeit berechnen und darstellen



  [H Omega]=freqz(b,a,1024); tau=T*grpdelay(b,a,1024); f=fa*Omega/(2*pi);

  subplot(2,1,1), semilogy(f,abs(H),'y'), axis([0 .25*fa 1e-4 1e1]), grid

  xlabel('f in Hz'),ylabel('A(f)'),

  title('Amplitudengang des Butterworth-Bandpassfilters')

  subplot(2,1,2), plot(f,tau), axis([0 .25*fa -0.2*max(tau) 1.2*max(tau)])

  grid, xlabel('f in Hz'),ylabel('tau(f) in s'),

  title('Gruppenlaufzeit des Butterworth-Bandpassfilters')  

  set(gcf,'Units','normal','Position',[0 0 1 1]), pause

  set(gcf,'Units','normal','Position',[0.4 0 0.6 0.3])





  % Die Wellengruppe mit den beiden Sinusschwingungen generieren,

  % filtern und darstellen. 



  disp('Geben Sie die Frequenzen der beiden Sinusschwingungen ein.')

  disp('(Die beiden Frequenzen sollten innerhalb des Durchlassbereichs liegen.)') 

  disp(' ')

  f1=input('f1= '); f2=input('f2= ');

  Deltaf=abs(f2-f1); tend=2/Deltaf;     % Da Deltaf die Frequenz der Schwebung

                                        % ist, werden durch die Wahl von

                                        % tend 2 Schwebungen dargestellt

  t=0:T:tend; x=sin(2*pi*f1*t)+sin(2*pi*f2*t); y=filter(b,a,x);

  n=round(1024*mean([fu fo])/(0.5*fa))+1; taum=tau(n);       % Gruppenlaufzeit

                                        % bei der Mittenfrequenz bestimmen

  close,subplot(2,1,1),plot(t,x,'b'),axis([0 tend -2.5 2.5]),grid

  xlabel('t in s'),ylabel('x(n)')

  title(['Wellengruppe mit f1= ',num2str(f1),' Hz und f2= ',num2str(f2),' Hz'])

  subplot(2,1,2),plot(t,y,'g'),axis([0 tend -2.5 2.5]),grid

  xlabel('t in s'),ylabel('y(n)')

  title(['Gefilterte Wellengruppe,  tau= ',num2str(taum),' s'])

  set(gcf,'Units','normal','Position',[0 0 1 1]), pause



  L=menu('Wollen Sie weiterfahren?','Ja','Nein');



  close

end
