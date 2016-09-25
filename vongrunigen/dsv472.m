% M-File dsv472.m      Version für MATLAB 4.0

%

% Kap.4.7.2 :  Bilder 4.18 bis 4.23 :  Verschiedene Signale und ihre Spektren



clear, close, clc



% Fourier-Transformierte und DFT eines transienten Signals



tau=1; fo=1; T=0.1; fa=10; N=64;

t=-2:0.01:8; wr(1:1001)=zeros(1,1001); wr(201:840)=ones(1,640);

subplot(2,1,1),plot(t,wr,'w'),axis([-2 8 -1 1.5]),grid

set(gcf,'Units','normal','Position',[0 0 1 1])

t=0:.01:6.4; u=exp(-t/tau).*sin(2*pi*fo*t);

hold on,subplot(2,1,1),plot(t,u,'r')

t=0:T:(N-1)*T; u=exp(-t/tau).*sin(2*pi*fo*t);

hold on,subplot(2,1,1),disploto(t,u)

xlabel('t  [s]'),ylabel('u(t), u(n), wr(t)')

title('Transiente Signale mit Rechteckfenster')

f=0:fa/1000:0.5*fa; U=abs((2*pi*fo)./((j*2*pi*f+1/tau).^2+(2*pi*fo)^2));

subplot(2,1,2),plot(f,U,'r'),axis([0 5 -0.1 0.6]),grid

f=0:fa/N:0.5*fa; U=T*abs(fft(u)); U=U(1:(N/2)+1);

hold on,subplot(2,1,2),disploto(f,U)

xlabel('f  [Hz]'),ylabel('|U(f)|, T|U(k)|   [Vs]')

title('Fourier-Transformierte und DFT der transienten Signale'), pause







% Spannung und Spektrum des Lautes "Ah"



fa=50e3; T=20e-6; N=554;

load dsv472    % Im Mat-File DSV472 ist der Laut "Ah" abgespeichert

t=-931*T:T:(2047-931)*T;

clf,subplot(2,1,1),plot(1000*t,Ah),axis([-15 20 -2 3]),grid

wr(1:2048)=zeros(1,2048); wr(931:931+(N-1))=2*ones(1,N);

hold on,subplot(2,1,1),plot(1000*t,wr,'w')

xlabel('t   [ms]'),ylabel('u(t)   [V]')

title('Mikrofon-Spannung des Lautes "A" mit Rechteckfenster')

Ah=Ah(931:931+(N-1));   % Eine Periode aus Ah herausschneiden

% AhSpectr=(1/N)*abs(dft(Ah));          % Wegen der der langen Rechenzeit

					% wurde das Spektrum von Ah mit

					% nebenstehender Befehlszeile schon 

					% berechnet und im Mat-File DSV472

					% unter dem Namen AhSpectr 

					% abgespeichert.

f=0:fa/N:54*fa/N; AhSpectr=AhSpectr(1:55);

subplot(2,1,2),disploto(f/1e3,AhSpectr),axis([0 5 -0.025 .25]),grid

xlabel('f  [kHz]'),ylabel('(1/N)|U(k)|   [V]')

title('Spektrum (DFT) des Lautes "A"'), pause







% Verzerrte Sinusschwingung mit Spektrum, sowie

% Gleichwert, Effektivwerten und Klirrfaktor



  % Verzerrte, zeitkontinuierliche Sinusschwingung zeichnen  fo=1kHz

fo=1e3; fa=64*fo; T=1/fa; tc=-1e-3:T:3e-3;

for i=1:257;

    uc(i)=8*sin(2*pi*fo*(i-1)*T)+0.9;

    if abs(uc(i))<5, uc(i)=uc(i);

    else uc(i)=5*square(2*pi*fo*(i-1)*T);

    end

end

clf,subplot(2,1,1),plot(1000*tc,uc,'c'),axis([-1 2.75 -10 10]),grid



  % Rechteckfenster zeichnen

clear wr; tc=-1e-3:T/16:3e-3; wr=4*(1+square(2*pi*0.25*fo*tc,25));

hold on,subplot(2,1,1),plot(1000*tc,wr,'w')

xlabel('t   [ms]'),ylabel('u(t)   [V]'),pause



  % Eine Periode der abgetasteten, verzerrten Sinusschwingung zeichnen

clc, set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])

