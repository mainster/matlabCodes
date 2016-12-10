% M-File DSV461.M      Version für MATLAB 4.0

%

% Bild 4.8 zu Kap.4.6.1

%

% Sinusschwingung mit ihrer DFT (inklusive Enveloppe), wobei die

% Fensterlaenge gleich dem 3.25-fachen der Periodenlaenge ist.



clear, close, clc



% Zeitdiskrete 1Hz-Sinusschwingung



T=1/8; fa=1/T; f0=1; N=26;    % T=0.125s, fa=8Hz,  f0=1Hz,  N=26

t=0:T:(N-1)*T; x=sin(2*pi*f0*t);

xo=[x x x x]; xo=xo(21:85); to=-4:T:4;

subplot(2,1,1),plot(to,xo,':c	'),axis([-4 4 -1.2 1.2])

hold on,subplot(2,1,1),disploto(to,xo),xlabel('t'),ylabel('x(n)')

title('Sinusschwingung:  Fensterlaenge=3.25*Periodenlaenge')





% DFT mit Enveloppe



X=(2/N)*abs(dft(x)); X=X(1:14); f=0:0.5*fa/13:0.5*fa;

subplot(2,1,2),disploto(f,X),axis([0 0.5*fa -0.1 1.1])

x(N+1:512)=zeros(1,512-N);        % Zeropadding (siehe Ende Kap.4.7.1)

absXaw=(2/N)*abs(fft(x)); absXaw=absXaw(1:257); f=0:0.5*fa/256:0.5*fa;

hold on,subplot(2,1,2),plot(f,absXaw,'.m')

xlabel('f'),ylabel('(2/N)|X(k)|'),text(1.1,0.8,'|Xaw(f)|')

title('DFT und Enveloppe der gefensterten Sinusschwingung')

set(gcf,'Units','normal','Position',[0 0 1 1])
