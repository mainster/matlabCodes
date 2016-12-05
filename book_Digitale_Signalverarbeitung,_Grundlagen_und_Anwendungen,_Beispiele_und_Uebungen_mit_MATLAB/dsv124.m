% M-File  DSV124.M      Version für MATLAB 4.0

%

% Bilder 1.9 und 1.10 zu DSV Kap. 1.2.4

%

% DTMF-Signal mit dazugehoerigem Spektrum darstellen



clear, close, clc



N=2048;              % Anzahl Abtastwerte N=2048

T1=.07;              % Dauer des DTMF-Signals des Ziffer 1  T1=70ms

T=T1/N; fa=1/T;      % Abtastfrequenz fa=29257Hz  





% DTMF-Signal der Ziffer 1

%

t1=0:T:.1;

Uu=.436; fu=697; Uo=.552; fo=1209;

y1=Uu*sin(2*pi*fu*t1)+Uo*sin(2*pi*fo*t1);

y1(1:439)=zeros(1,439); y1(2488:2926)=zeros(1,439);

subplot(2,1,1), plot(t1*1000,y1), axis([0 100 -2 2]), grid

xlabel('t   [ms]'),ylabel('u(t)   [V]')

title('DTMF-Signal fuer die Ziffer 1')

set(gcf,'Units','normal','Position',[0 0 1 1])



% Ausschnitt aus dem DTMF-Signal

%

t2=(.045:T:.055);

y2=Uu*sin(2*pi*fu*t2)+Uo*sin(2*pi*fo*t2);

subplot(2,1,2), plot(t2*1000,y2), axis([45 55 -2 2]), grid

xlabel('t   [ms]'),ylabel('u(t)   [V]')

title('Ausschnitt des DTMF-Signals fuer die Ziffer 1'),pause



% Spektrum des DTMF-Signals von 0 - 2000Hz

%

y3(1:N)=y1(440:440+N-1);

Y3=fft(y3);

fe=2000; f=0:fa/N:fe; n=round((N/fa)*fe)+1;   % Endfrequenz fe=2000Hz

Y4=Y3(1:n); 

k=sqrt(2)/N; Y5=k*abs(Y4);    % k=Faktor zur Berechnung des Spektrums in Veff

                              %   (siehe Kap.4.7.2 Beispiel 3)

clf,subplot(2,1,1),plot(f,Y5),axis([0 fe -.05 .5]),grid

xlabel('f   [Hz]'),ylabel('|U(f)|   [V]')

title('Spektrum des DTMF-Signals fuer die Ziffer 1')
