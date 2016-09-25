% M-File  DSVL31c.M      Version für MATLAB 4.0

%

%

% Loesung zu Kap.3 Aufgabe No.1 c)

%

% Zeitdiskretes Signal generieren





clear, close, clc



T=.001; Xdach=3.5; tau=.008; f0=83; t=-0.005:T:.04;

tlinks=-0.005:T:0-T; trechts=0:T:.04;





% Signalvektor x berechnen



xlinks=zeros(size(tlinks));

xrechts=Xdach*exp(-trechts/tau).*cos(2*pi*f0*trechts);

x=[xlinks xrechts];





% Signalvektor darstellen



subplot(2,1,1),disploto(1000*t,x),axis([-5 40 -2 4]),grid

xlabel('n  oder  Zeit in Millisekunden'), ylabel('x(n)')

title('Zeitdiskretes Signal')

set(gcf,'Units','normal','Position',[0 0 1 1])
