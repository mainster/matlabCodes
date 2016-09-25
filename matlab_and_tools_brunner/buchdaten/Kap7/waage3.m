% Programm (waage3.m) zur Untersuchung des Verhaltens
% einer weglosen Waage mit Hilfe der Simulink-Modelle
% s_waage3.mdl, s_waage4.mdl und s_waage5.mdl
% 
set(0,'DefaultLineLineWidth', 1.2);

global D r kg ks mx mw L R zr1 zr2 zr3 pr1 pr2 pr3 kr
global numd dend        % Optional

%------Parameter der Waage 
R = 7.5;	L = 0; 		% Widerstand und Induktivität
	% der Tauschspule; für die Wurzelortkurven gleich Null
D = 1000;	r = 100;	% Steifigkeit der Wellfeder
				% und Dämpfungsfaktor
mw = 0.5;	mx = 5;		% Masse der Waage und der Last
kg = 5;				% Übertragungskonstante für die 
				% induzierte Spannung
g = 9.81;			% Fallbeschleunigung
ks = 300;			% Übertragungskonstante Sensor

%-------Parameter des Reglers (Kompensationsnetzwerks)
zr1 = -25;	zr2 = -30;	% Nullstellen des Reglers
zr3 = -50;
pr1 = 0;			% Integralwirkung
pr2 = -150;	pr3 = -90;	% Realisierbarkeitspol
kr = 1000;

[As,Bs,Cs,Ds] =linmod('s_waage3');

figure(1);	clf;
[betrag, phase, w] = bode(As, Bs, Cs, Ds, 1);
f = w/(2*pi);
subplot(211), semilogx(f, 20*log(betrag));
title(' Bode-Diagramm des geoeffneten Systems (L=0)');
grid;
La = axis; 	axis([f(1), f(length(f)), La(3), La(4)]);
subplot(212), semilogx(f, phase);
xlabel('Frequenz in Hz');	grid;
La = axis; 	axis([f(1), f(length(f)), La(3), La(4)]);

figure(2);	clf;
%------Null- und Polstellen der geöffneten Strecke ohne 
%------und mit Reglernetzwerk

[z1, p1, k1] = ss2zp(As,Bs,Cs,Ds,1);	% Geöffnete Strecke ohne
[z2, p2, k2] = ss2zp(As,Bs,Cs,Ds,2);	% und mit Reglernetzwerk

subplot(121), plot(real(z1), imag(z1),'o');	hold on
plot(real(p1), imag(p1),'*');
title('z, p ohne Regler (offen)'); 	grid;
rn = [z1; p1];
x_min = 1.2*min(real(rn))-1;	x_max = 1.2*max(real(rn))+1;
y_min = 1.2*min(imag(rn))-1;	y_max = 1.2*max(imag(rn))+1; 
La = axis;		axis([x_min, x_max, y_min, y_max]);
hold off;

subplot(122), plot(real(z2), imag(z2),'o');	hold on
plot(real(p2),imag(p2),'*');
title('z, p mit Regler (offen)');	grid;
rn = [z2; p2];
x_min = 1.2*min(real(rn))-1;	x_max = 1.2*max(real(rn))+1;
y_min = 1.2*min(imag(rn))-1;	y_max = 1.2*max(imag(rn))+1; 
La = axis;		axis([x_min, x_max, y_min, y_max]);
hold off;
%------Wurzelortkurve mit der Verstärkung der Schleife
%------als Parameter
figure(3);
[num2, den2] = zp2tf(z2,p2,k2);

rlocus(num2, den2, [0:ks/4, ks/4:10:ks]);
[rn,k] = rlocus(num2,den2, [0, ks])	% Nur für die Achsen
x_min = 1.2*min(real(rn));	x_max = 1.2*max(real(rn));
y_min = 1.2*min(imag(rn));	y_max = 1.2*max(imag(rn));
x_min = min(x_min);	x_max = max(x_max);
y_min = min(y_min);	y_max = max(y_max);
La = axis;	axis([x_min, x_max, y_min, y_max]);
title(['rlocus  kr = ',num2str(kr),...
               '; zr1 = ',num2str(zr1),...
               '; zr2 = ',num2str(zr2),...
               '; zr3 = ',num2str(zr2),...
               '; pr1 = ',num2str(pr1),...
               '; pr2 = ',num2str(pr2),...
               '; pr3 = ',num2str(pr3)]);
text(10,20,'k = 0 bis 40');

%------Simulation mit kontinuierlichem Regler;
min_step = 1e-4;  	max_step = min_step;
L = 0.6e-3;		% Induktivität der Tauchspule wird hier
			% hinzugefügt
% [t,x,y] = rk45('s_waage4', 0.4, [], [1e-3, min_step, max_step]);
my_opt = simset('OutputVariables','ty');
[t,x,y] = sim('s_waage4',[0,0.4],my_opt);

figure(4);	clf;
subplot(211), plot(t, y(:,1));
title(['Weg der Waage (mx = ',num2str(mx),' kg; kont. Regler)']);
xlabel ('Zeit ins');	ylabel('m');	grid;
subplot(212), plot(t, y(:,2:3));
title(['Elektrische Kraft und Reglerausgang']);
xlabel ('Zeit ins');	ylabel(' ');	grid;

%------Simulation mit diskretem Regler;
zr = [zr1; zr2; zr3];
pr = [0; pr2; pr3];
kr = kr;
Ts = 1e-3;		% Abtastperiode;

%------Diskretisierung des kontinuierlichen Reglers
[numr, denr] = zp2tf(zr, pr, kr);
[numd, dend] = c2dm(numr, denr, Ts);

%[t,x,y] = rk45('s_waage5', 0.4, [], [1e-3, min_step, max_step]);
my_opt = simset('OutputVariables','ty');
[t,x,y] = sim('s_waage5',[0,0.4],my_opt);

figure(5);	clf;
subplot(211), plot(t, y(:,1));
title(['Weg der Waage (mx = ',num2str(mx),' kg; diskreter Regler)']);
xlabel ('Zeit ins');	ylabel('m');	grid;
subplot(212), plot(t, y(:,2:3));
title(['Elektrische Kraft und Reglerausgang']);
xlabel (['Zeit in s (Abtastperiode = ',num2str(Ts),' s)']);
ylabel(' ');	grid;

