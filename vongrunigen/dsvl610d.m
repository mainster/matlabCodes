% M-File  DSVL610D.M      Version für MATLAB 4.0

%

% Loesung zu Kap.6 Aufgabe No.10 d)

%

%

% Das M-File fordert den Benutzer zuerst auf, folgende Filterdaten

% einzugeben: Die Abtastfrequenz fa, die Wortlaenge B, sowie die

% Koeffizienten des Zaehler- und Nennerpolynoms eines rekursiven 

% Digitalfilters.

%

% Aufgrund dieser Daten werden die quantisierten Koeffizienten

% des Kaskadenfilters mit Biquads berechnet und gedruckt.

% Danach wird der genaue und der quantisierte Amplitudengang

% geplottet und die Differenz der beiden Amplitudengaenge dargestellt. 

%

% Anschliessend wird das Rauschen, das am Ausgang des Kaskadenfilters

% durch das Abschneiden der Multiplikationsergebnisse entsteht,

% simuliert und dargestellt. Schliesslich wird noch ein Sinussignal

% gefiltert, dargestellt und das SNR berechnet und gedruckt.





L=1;

while L==1



  clear, close, clc



  % Aufforderung zur Eingabe der Filterdaten



  disp(' ')

  disp('Geben Sie die Abtastfrequenz fa in kHz,')

  disp('die Filterkoeffizienten-Vektoren b und a')

  disp('und die Wortlaenge B ')

  disp('eines rekursiven Digitalfilters ein.'),disp('')

  disp('Der b- und der a-Vektor koennen wie folgt erzeugt werden:'),disp('')

  disp('1. Mit einem Approximationsbefehl wie butter, cheby1, cheby2 ')

  disp('   oder ellip.')

  disp('2. Mit der Funktion approxbp')

  disp('   (erzeugt mit Ausnahme von B alle Filterdaten).')

  disp('3. Mit dem Programm DFDP und anschliessendem Konvertieren der')

  disp('   Filterdaten mit der Funktion dfdp2mat.')

  disp('4. Durch Eingabe ueber die Tastatur.'),disp(' ')

  disp('Schliessen Sie Ihre Eingabe mit der Tastenfolge R E T U R N ab.')

  disp(' '), disp(' '), keyboard





  % Die quantisierten Koeffizienten des Kaskadenfilters bestimmen

  % und die Filterdaten drucken



  K=menu('Wuenschen Sie eine optimale PN-Paarung und Biquad-Reihenfolge?',...

         'Ja','Nein, eine zufaellige PN-Paarung und Biquad-Reihenfolge');



  cascade=['[bBQ,aBQ]=kaskade(b,a);    '

           '[bBQ,aBQ]=kaskade(b,a,''z'');'];	

  eval(cascade(K,:));  m=length(bBQ(:,1));  q=2^(-B+1); 

  for i=1:m			

    bBQq(i,:)=quantcoe(bBQ(i,:),B); aBQq(i,:)=quantcoe(aBQ(i,:),B);

  end



  clc, disp(' ')

  disp(['Abtastfrequenz in kHz   fa= ',num2str(fa)]), disp(' ')

  disp(['Filterordnung           2m= ',int2str(2*m)]), disp(' ')

  disp(['Wortlaenge               B= ',int2str(B)]), disp(' ')

  disp(['Quantisierungsstufe      q= ',num2str(q)]), disp(' '),disp(' ')

  disp('Quantisierte Koeffizienten des Kaskadenfilters:'), bBQq, aBQq, pause

  



  % Amplitudengang des genauen und des quantisierten Filters, 

  % sowie die Differenz der beiden Amplitudengaenge darstellen



  bq=bBQq(1,:); aq=aBQq(1,:);                       % Koeffizienten der 

  for i=2:m                                         % Uebertr.funktion Hq(z)

    bq=conv(bq,bBQq(i,:)); aq=conv(aq,aBQq(i,:));   % des quantisierten

  end                                               % Filters berechnen.



  K=menualt(['In welchem Frequenzbereich wollen Sie den Frequenzgang ',...

             'darstellen?'],...

             'Im Nyquistbereich','Im Frequenzbereich   f1  ...  f2');disp(' ')

  if K==1

    [H,Omega]=freqz(b,a,1024); f=(0.5*fa/pi)*Omega;

    [Hq,Omega]=freqz(bq,aq,1024);

  else

    f1=input('Geben Sie die untere Frequenzgrenze in kHz ein  f1= ');disp(' ');

    f2=input('Geben Sie die obere Frequenzgrenze in kHz ein   f2= ');disp(' ');

    Deltaf=(f2-f1)/1023; f=f1:Deltaf:f2; Omega=2*pi*f/fa;

    H=freqz(b,a,Omega); Hq=freqz(bq,aq,Omega);

  end



  AindB=20*log10(abs(H)); AqindB=20*log10(abs(Hq));

  subplot(2,1,1),plot(f,AindB,'b'),axis('auto'),grid

  xlabel('Frequenz in kHz'), ylabel('A(f) in dB')

  title('Ampl.gaenge;  blau: genaue,  gelb: quantisierte Koeffizienten')

  set(gcf,'Units','normal','Position',[0 0 1 1])

  pause(2), hold on, subplot(2,1,1), plot(f,AqindB,'y'), pause(3)

  subplot(2,1,1), plot(f,AindB,'b'), hold off



  DeltaA=AqindB-AindB;

  subplot(2,1,2), plot(f,DeltaA,'c'), axis('auto'), grid

  xlabel('Frequenz in kHz'), ylabel('DeltaA(f) in dB')

  title('Differenz der beiden Amplitudengaenge'), pause

  set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5]), clc





  % Scheitelwert und Frequenz des Sinussignals einlesen,

  % Quantisierungsrauschen yr generieren, Sinussignal filtern und darstellen



  Xdach=input('Geben Sie den Scheitelwert des Sinussignals ein    Xdach= ');

  f0=input   ('Geben Sie die Frequenz des Sinussignals in kHz ein    f0= ');  



  N=1024; yr=rauschbq(bBQq(1,:),aBQq(1,:),B,N);

  for i=2:m;

    yr=filter(bBQq(i,:),aBQq(i,:),yr)+rauschbq(bBQ(i,:),aBQ(i,:),B,N);

  end



  T=1/fa; t=0:T:(N-1)*T; 

  x=Xdach*sin(2*pi*f0*t); yo=filter(bq,aq,x); y=yo+yr;



  close,subplot(2,1,1), plot(t,yr,'y.')

  axis([0 N*T min(yr) max(yr)]), grid, xlabel('t in ms'), ylabel('yr(n)')

  title(['Quantisierungsrauschen,   q= ',num2str(q)])

  if N*T-8/f0<0 t1=0; else t1=N*T-8/f0; end

  subplot(2,1,2), plot(t,y,'g'), axis([t1 N*T min(y) max(y)]), grid

  xlabel('t in ms'), ylabel('y(n)')

  title('Gefiltertes Ausgangssignal inklusive Quantisierungsrauschen')

  set(gcf,'Units','normal','Position',[0 0 1 1]), pause

  set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])





  % Signal-to-noise ratio SNR berechnen und drucken



  SNR=10*log10(sum(yo.^2)/sum(yr.^2));

  disp(' '),disp(' '),

  disp(['Das Signal-to-Noise Ratio in dB betraegt   SNR= ',num2str(SNR)])

  pause





L=menu('Wollen Sie von vorne beginnen?','Ja','Nein');

end



close

clear K L Omega cascade i H Hq AindB AqindB DeltaA f1 f2 f0 Xdach yo ...

      yr t1 ans Deltaf
