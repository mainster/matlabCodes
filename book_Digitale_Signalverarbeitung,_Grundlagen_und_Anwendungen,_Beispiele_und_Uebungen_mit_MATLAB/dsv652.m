% M-File DSV6522.M      Version für MATLAB 4.0

%

% Bilder 6.60, 6.66 - 6.69 und 6.73

%

% Simulationen zum Rundsteuerempfaenger und Spektren der Netzspannung

%

% Netzspannung mit einem ueberlagertem Rundsteuerimpuls 

% darstellen.

% Impulsantworten des Cauer-, des Tschebyscheff-I- und des

% Tschebyscheff-II-Bandpassfilters berechnen und darstellen. 

% Netzspannung inklusive Oberschwingungen und ueberlagertem

% Rundsteuersignal generieren und mit einem Antialiasingfilter 

% und dem Tschebyscheff-II-Bandpassfilter filtern.

% Das Ausgangssignal verstaerken, doppelweggleichrichten und

% tiefpassfiltern.

% Das tiefpassgefilterte Signal einem Schwellwert- und anschliessend

% einem Zeitpruef-Detektor zufuehren.

% Spektren der Netzspannung mit und ohne Rundsteuersignal berechnen

% und darstellen.



clear, close, clc



% Netzspannung mit ueberlagertem Rundsteuerimpuls darstellen 



t=-0.016:0.08/1000:0.064; unetz=311*sin(2*pi*50*t-pi/6);

uton=13.72*sin(2*pi*311.66*t).*[zeros(1,200) ones(1,600) zeros(1, 201)];

u=unetz+uton;

subplot(2,1,1),plot(1000*t,u),axis([-16 64 -500 500]),grid

xlabel('t   [ms]'), ylabel('u(t)   [V]')

title('Netzspannung mit einem ueberlagerten Rundsteuerimpuls')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Die Filter-Koeffizienten aller Filter und die beiden Vektoren

% der gemessenen Netzspannung laden



load dsv652





% Cauer-Bandpassfilter,  Abtastfrequenz fa=6400Hz,

% Impulsantwort von -0.05s bis 0.45s berechnen und darstellen



t=-0.05:1/6400:0.45;  x=[zeros(1,320) 1 zeros(1,2880)];  h=filter(bC,aC,x);

subplot(2,1,1), plot(t,h), axis([-.05 .45 -.005 .005]), grid

xlabel('t   [s]'), ylabel('h(n)')

title('Impulsantwort des Cauer-Bandpassfilters')



% Tschebyscheff-I-Bandpassfilter,  Abtastfrequenz fa=6400Hz,

% Impulsantwort von -0.05s bis 0.45s berechnen und darstellen



t=-0.05:1/6400:0.45;  x=[zeros(1,320) 1 zeros(1,2880)];  h=filter(bT1,aT1,x);

subplot(2,1,2), plot(t,h), axis([-.05 .45 -.005 .005]), grid

xlabel('t   [s]'), ylabel('h(n)')

title('Impulsantwort des Tschebyscheff-I-Bandpassfilters'), pause

clf, subplot(2,1,1), plot(t,h), axis([-.05 .45 -.005 .005]), grid

xlabel('t   [s]'), ylabel('h(n)')

title('Impulsantwort des Tschebyscheff-I-Bandpassfilters')



% Tschebyscheff-II-Bandpassfilter,  Abtastfrequenz fa=6400Hz,

% Impulsantwort von -0.05s bis 0.45s berechnen und darstellen



t=-0.05:1/6400:0.45;  x=[zeros(1,320) 1 zeros(1,2880)];  h=filter(bT2,aT2,x);

subplot(2,1,2), plot(t,h), axis([-.05 .45 -.005 .005]), grid

xlabel('t   [s]'), ylabel('h(n)')

title('Impulsantwort des Tschebyscheff-II-Bandpassfilters'), pause





% Netzspannung inklusive maximale Oberschwingungen simulieren



phi1=2*pi*rand;  phi2=2*pi*rand;  phi3=2*pi*rand; phi4=2*pi*rand;

phi5=2*pi*rand;  phi6=2*pi*rand;  phi7=2*pi*rand; phi8=2*pi*rand;

