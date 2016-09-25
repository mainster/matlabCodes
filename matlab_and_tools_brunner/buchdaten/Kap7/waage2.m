% Programm (waage2.m) zur Untersuchung der Wurzel-
% ortskurve einer mit PID-Regler geregelten weglosen 
% Waage mit dem Simulink-Modell s_waage2.mdl
% 
set(0,'DefaultLineLineWidth', 1.2);

global D r kg ks mx mw L R kp ki kd N		% Optional

%------Parameter der Waage 
R = 7.5;	L = 0; 		% Widerstand und Induktivität
				% der Tauschspule
D = 1000;	r = 100;	% Steifigkeit der Wellfeder
				% und Dämpfungsfaktor
mw = 0.1;	mx = 5;		% Masse der Waage und der Last

kg = 5;				% Übertragungskonstante für die 
				% induzierte Spannung
g = 9.81;			% Fallbeschleunigung
ks = 200;			% Übertragungskonstante Sensor

%------Parameter PID-Regler
kp = 100; 	ki = 1000;	kd = 10;	N = 20;

[As,Bs,Cs,Ds] =linmod('s_waage2');

figure(1);	clf;
[betrag, phase, w] = bode(As, Bs, Cs, Ds, 1);
f = w/(2*pi);
subplot(211), semilogx(f, 20*log(betrag));
title(' Bode-Diagramm des geoeffneten Systems ');
grid;
La = axis; 	axis([f(1), f(length(f)), La(3), La(4)]);
subplot(212), semilogx(f, phase);
xlabel('Frequenz in Hz');	grid;
La = axis; 	axis([f(1), f(length(f)), La(3), La(4)]);

figure(2);	clf;
[z1, p1, k1] = ss2zp(As,Bs,Cs,Ds,1)
[z2, p2, k2] = ss2zp(As,Bs,Cs,Ds,2)

subplot(121), plot(real(z1), imag(z1),'o');	hold on
plot(real(p1), imag(p1),'*');
title('z, p ohne Regler (offen)'); 	grid;
rn = [z1; p1];
x_min = 1.2*min(real(rn));	x_max = 1.2*max(real(rn));
y_min = 1.2*min(imag(rn));	y_max = 1.2*max(imag(rn)); 
La = axis;	axis([x_min, x_max, y_min, y_max]);
hold off;

subplot(122), plot(real(z2), imag(z2),'o');	hold on
plot(real(p2),imag(p2),'*');
title('z, p mit Regler (offen)');	grid;
rn = [z2; p2];
x_min = 1.2*min(real(rn));	x_max = 1.2*max(real(rn));
y_min = 1.2*min(imag(rn));	y_max = 1.2*max(imag(rn)); 
La = axis;	axis([x_min, x_max, y_min, y_max]);
hold off;

figure(3);
[num2, den2] = zp2tf(z2,p2,k2);

rlocus(num2, den2, [0:1:ks/4, ks/4:20:ks]);
title(['rlocus ks*(kp+ki/s+kd*s) mit kp = ',num2str(kp),...
                   '; ki = ',num2str(ki),...
                   '; kd = ',num2str(kd),' ;']);
text(10,20,['ks = 0 bis ', num2str(ks)]);

%------Die Null- und Polstellen des geschlossenen Systems
%------für k = 200, wobei k der Faktor der die Parameter des 
%------PID-Reglers ks*(kp+ki/s+kd*s) bestimmt 

[r,k] = rlocus(num2,den2, ks)

f0 = sqrt(real(r(1))^2+imag(r(1))^2) / (2*pi)
			% Eigenfrequenz Nr. 1

f1 = sqrt(real(r(3))^2+imag(r(3))^2) / (2*pi)
			% Eigenfrequenz Nr. 2
% [kx,px] = rlocfind(num2,den2);

