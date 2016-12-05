% M-File DSV462.M      Version für MATLAB 4.0

%

% Bilder 4.9, 4.11 - 4.13 zu Kap.4.6.2

%

% Rechteckfenster mit Spektrum

% Hanning-Fenster mit Spektrum

% DFT einer Sinusschwingung mit Hanning-Fenster

% Kaiser-Fenster mit Spektrum



clear, close, clc



% Rechteckfenster mit Spektrum   (Fensterlaenge NT=1)



t=-0.5:1/512:1.5-1/512; wr=zeros(1,1024); wr(257:768)=ones(1,512);

subplot(2,1,1),plot(t,wr),axis([-0.5 1.5 -0.2 1.2]),grid

xlabel('t   [NT]'), ylabel('wr(t)')

title('Rechteckfenster')

f=-4:8/512:8; absWR=20*log10(abs(sin(pi*f)./(pi*f)));   % siehe Gl.(4.30)

subplot(2,1,2),plot(f,absWR),axis([-4 8 -100 20]),grid

xlabel('f   [fa/N]'), ylabel('|WR(f)|   [dB]')

title('Betragsspektrum des Rechteckfensters')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Hanning-Fenster mit Spektrum  (Fensterlaenge NT=1)



wh=wr.*(0.5*(1+cos(2*pi*(t-0.5))));

subplot(2,1,1),plot(t,wh),axis([-0.5 1.5 -0.2 1.2]),grid

xlabel('t   [NT]'), ylabel('wh(t)'), title('Hanning-Fenster')

f=-4:8/512:8; absWH=20*log10(abs(0.5*sin(pi*f)./((pi*f).*(1-f.^2)))); %Gl.(4.31)

subplot(2,1,2),plot(f,absWH),axis([-4 8 -100 20]),grid

xlabel('f   [fa/N]'), ylabel('|WH(f)|   [dB]')

title('Betragsspektrum des Hanning-Fensters'), pause







% DFT einer Sinus-Schwingung mit Hanning-Fenster



  % Hanning-gefensterte, zeitdiskrete 1Hz-Sinus-Schwingung



T=1/8; fa=1/T; f0=1; N=26;   % T=0.125s, fa=8Hz, f0=1Hz, N=26

t=0:T:(N-1)*T; x=sin(2*pi*f0*t).*[hanning(26)]';

xo=[x x x x]; xo=xo(21:85); to=-4:T:4;

subplot(2,1,1),plot(to,xo,':c'),axis([-4 4 -1.2 1.2]),hold on

subplot(2,1,1),disploto(to,xo),xlabel('t   [T0]'),ylabel('x(n)')

title('Hanning-gef. zeitdiskrete Sinusschwingung  T0=8T,  NT=3.25T0')



  % DFT mit Enveloppe



X=(2/N)*abs(dft(x)); X=X(1:14); f=0:0.5*fa/13:0.5*fa;

subplot(2,1,2),disploto(f,X),axis([0 0.5*fa -0.1 1.1])

x(N+1:512)=zeros(1,512-N);        % Zeropadding (siehe Ende Kap.4.7.1)

absXaw=(2/N)*abs(fft(x)); absXaw=absXaw(1:257); f=0:0.5*fa/256:0.5*fa;

hold on,subplot(2,1,2),plot(f,absXaw,'.m')

xlabel('f   [f0]'),ylabel('(2/N)|X(k)|'),text(1.15,0.45,'|Xawh(f)|')

title('DFT und Enveloppe der H.-gef. zeitdiskreten Sinusschwingung') ,pause





% Kaiser-Fenster mit Spektrum

% (Siehe Signal Processing Toolbox-Manual Seite 2-79) 



close

N=input('Zweierpotenz N von Abtastpunkten eingeben  (N>=8) :  ')

a=input('Minimale Dämpfung a der Nebenlappen in dB eingeben:  ')

beta=.1102*(a+8.7);

t=-0.5:1/N:(1.5-1/N); wk=zeros(1,2*N); wk(N/2+1:3*N/2)=kaiser(N,beta);

subplot(2,1,1),plot(t,wk),axis([-0.5 1.5 -0.2 1.2]),grid

xlabel('t   [NT]'), ylabel('wk(t)'), title('Kaiser-Fenster')

wk(4096)=0;                    % Zeropadding

absWK=(1/N)*abs(fft(wk));

absWKl=absWK(4096-(4096/N)*4+1:1:4096);		% linke Seite der DFT 

absWKr=absWK(1:(4096/N)*8);			% rechte Seite der DFT

absWK=20*log10([absWKl absWKr]);

f=-4:1/(4096/N):8-1/(4096/N);

subplot(2,1,2),plot(f,absWK),axis([-4 8 -100 20]),grid

xlabel('f   [fa/N]'), ylabel('|WK(f)|   [dB]')

title('Betragsspektrum des Kaiser-Fensters')

set(gcf,'Units','normal','Position',[0 0 1 1])