N=input ('Anzahl Abtastwerte pro Periode eingeben  (N= 4, 8, ... ,64)  :   ')

fo=1e3; fa=N*fo; T=1/fa; t=0:T:(N-1)*T;

clear u;

for i=1:N;

    u(i)=8*sin(2*pi*fo*(i-1)*T)+0.9;

    if abs(u(i))<5, u(i)=u(i);

    else u(i)=5*square(2*pi*fo*(i-1)*T);

    end

end

set(gcf,'Units','normal','Position',[0 0 1 1])

figure(1),hold on,subplot(2,1,1),disploto(1000*t,u)

title('Verzerrte Sinus-Schwingung, gefenstert und abgetastet')



  % Spektrum, DC-, Effektivwerte und Klirrfaktor berechnen

f=0:fa/N:0.5*fa; U=(1/N)*abs(fft(u)); U=U(1:N/2+1);

U(2:(N/2)+1)=sqrt(2)*U(2:(N/2)+1);      % Effektivwerte der Harmonischen nach

					% Gl.(4.39) berechnen

subplot(2,1,2),disploto(f/fo,U),axis([0 0.5*fa/fo -0.5 5]),grid

xlabel('f  [kHz]'),ylabel('Effektivwerte   [V]')

title('Spektrum (DFT) der verzerrten Sinusschwingung'), pause

close, clc, disp(''),disp('DC-Wert = '), disp(U(1))

Ueff=sqrt(sum(U.^2)); disp('Effektivwert = '), disp(Ueff)   % Gl.(4.40)

Uac=U(2:(N/2)+1); Ueffac=sqrt(sum(Uac.^2));		    % Gl.(4.41)

disp('Effektivwert des Wechselanteils = '), disp(Ueffac)

Ueffaco=U(3:(N/2)+1); Ueffo=sqrt(sum(Ueffaco.^2));	    % Gl.(4.42)

k=Ueffo/Ueffac; disp('Klirrfaktor = '), disp(k)	            % Gl.(4.43)

pack, pause





% Detektion von Sinussignalen



  % Signalausschnitt der Sinussignale mit Rauschen berechnen

clc, disp(''),disp(''),disp(''),disp('')

disp('Detektion von Sinussignalen.   Die beiden einzugebenden')

disp('Frequenzen muessen zwischen 800 und 1200Hz liegen')

disp(''),f1=input('Erste Frequenz eingeben  ')

f2=input('Zweite Frequenz eingeben  ')

Ueff=input('Effektivwert des Rauschens in mV eingeben  ')

T=250e-6; fa=4e3; N=1024;

t=0:T:(N-1)*T; u1=sin(2*pi*f1*t); u2=0.01*sin(2*pi*f2*t); 

u3=0.001*Ueff*randn(1,1024);

u=u1+u2+u3; 



  % Signalausschnitt der Sinussignale mit Rauschen darstellen

tc=0:10e-6:10e-3;

uc=sin(2*pi*f1*tc)+0.001*Ueff*rand(1,1001)+.01*sin(2*pi*f2*tc);

subplot(2,1,1),plot(1000*tc,uc),axis([0 10 -2 2]),grid

xlabel('t   [ms]'),ylabel('u(t)   [V]')

title('Zwei Sinussignale mit Rauschen')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause



  % Spektrum mit Rechteckfenster

f=0:fa/N:0.5*fa; U=20*log10((2/N)*abs(fft(u))); U=U(1:N/2+1);

clf,subplot(2,1,1),plot(f,U),axis([800 1200 -80 0]),grid

xlabel('f  [Hz]'),ylabel('UdBV   [dBV]')

title('Spektrum (DFT) mit Rechteck-Fenster'), pause



  % Spektrum mit Kaiser-Fenster

clc, disp(''), set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])

beta=input('beta-Faktor fuer das Kaiser-Fenster eingeben (z.B. 5.64) : ')

u=u'.*kaiser(N,beta); U=20*log10((2/N)*abs(fft(u))); U=U(1:N/2+1);

figure(1),subplot(2,1,2),plot(f,U),axis([800 1200 -80 0]),grid

xlabel('f  [Hz]'),ylabel('UdBV   [dBV]')

title('Spektrum (DFT) mit Kaiser-Fenster')

set(gcf,'Units','normal','Position',[0 0 1 1])
