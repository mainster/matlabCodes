% M-File  DSVL410.M      Version für MATLAB 4.0

%

% Loesung zu Kap.4 Aufgabe No.10

%

% Das M-File generiert ein 1s langes Signal mit der Abtastfrequenz

% fao=1024Hz. Dieses Signal wird als Originalsignal bezeichnet.

% Das Originalsignal wird mit einer Abtastfrequenz fa, die gleich oder

% um eine Zweierpotenz kleiner als 1024Hz ist, abgetastet.

% Zum Originalsignal und zum abgetasteten Signal wird das Spektrum

% berechnet und dargestellt.

% Das Spektrum des abgetasteten Signals wird mit Nullen gefuellt,

% bis es die Laenge von 1024 hat und danach wird die inverse FFT darauf

% angewendet; dies ergibt das rekonstruierte Signal.

% Aus dem Originalsignal und dem rekonstruierten Signal wird

% das "Signal to noise ratio" SNR berechnet.



clear, close, clc



% Abtastfrequenz fa einlesen



disp(' '),disp(' ')

K=menu('Waehle eine Abtastfrequenz','4Hz','8Hz','16Hz',...

        '32Hz','64Hz','128Hz','256Hz','512Hz','1024Hz');

fa=2^(K+1); disp(' '), disp(['Abtastfrequenz  fa= ',int2str(fa),'Hz']), 

N=2^(K+1); disp(' '),disp(['Anzahl Abtastpunkte  N= ',int2str(N)]), pause(1)





% Originalsignal xo generieren und darstellen



fao=1024; To=1/1024; No=1024;       % Der Index o steht fuer original

m=fao/fa;              % m kann man als Dezimierungsfaktor bezeichnen



to=0:To:(No-1)*To;

xo=[zeros(1,256) 0.5 ones(1,127) 0 -ones(1,127) 0 ...

    ones(1,127) 0 -ones(1,127) -0.5 zeros(1,255)];

subplot(2,1,1),plot(to,xo,'r'),axis([0 1 -2 2]),grid

xlabel('t   [s]'),ylabel(['x(n), x(',int2str(m),'n), y(n)'])

title('Signale   rot: original   gelb: Abtastpunkte   blau: rekonstruiert')

hold on, axis(axis)





% Das Spektrum zu xo berechnen und darstellen

 

fo=0:fao/No:0.5*fao; Xo=fft(xo);

subplot(2,1,2),displot(fo,(1/No)*abs(Xo(1:No/2+1)),'r')

axis([0 0.5*fao -0.05 0.4]),grid

xlabel('f   [Hz]'),ylabel('(1/N)*abs[X(k)]')

title(['Spektren   rot: fa=1024Hz   blau: fa=',int2str(fa),'Hz   ',...

       'gruen: Nullerweiterung'])

hold on, axis(axis)

set(gcf,'Units','normal','Position',[0 0 1 1])





% Das dezimierte Signal x berechnen und darstellen



t=0:m*To:(No-1)*To; x=xo(1:m:No);

subplot(2,1,1),plot(t,x,'y.'), pause





% Aus dem Spektrum X des dezimierten Signals das Null erweiterte

% Spektrum Y erzeugen und darauf die inverse FFT anwenden: 

% Ergibt das rekonstruierte Signal y.

% Y und y darstellen.



X=fft(x);

Y=zeros(1,No);                  % Y Null setzen und dann mit den richtigen

Y(1:N/2+1)=X(1:N/2+1); Y(No-N/2+1:No)=X(N/2+1:N);      % Werten von X abfuellen

f=0:fa/N:0.5*fa; 

subplot(2,1,2),displot(f,(1/N)*abs(Y(1:N/2+1)),'b')    % Spektrum des

                                % dezimierten Signals blau zeichnen.

subplot(2,1,2)

plot(0.5*fa+fao/No:fao/No:0.5*fao,Y(N/2+2:No/2+1),'g') % Null-

hold off                        % erweiterung gruen zeichnen

y=real(m*ifft(Y));              % Das Bilden des Realteils ist noetig, weil

                                % die ifft einen komplexen Vektor liefert.

subplot(2,1,1), plot(to,y,'b')





% Zur Sichtbarmachung die Abtastpunkte nochmals gelb zeichnen



subplot(2,1,1),plot(t,x,'y.'), hold off, pause





% Die mittlere Leistung Po des Originalsignals und die mittlere Leistung

% Pnoise des Fehlersignals berechnen und daraus das SNR in dB bestimmen



Po=(1/No)*sum(xo.^2); Pnoise=(1/No)*sum((y-xo).^2);

SNR=10*log10(Po/Pnoise);

disp(' '),disp('Das rekonstruierte Signal weist folgendes SNR auf')

disp(' '),disp(['SNR=  ',num2str(SNR),'dB']),disp(' ')

set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])
