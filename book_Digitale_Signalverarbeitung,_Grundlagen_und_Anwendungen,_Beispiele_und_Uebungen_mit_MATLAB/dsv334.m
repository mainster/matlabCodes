% M-File  DSV334.M      Version für MATLAB 4.0

%

% Bild 3.18 zu Kap. 3.3.4

%

% Periodischen Frequenzgang eines LTD-Systems darstellen



clear, close, clc



% Koeffizienten des Butterworth-Bandpassfilters



b=[0.25 0 -0.25]; a=[1 -0.93 0.51];





% Frequenzgang berechnen



H=freqz(b,a,256,'whole');

H=[H;H;H;H];              % Frequenzgang periodisieren

N=256; fa=1;  f=-2:fa/N:2-fa/N;





% Amplituden- und Phasengang darstellen



subplot(2,1,1),plot(f,abs(H)),axis([-2 2 -0.2 1.2]),grid

xlabel('f/fa'), ylabel('A(f)')

title('Amplitudengang eines LTD-Systems 2.Ordnung')

set(gcf,'Units','normal','Position',[0 0 1 1])

subplot(2,1,2),plot(f,angle(H)*180/pi),axis([-2 2 -100 100]),grid

xlabel('f/fa'), ylabel('Phi(f)   [Grad]')

title('Phasengang eines LTD-Systems 2.Ordnung')
