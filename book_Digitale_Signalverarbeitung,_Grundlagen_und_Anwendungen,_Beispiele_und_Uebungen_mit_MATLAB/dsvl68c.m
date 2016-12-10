% M-File  DSVL68C.M      Version für MATLAB 4.0

% Loesung zu Kap.6 Aufgabe No.8 c)

%

% Die Wortlaenge B eines AD-Umsetzers mit dem Aussteuerbereich +-1 einlesen,

% ein zeitdiskretes Sinus-Signal mit einer gewuenschten Amplitude Xdach

% und Laenge N erzeugen und das zeitdiskrete, quantisierte Ausgangssignal 

% des AD-Umsetzers generieren. 

% Das SNR des Ausgangssignals bestimmen.



clear



J=1;

while J==1



  close, clc, disp(' ')

  B=    input(['Geben Sie die Wortlaenge des AD-Umsetzers ein  ',...

               '    B= ']);disp(' ')

  Xdach=input(['Geben Sie die Amplitude des Sinus-Signals ein  ',...

               'Xdach= ']);disp(' ')

  N=    input(['Geben Sie die Laenge der Sequenz ein           ',...

               '    N= ']);disp(' ')





  % 2 Perioden des Sinus und des quantisierten Sinus generieren.

  % Fehlersignal berechnen und alle 3 Signale darstellen.



  t=0:N; f0=1/(N/2); x=Xdach*sin(2*pi*f0*t); xQ=quantad(x,B); e=xQ-x;

  subplot(2,1,1),plot(t,x),axis([0 N 1.2*min(x) 1.2*max(x)]),grid

  hold on,subplot(2,1,1),disploto(t,xQ,'r'),hold off

  xlabel('n'),ylabel('x(n), xQ(n)')

  title('Nichtquantisierter und quantisierter Sinus')

  subplot(2,1,2),disploto(t,e,'b'),axis([0 N 1.2*min(e) 1.2*max(e)]),grid

  xlabel('n'),ylabel('e(n)')

  title('Fehlersignal')

  set(gcf,'Units','normal','Position',[0 0 1 1]), pause

  set(gcf,'Units','normal','Position',[0.5 0 0.5 0.4])





  % SNR berechnen und drucken



  SNR=10*log10(sum(x.^2)/sum(e.^2));

  disp(' '),disp(['Das Signal to Noise Ratio in dB betraegt   SNR= ',...

                  num2str(SNR)]), pause





  J=menu('Wollen Sie von vorne anfangen?','Ja','Nein'); close

end
