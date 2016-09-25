% Programm (pol5.m) zur Durchf�hrung der Simulation
% einer Zustandsregelung mit I-Anteil und Polplazierung
% f�r ein Servosystem mit Hilfe des Simulink-Modells s_pol5.mdl 
%
% Testaufruf: pol5;


%------- Urspr�ngliches System
%------- Eigenfrequenzen und D�mpfungsfaktoren
w01 = 1;	zeta1 = 0.1;	% Erster Abschnitt
w02 = 0.8;	zeta2 = 0.1;	% Zweiter Abschnitt 
w03 = 0.6;	zeta3 = 0.1;	% Dritter Abschnitt

%------- �bertragungsfunktionen der Abschnitte
zaehler1 = 1;	nenner1 = [1/(w01^2), 2*zeta1/w01, 1];
zaehler2 = 1;	nenner2 = [1/(w02^2), 2*zeta2/w02, 1];
zaehler3 = 1;	nenner3 = [1/(w03^2), 2*zeta3/w03, 1];

%------- �bertragungsfunktion des Systems
my_sys = tf(zaehler3, nenner3)*tf(zaehler2, nenner2)*tf(zaehler1, nenner1);
my_sys1 = ss(my_sys);	% Zustandsmodell
A = my_sys1.a;     B = my_sys1.b;
C = my_sys1.c;     D = my_sys1.d;

%------- Verhalten des nichtkorrigierten Systems:
t = [0:0.1:50];
nt = length(t);

[y,t,x] = lsim(my_sys1, [1,zeros(1,nt-1)], t, zeros(1,6));

figure(1);	clf;
subplot(211), plot(t, x)
title('Sprungantwort, Zustandsvariablen x1, x2, ... x6 ');
grid;	xlabel('Zeit in s');
subplot(212), plot(t, y)
title('Ausgangsvariable y');
grid;	xlabel('Zeit in s');

%------- Bestimmung der R�ckf�hrungsmatrix Kn
%------- f�r das erweiterte Modell
[n,m] = size(A); 
An = [A, zeros(n,1); -C, 0];	% Erweiterte A-Matrix
Bn = [B; 0];			% Erweiterte B-Matrix

%------- Gew�nschte Pole f�r das erweiterte System
p1 = -0.5+j*1;		p2 = conj(p1);  
p3 = -0.3+j*0.6;	p4 = conj(p3);
p5 = -0.2+j*0.4;	p6 = conj(p5);
p7 = -2;

p = [p1; p2; p3; p4; p5; p6; p7];

%%
clf

[pG zP]=pzmap(Gsys{2,1});

S=linmod('s_pol5');
sysA=ss(S.a, S.b, S.c, S.d);

S2=linmod('GalvoModel_servolike_v2_simpli_B');
sysB=ss(S2.a, S2.b, S2.c, S2.d);

[psC zsC]=pzmap(sysA);

[ps zs]=pzmap(my_sys);
hold all;
h=plot(real(ps), imag(ps),'X','Linewidth',2);
%h2=plot(real(psC), imag(psC),'*','Linewidth',2);
h3=plot(real(p), imag(p),'o','Linewidth',2);
grid on;
set(gca,'XLimMode','manual');
set(gca,'YLimMode','manual');

ff=[max([reim(p); reim(ps); reim(pG)])', min([reim(p); reim(ps); reim(pG)])']
ff(1,:)
ff(2,:)

%xlim([min(min(real(ps)),min(real(p)))   max(max(real(ps)),max(real(p)))]);
%ylim([min(min(imag(ps)),min(imag(p)))   max(max(imag(ps)),max(imag(p)))]*1.2);

xlim(fliplr(ff(:,1)))
ylim(fliplr(ff(:,2)))
%%%
xc=get(gca,'XLim');
set(gca,'XLim',[xc(1)*1.2 xc(2)/1.2])
%%

po=nyquistoptions;
po.ShowFullContour='off';

hold all;
nyquist(my_sys,po);
nyquist(sysA,po);
hold off;
legend('strecke')
return





%%
%------- Erweiterte R�ckf�hrungsmatrix
Kn = place(An, Bn, p)
K = Kn(1:n)			    % Teil-R�ckf�hrungsmatrix		
ki = -Kn(n+1)			% I-Gewichtung

%------- Antwort des Servosystems (Aufrif der Simulation)
my_opt = simset('InitialStep', 0.1, 'OutputVariables', 'txy');
[t,x,y] = sim('s_pol5', [0, 50], my_opt);    % SIMULINK 2
  
figure(2);	clf;
subplot(211), plot(t,x);
title('Sprungantwort, Zustandsvariablen des Servosystems');
grid;	xlabel('Zeit in s')
subplot(212), plot(t,y);
title('Ausgang und Fehler');
grid;	xlabel('Zeit in s')