phi9=2*pi*rand;  phi10=2*pi*rand; 

un=(sqrt(2)/150)*[255*sin(2*pi*50*t+phi1)+5.1*sin(2*pi*100*t+phi2)+...

   17.9*sin(2*pi*150*t+phi3)+3.8*sin(2*pi*200*t+phi4)+...

   20.4*sin(2*pi*250*t+phi5)+2.6*sin(2*pi*300*t+phi6)+...

   17.9*sin(2*pi*350*t+phi7)+2.0*sin(2*pi*400*t+phi8)+...

   3.1*sin(2*pi*450*t+phi9)+1.8*sin(2*pi*500*t+phi10)];





% Minimales Rundsteuersignal berechnen



ur=[zeros(1,1600) ones(1,1601)].*[(sqrt(2)/150)*1.08*sin(2*pi*316.66*t)];





% Eingangsspannung mit Antialiasingfilter filtern und darstellen

% (Maximale Eingangsspannung ist normiert auf 1, 

% deshalb wird durch 3 dividiert)



u=((un+ur)/3).*[zeros(1,320) ones(1,2881)];

x=filter(bA,aA,u);

clf, subplot(2,1,1), plot(t,x), axis([-.05 .45 -1 1]), grid

xlabel('t   [s]'), ylabel('x(n)')

title('Eingangssignal des Bandpassfilters')





% Bandpassgefiltertes Ausgangssignal berechnen und darstellen



y=filter(bT2,aT2,x);

subplot(2,1,2), plot(t,y), axis([-.05 .45 -.01 .01]), grid

xlabel('t   [s]'), ylabel('y(n)')

title('Ausgangssignal des Bandpassfilters'), pause

clf, subplot(2,1,1), plot(t,y), axis([-.05 .45 -.01 .01]), grid

xlabel('t   [s]'), ylabel('y(n)')

title('Ausgangssignal des Bandpassfilters')

ta=t(2881:3201);  ya=y(2881:3201);

subplot(2,1,2), plot(ta,ya), axis([.4 .45 -.005 .005]), grid

xlabel('t   [s]'), ylabel('y(n)')

title('Ausschnitt aus dem Ausgangssignal des Bandpassfilters'), pause





% Ausgangssignal mit dem Verstaerkungsfaktor 36 multiplizieren und

% doppelweggleichrichten



ugl=36*abs(y);





% Gleichgerichtetes Signal tiefpassfiltern



v=filter(bTP,aTP,ugl);

clf, subplot(2,1,1), plot(t,v), axis([-.05 .45 -.25 .25]), grid

xlabel('t   [s]'), ylabel('v(n)')

title('Ausgangssignal des Tiefpassfilters')





% Schwellwert-Detektion und Zeitkontrolle



z=zeros(1,3201);  n=0;

for i=1:3201

    if v(i)>0.02

       n=n+1;

    else

       n=0;

    end

    if n>820

       z(i)=1;

    else

       z(i)=0;

    end

end

subplot(2,1,2), plot(t,z), axis([-.05 .45 -1 2]), grid

xlabel('t   [s]'), ylabel('z(n)')

title('Ausgangssignal des Impulsdetektors'), pause





% Spektren der Netzspannung ohne und mit ueberlagertem

% Rundsteuersignal berechnen und darstellen



N=length(netzspg); k=sqrt(2)/N; UdBV=20*log10(k*abs(fft(netzspg)));

fa=6400; deltaf=fa/N; f=0:deltaf:1000;

UdBV=UdBV(1:length(f));

clf, subplot(2,1,1), plot(f,UdBV), axis([0 1000 -60 60]), grid

xlabel('f   [Hz]'), ylabel('U(k)   [dBV]')

title('Spektrum der Netzspannung')

UdBVr=20*log10(k*abs(fft(netzspgr))); UdBVr=UdBVr(1:length(f));

subplot(2,1,2), plot(f,UdBVr), axis([0 1000 -60 60]), grid

xlabel('f   [Hz]'), ylabel('U(k)   [dBV]')

title('Spektrum der Netzspannung mit ueberlagertem Rundsteuersignal')
