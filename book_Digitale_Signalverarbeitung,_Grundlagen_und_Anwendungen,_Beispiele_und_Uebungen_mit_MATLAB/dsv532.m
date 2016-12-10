% M.File DSV532.M      Version für MATLAB 4.0

% 

% Bild 5.8 zu Kap. 5.3.2



clear, close, clc



% Die beiden Messsignale x(n) und y(n) erzeugen

% 

fa=40e3; T=1/fa; N=512;   % fa=40kHz, T=25mikrosec

randn('seed',1), z=randn(1,2*N);

randn('seed',3), ystoer=0.4*randn(1,2*N); y1=z+ystoer; clear ystoer

randn('seed',5), xstoer=0.4*randn(1,2*N); x1=z+xstoer; clear xstoer

[b,a]=butter(4,.5);

y2=filter(b,a,y1); y=y2(353:353+(N-1)); clear y2, clear y1

x2=filter(b,a,x1); x=x2(N+1:2*N); clear x2, clear x1

t=(0:T:(N-1)*T); 

subplot(2,1,1),plot(1e3*t,x),axis([0,10,-4,4]),grid

xlabel('t   [ms]'), ylabel('x(t)'), title('Messsignal Empfaenger 1')

subplot(2,1,2),plot(1e3*t,y),axis([0,10,-4,4]),grid

xlabel('t   [ms]'), ylabel('y(t)')

title('Messsignal Empfaenger 2')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause



% Die beiden Messsignale korrelieren

%

cxy=xcorr(x,y,'unbiased');

tau=(-500*T:T:500*T);,cxy=cxy(12:1012);

clf,subplot(2,1,1),plot(1e3*tau,cxy),axis([-10,10,-0.5,1]),grid

xlabel('tau   [ms]'), ylabel('cxy(tau)')

title('Korrelationsfunktion der beiden Messsignale')
