% M-File  DSVL56.M      Version für MATLAB 4.0

%

% Loesung zu Kap.5 Aufgabe No.6

%

% Das M-File generiert ein x- und ein y-Signal.

% Das x-Signal besteht aus einem Sinus mit Rauschen und

% das y-Signal besteht aus einem Sinus mit der Phase Null.

% Anschliessend werden die beiden Signale korreliert.



clear, close, clc



% Textausgabe



disp(' '),disp(' ')

disp('Ein x-Signal, bestehend aus Rauschen mit dem Effektivwert Ueff')

disp('und einem Sinus mit dem Scheitelwert Udach1, der Frequenz f1')

disp('und der Phase phi1')

disp('soll mit einem y-Signal, bestehend aus einem Sinus mit dem')

disp('Scheitelwert Udach2 und der Frequenz f2 korreliert werden')

disp(' ')

disp('Die Anzahl Abtastwerte ist gleich N')

disp('und die Abtastfrequenz ist gleich fa'), pause





% Parameterwerte initialisieren und in den Vektor A schreiben



Ueff=1;A(1)=Ueff;

Udach1=1;A(2)=Udach1; f1=1e3;A(3)=f1; phi1=90;A(4)=phi1;

Udach2=1;A(5)=Udach2; f2=1e3;A(6)=f2;

N=1000;A(7)=N; fa=125e3;A(8)=fa; T=1/fa;





L=1; while L==1



 % Parameterwerte auf Bildschirm darstellen



 clc,close,disp(' '),disp('Die Parameterwerte betragen:'),disp(' ')



 disp(['1.  ','Ueff   =  ',num2str(Ueff),  ' V   '])

 disp(['2.  ','Udach1 =  ',num2str(Udach1),' V   '])

 disp(['3.  ','f1     =  ',num2str(f1),    ' Hz  '])

 disp(['4.  ','phi1   =  ',num2str(phi1),  ' Grad'])

 disp(['5.  ','Udach2 =  ',num2str(Udach2),' V   '])

 disp(['6.  ','f2     =  ',num2str(f2),    ' Hz  '])

 disp(['7.  ','N      =  ',num2str(N),     '     '])

 disp(['8.  ','fa     =  ',num2str(fa),    ' Hz  ',...

            '     T   =  ',num2str(T),     ' s   '])





 % Neuen Parameter eingeben



 

 K=menualt('Wollen Sie einen neuen Parameter eingeben? Wenn ja welchen?',...

           'Ueff','Udach1','f1','phi1','Udach2','f2','N','fa','Nein');



 if K<9

  A(K)=input('Geben Sie den Wert ein    :  ');

 else, end



 Ueff=A(1); 

 Udach1=A(2); f1=A(3); phi1=A(4);

 Udach2=A(5); f2=A(6);

 N=2*round(A(7)/2); fa=A(8); T=1/fa;   % N muss eine gerade Zahl sein





 % x- und y-Signal generieren:  x-Signal: Sinus + Rauschen

                            %   y-Signal: Sinus 

 t=0:T:(N-1)*T; 

 urausch=Ueff*randn(1,N);

 x=Udach1*sin(2*pi*f1*t+phi1*pi/180)+urausch;

 y=Udach2*sin(2*pi*f2*t);



 

 % x- und y-Signal plotten 



 subplot(2,1,1), plot(t,y,'y:',t,x,'r')

 axis([0 N*T 1.1*min([x y]) 1.1*max([x y])]), grid

 title('rot: Sinus + Rauschen   gelb punktiert: Sinus')

 xlabel('Zeit in s'),ylabel('rot:x(n)  gelb:y(n)  [Volt]')





 % Kreuzkorrelierte berechnen und darstellen



 cxy=xcorr(x,y,'unbiased'); cxy=cxy(N/2:1:3*N/2); tau=-(N/2)*T:T:(N/2)*T;

 subplot(2,1,2), plot(tau,cxy,'g'), axis('auto'), grid

 title('Kreuzkorrelierte des x- und y-Signals')

 xlabel('Verschiebungszeit tau in s'),ylabel('cxy(m)  [Volt hoch 2] ')

 set(gcf,'Units','normal','Position',[0 0 1 1]), pause

 set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])





 L=menu('Wollen Sie weiterfahren?','Ja','Nein');



end
