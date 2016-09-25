% M-File  DSVL55.M      Version für MATLAB 4.0

%

% Loesung zu Kap.5 Aufgabe No.5

%

% Das M-File generiert ein 5ms langes Rauschsignal mit der Abtastfrequenz

% fa=100kHz. Dieses Signal wird mit sich selber korreliert.

% Mit Hilfe der Korrelationsfunktion xcorr berechnet es die Leistung.



clear, close, clc



fa=100e3; T=10e-6; M=500;

t=0:T:(M-1)*T;  tau=-(M-1)*T:T:(M-1)*T;



L=1;

while L==1



 K=menu(['Wollen Sie normalverteiltes oder gleichverteiltes ',...

         'Rauschen erzeugen?'],...

         'Normalverteiltes Rauschen mit dem Effektivwert 1',...

         'Gleichverteiltes Rauschen im Bereich 0 ... 1');



 clc, close, set(gcf,'Units','normal','Position',[0 0 1 1])



 if K==1





  % Normalverteiltes Rauschsignal generieren und darstellen



  x=randn(1,M);

  subplot(2,1,1),plot(t,x),axis([0 M*T -3 3]),grid

  xlabel('Zeit in s'),ylabel('x')

  title('Normalverteiltes Rauschsignal mit dem Effektivwert 1'), pause

  



  % Korrelationsfunktion rxx oder cxx berechnen und darstellen



  Q=menu('Welche Korrelationsfunktion wollen Sie berechnen?',...              

         'Die unkorrigierte Korrelationsfunktion  (Gl.5.8)',...

         'Die korrigierte Korrelationsfunktion   (Gl.5.13)');

  if Q==1

   rxx=xcorr(x);

   subplot(2,1,2),plot(tau,rxx),axis([-M*T M*T -0.2*M 1.2*M]),grid

   xlabel('Verschiebungszeit in s'),ylabel('rxx')

   title('Autokorrelationsfunktion rxx'), pause

  else 

   cxx=xcorr(x,'unbiased');

   subplot(2,1,2),plot(tau,cxx),axis([-M*T M*T -0.2 1.2]),grid

   xlabel('Verschiebungszeit in s'),ylabel('cxx')

   title('Autokorrelationsfunktion cxx'),pause

   set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5]), disp(' ')

   disp('Die mittlere Leistung P des Rauschsignals ist gleich')

   P=cxx(M), pause 

  end



 

 else





  % Gleichverteiltes Rauschsignal generieren und darstellen



  x=rand(1,M);

  subplot(2,1,1),plot(t,x),axis([0 M*T -1 2]),grid

  xlabel('Zeit in s'),ylabel('x')

  title('Gleichverteiltes Rauschsignal im Bereich 0 ...  1'), pause

  



  % Korrelationsfunktion rxx oder cxx berechnen und darstellen



  Q=menu('Welche Korrelationsfunktion wollen Sie berechnen?',...              

         'Die unkorrigierte Korrelationsfunktion  (Gl.5.8)',...

         'Die korrigierte Korrelationsfunktion   (Gl.5.13)');

  if Q==1

   rxx=xcorr(x);

   subplot(2,1,2),plot(tau,rxx),axis([-M*T M*T -0.2*M 1.2*M]),grid

   xlabel('Verschiebungszeit in s'),ylabel('rxx')

   title('Autokorrelationsfunktion rxx'), pause

  else 

   cxx=xcorr(x,'unbiased');

   subplot(2,1,2),plot(tau,cxx),axis([-M*T M*T -0.2 1.2]),grid

   xlabel('Verschiebungszeit in s'),ylabel('cxx')

   title('Autokorrelationsfunktion cxx'),pause

   set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5]), disp(' ')

   disp('Die mittlere Leistung P des Rauschsignals ist gleich')

   P=cxx(M), pause  

  end



 end



 L=menu('Wollen Sie weiterfahren?','Ja','Nein');



end
