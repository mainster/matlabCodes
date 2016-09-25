% M-File DSV612.M      Version für MATLAB 4.0

%

% Bilder 6.3 bis 6.5 zu Kap.6.1.2 

%

% Uebertragungsfunktion eines Butterworth-Bandpassfilters berechnen,

% Pole und Nullstellen bestimmen und das Pol-Nullstellen-Diagramm zeichnen,

% die Impulsantwort und den Frequenzgang bestimmen und darstellen.



clear, close, clc



% Uebertragungsfunktion berechnen und printen



disp(''),disp(''), disp('Vektoren b und a berechnen und printen '), disp('')

[b,a]=butter(1,[.1 .3]), pause





% Pole und Nullstellen berechnen und darstellen



p=roots(a);z=roots(b);

pn_plot(p,z), xlabel('Re(z)'), ylabel('Im(z)')

title('Pol-Nullstellen-Diagramm der Uebertragungsfunktion')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Impulsantwort berechnen und darstellen



y=filter(b,a,[zeros(1,5) 1 zeros(1,20)]); t=-5:1:20;

subplot(2,1,1), disploto(t,y), axis([-5 20 -0.2 0.4]), grid

xlabel('t   [ms]'), ylabel('h(n)')

title('Impulsantwort des LTD-Systems'), pause





% Frequenzgang (Amplituden- und Phasengang) berechnen und darstellen



[H,w]=freqz(b,a,512); f=w*500/pi;

subplot(2,1,1), plot(f,abs(H)), axis([0 500 -0.2 1.2]), grid

xlabel('f   [Hz]'), ylabel('A(f)')

title('Amplitudengang des LTD-Systems')

subplot(2,1,2), plot(f,angle(H)*180/pi), axis([0 500 -100 100]), grid

xlabel('f   [Hz]'), ylabel('Phi(f)   [Grad]')

title('Phasengang des LTD-Systems')
