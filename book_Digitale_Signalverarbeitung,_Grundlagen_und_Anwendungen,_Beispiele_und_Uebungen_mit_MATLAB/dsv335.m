% M-File DSV335.M      Version für MATLAB 4.0

%

% Bilder 3.19 und 3.20 zu Kap.3.3.5

%

% Koeffizienten, Pole, Nullstellen, Amplitudengang und Impulsantwort eines

% Cauer-Bandpassfilters (elliptischen Bandpassfilters) berechnen

% und darstellen.



clear, close, clc



% Filterkoeffizienten, Pole und Nullstellen berechnen



disp(' ')

disp('Filterkoeffizienten des Cauer-Bandpasses 4.Ordnung werden berechnet')

[b,a]=ellip(2,6,40,[.2 .3]); b=2*b, a



disp('')

disp('Pole und Nullstellen werden berechnet und dargestellt')

[z,p,k]=ellip(2,6,40,[.2 .3]);

Zeroes=[abs(z) angle(z)*180/pi]

Poles=[abs(p) angle(p)*180/pi], pause(3)



pn_plot(p,z), xlabel('Re(z)'), ylabel('Im(z)')

title('Pol-Nullstellen-Diagramm einer Uebertragungsfunktion 4.Ord.')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause, close





% Amplitudengang und Impulsantwort berechnen und darstellen



disp('')

disp('Amplitudengang und Impulsantwort werden berechnet und dargestellt')

disp(' '), pause(3)



N=512; fa=1000; [h,f]=freqz(b,a,N/2);

f=0:fa/N:fa/2-fa/N;

subplot(2,1,1),semilogy(f,abs(h)),grid

xlabel('f   [Hz]'), ylabel('A(f)')

title('Amplitudengang eines LTD-Systems 4.Ordnung')

set(gcf,'Units','normal','Position',[0 0 1 1])



x=zeros(100,1); x(1)=1; y=filter(b,a,x);

t=(0:0.001:0.099);

subplot(2,1,2),disploto(1000*t,y),grid

xlabel('t   [ms]'), ylabel('h(n)')

title('Impulsantwort eines LTD-Systems 4.Ordnung')
