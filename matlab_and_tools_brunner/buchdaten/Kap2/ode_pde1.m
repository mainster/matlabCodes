function loesung = ode_pde1(T01, Tm)
% Function ode_pde1.m zur Lösung einer Differentialgleichung
% mit partiellen Differentialgleichungen und Anfangs- bzw.Randbedingungen:
% Temperaturverlauf einer schlanken Rippe
% T01 = Fusstemperatur
% Tm = Temperatur des Mediums
% Testaufruf: lo = ode_pde1(100, 25);

lamda = 210;        % Watt/(Km)
alpha = 100;        % Watt/(K m^2)
T0 = T01;           % Fusstemperatur
% Tm = Temperatur des Mediums
A = 56.e-6;         % Querschnitt in m^2
Ur = 60.e-3;        % Querschnittsumfang in m
h = 0.1;            % Länge der Rippe in m
ro = 3e3;           % Aluminiu ca. 3e3 kg/m^3
c_theta = 76;       % Joul/(kg*Grad)

x = linspace(0,h,20);
t = logspace(0,log10(4),10);
m = 0;

loesung = pdepe(m,@pdefun,@icfun,@bcfun,x,t,[],T0,Tm,lamda,alpha,A,Ur,h,ro,c_theta);

% Darstellung
figure(1);      clf;
plot(x, loesung');
title('Temperatur in Grad');
xlabel('x in Meter');   grid;
text(0.05, 85, 't = ');
text(0.065, 70, num2str(t'));

figure(2);      clf;
surf(x,t,loesung);
xlabel('x in m'):    ylabel('t in s');     zlabel('T in Grad');

%*****************************************************
function [c,f,s] = pdefun(x, t, u, DuDx, T0,Tm,lamda,alpha,A,Ur,h,ro,c_theta)
% Definiert die Aufgabe
c = ro*c_theta/lamda;
f = DuDx;
s = -(alpha*Ur/(lamda*A))*(u-Tm);

%*****************************************************
function u0 = icfun(x,T0,Tm,lamda,alpha,A,Ur,h,ro,c_theta)
% Definiert die Anfangsbedingungen
u0 = Tm;

%*****************************************************
function [pl,ql,pr,qr] = bcfun(xl,ul,xr,ur,t,T0,Tm,lamda,alpha,A,Ur,h,ro,c_theta)
% Definiert die Randbedingungen
pl = ul-T0;
ql = 0;
pr = (-alpha/lamda)*(Tm-ur);
qr = 1;
