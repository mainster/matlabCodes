function [t,y,Freib] = ode_stick_slip1
% Funktion ode_stick_slip1 in der ein einfaches Stick_Slip
% Feder-Masse-System mit stiff-ODE-Funktion gelöst wird

%------- Initialisierung des Systems
m = 1;                  % Masse
r = 0.1;                % Dämpfungfaktor
D = 10;                 % Federkonstante

v_band = 1;             % Bandgeschwindigkeit
rgl = 0.01;             % Gleitreibung 
rhf = 2;                % Haftreibung
V0 = 1.2;               % Parameter für exp-Funktion

% Anfangsbedingungen
x10 = 0;              % Weg
x20 = 0;             % Geschwindigkeit
x0 = [x10; x20];

%------- Aufruf des Solvers
my_option = odeset('OutputFcn',@odeplot,'Jacobian',@Fjac);

[t,x] = ode23s(@ableitung,[0, 20], x0, my_option, m, r, D, v_band, rgl, rhf, V0);

% Um die Reibungskraft auch zuerhalten, wird sie hier ermittelt
Freib = -sign(x(:,2)-v_band).*(rgl+(rhf-rgl)*exp(-abs(x(:,2)-v_band)/V0));

%------- Darstellungen
figure(2);      clf;        % Figure 1 wird mit odeplot erzeugt
subplot(211), plot(t, [x(:,2), ones(length(t),1)*v_band],'k');
title('Masse- und Bandgeschwindigkeit');
grid;

subplot(212), plot(t, Freib,'k');
title('Reibungskraft');
La = axis;      axis([La(1:2), -1.2*rhf, 1.2*rhf]);
grid;   xlabel('Zeit in s');

%******************************************************
% Private Funktion, in der die Ableitungen berechnet werden
% ohne externer Kraft
function ableit = ableitung(t, x, m, r, D, v_band, rgl, rhf, V0)

Freib = -sign(x(2)-v_band)*(rgl+(rhf-rgl)*exp(-abs(x(2)-v_band)/V0));
ableit = [x(2); (-D/m)*x(1)+(-r/m)*x(2) + Freib/m];

%******************************************************
% Private Funktion für die Jacobian-Matrix
function J = Fjac(t, x, m, r, D, v_band, rgl, rhf, V0)
J = [0, 1; (-D/m), (-r/m)+ exp(-abs(x(2)-v_band)/V0)*V0/m];








