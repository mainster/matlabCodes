% M-File  DSV133.M

%

% Bild 1.7  zu DSV Kap. 1.3.3

%

% 2 simulierte Mikrofonsignale darstellen und 

% die dazugehoerige Kreuzkorrelationsfunktion berechnen.

%

% fa=20kHz, T=0.05ms, Anzahl Abtastwerte = 401, daraus ergibt sich eine 

% Fensterlaenge von 20ms.

T=.05e-3;

 

% y1 und y2 sind die beiden simulierten Mikrofonsignale.

% y2 ist gegenÅber y1 um 60 Abtastwerte verzoegert, was einem Delay 

% von 3ms entspricht.

rand('normal'), x=rand(801,1);

[b1,a1]=butter(4,.4); [b2,a2]=butter(4,.3);

x1=x+0.1*rand(801,1); y1=filter(b1,a1,x1); y1=y1(401:801,:);

x2=x+0.1*rand(801,1); y2=filter(b2,a2,x2); y2=0.25*y2(341:741,:);



% y1 und y2 darstellen

t=(0:T:400*T);

clc,clg,axis([0,20,-2.5,2.5]), subplot(211), plot(1000*t,y1),grid

xlabel('t   [ms]'), ylabel('u1(t)   [V]')

title('Mikrofonsignal 1')

axis([0,20,-0.5,0.5]), subplot(212), plot(1000*t,y2),grid

xlabel('t   [ms]'), ylabel('u2(t)   [V]')

title('Mikrofonsignal 2'),pause



% Kreuzkorrelationsfunktion z berechnen und darstellen 

z=xcorr(y2,y1,'unbiased');

tau=(0:T:200*T); z=z(401:601,:);

clc,clg,axis([0,10,-0.05,0.1]), subplot(212),plot(1000*tau,z),grid

xlabel('tau   [ms]'), ylabel('cu1u2   [V^2]')

title('Korrelationsfunktion der beiden Mikrofonsignale')
