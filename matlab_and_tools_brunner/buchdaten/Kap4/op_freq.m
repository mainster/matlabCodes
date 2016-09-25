% Programm zur Darstellung des Frequenzgangs
% eines OPs 

set(0,'DefaultLineLineWidth', 1.2);

f0 = 15;	fT = 3e6;
Ad0 = 2e5;
w0 = 2*pi*15;	tau = 1/w0;

num1 = Ad0; 	den1 = [tau, 1];	
num2 = Ad0;	den2 = [tau, 0];

f = logspace(-1, 8, 200);	w = 2*pi*f;
H1 = freqs(num1,den1,w);	H2 = freqs(num2,den2,w);

figure(1);	clf;
semilogx(f, 20*log10(abs(H1)), f, 20*log10(abs(H2)));
title(['Frequenzgang eines OPs ( f T = ',...
			num2str(fT*1e-6),' MHz )']);
xlabel(' Hz'); 	ylabel('dB');	grid;
text(3e-2, 85, ' Tiefpass');
text(3e1, 125, ' Integrator');
text(2e6, 10, 'f T = 3 MHz');
hold on;	plot(3e6,0,'+');	hold off;
