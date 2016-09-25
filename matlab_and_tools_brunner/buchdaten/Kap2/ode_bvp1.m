function loesung = ode_bvp1(T01, Tm)
% Function ode_bvp1.m zur Lösung einer Differentialgleichung
% mit Randbedingungen: Temperaturverlauf einer schlanken Rippe
% T01 = Fusstemperatur
% Tm = Temperatur des Mediums
% Testaufruf: lo = ode_bvp1(100, 15);

global T0 h

lamda = 210;        % Watt/(Km)
alpha = 100;        % Watt/(K m^2)
T0 = T01;           % Fusstemperatur
% Tm = Temperatur des Mediums
h = 0.1;            % Länge der Rippe in m
A = 56.e-6;         % Querschnitt in m^2
U = 60.e-3;         % Querschnittsumfang in m

solinit = bvpinit(linspace(0,h,20), @tempinit);

loesung = bvp4c(@ableitung, @bcfun, solinit,[],T0,Tm,lamda,alpha,A,U,h);

% Darstellung
figure(1);      clf;
subplot(211), plot(loesung.x, loesung.y(1,:));
title('Temperatur in Grad');
%xlabel('x in Meter');   
grid;

subplot(212), plot(loesung.x, loesung.y(2,:));
title('Temperatur-Gradient in Grad/m')
xlabel('x in Meter');   grid;

%*****************************************************
function ableit = ableitung(x, y, T0, Tm, lamda, alpha, A, U, h)
ableit = [y(2); (alpha*U/(lamda*A))*(y(1)-Tm)];

%*****************************************************
function res = bcfun(ya, yb, T0, Tm, lamda, alpha, A, U, h)
res = [ya(1)-T0; yb(2)-(alpha/lamda)*(Tm-yb(1))];

%*****************************************************
function yinit = tempinit(x)
global T0 h
yinit = [T0*x/h; 0];
