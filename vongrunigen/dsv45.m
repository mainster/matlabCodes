% M-File DSV45.M      Version für MATLAB 4.0

%

% Kap.4.5 :   Bild 4.6 : |W(f)| und |Xaw(f)|

% Kap.4.5 :   Bild 4.7 : |Xaw(f)|

% 

% Betrag der Fourier-Transformierten des Rechteck-Fensters darstellen

% Betrag der Fourier-Transformierten der abgetasteten

%    und rechteckgefensterten Sinusschwingung (1 Periode) berechnen

%    und darstellen

% Betrag der Fourier-Transformierten der abgetasteten

%    und rechteckgefensterten Sinusschwingung (1.25 Perioden) berechnen

%    und darstellen



clear, close, clc



% Betrag der Fourier-Transformierten des Rechteck-Fensters darstellen



f=-1.5:9.5/512:8;  absWf=abs(sin(pi*f)./(pi*f));   % Gl.(4.30)  NT=1

subplot(2,1,1), plot(f,absWf), axis('auto')

xlabel('f   [fa/N]'), ylabel('|W(f)|')

title('Betragsspektrum des Rechteckfensters der Laenge NT')





% Betrag der Fourier-Transformierten der abgetasteten

% und rechteckgefensterten Sinusschwingung (1 Periode) berechnen

% und darstellen



t=0:1/8:7/8; xaw=sin(2*pi*t);

xaw(9:512)=zeros(1,504);       % Zero-padding (siehe Ende Kap.4.7.1)

f=0:1/512:511/512;  absXaw=0.25*abs(fft(xaw));

subplot(2,1,2),plot(f,absXaw)

xlabel('f   [fa]'), ylabel('|Xaw(f)|')

title('Betragsspektrum der abg. und r.gef. Sinusschwingung  NT=T0')

set(gcf,'Units','normal','Position',[0 0 1 1]), pause





% Betrag der Fourier-Transformierten der abgetasteten

%    und rechteckgefensterten Sinusschwingung (1.25 Perioden) berechnen

%    und darstellen



t=0:1/8:9/8; xaw=sin(2*pi*t);

xaw(11:512)=zeros(1,502);       % Zero-padding (siehe Ende Kap.4.7.1)

f=0:1/512:511/512;  absXaw=0.2*abs(fft(xaw));

clf,subplot(2,1,1),plot(f,absXaw)

xlabel('f   [fa]'), ylabel('|Xaw(f)|')

title('Betragsspektrum der abg. und r.gef. Sinusschwingung  NT=1.25T0')
