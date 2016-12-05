% M-File DSV422.M      Version zu MATLAB 4.0

%

% Bild 4.2 zu Kap.4.2.2

%

% Abtastwerte der Impulsantwort eines analogen Tiefpassfilters zeichnen,

% diese Abtastwerte einer DFT unterziehen und anschliessend davon 

% Betrag und Phase darstellen.



clear, close, clc



% 64 Punkte der Impulsantwort eines TP-Filters berechnen und darstellen



zeta=0.5;  omegao=sqrt(1-zeta^2)*2*pi;

t=(0:1/64:1-1/64);

x=10*exp(-zeta*2*pi*t).*sin(omegao*t)/omegao;

subplot(2,1,1),disploto((0:63),x),axis([0 64 -0.5 1.5]),grid

title('Abtastwerte eines gedaempften Sinussignals')

xlabel('n'),ylabel('x(n)')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Betrag und Winkel der DFT berechnen und darstellen



X=fft(x);  Xabs=abs(X);  Xangle=(180/pi)*angle(X);

clf,subplot(2,1,1),disploto((0:63),Xabs),axis([0 64 -2.5 20]),grid

title('Betrag der DFT von x(n)'), xlabel('k'),ylabel('|X(k)|')

subplot(2,1,2),disploto((0:63),Xangle),axis([0 64 -250 250]),grid

title('Winkel (Argument, Phase) der DFT von x(n)')

xlabel('k'),ylabel('arg[X(k)]   [Grad]')
