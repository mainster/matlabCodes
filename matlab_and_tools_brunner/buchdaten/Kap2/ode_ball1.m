function ode_ball1
% Funktion ode_ball1.m in der ein springender Ball
% mit der ODE-Funktion ode23 simuliert wird
% Es wird die Option Events eingesetzt

tstart = 0;
tfinal = 30;
x0 = [0;30];

refine = 4;
reflexion = 0.86;

my_option = odeset('Events',@ereignis,'Maxstep',1,'Refine',refine);

tout = [];          % Hier werden die Bahnen akkumuliert
xout = [];

teout = [];         % Hier werden die Ereignisse akkumuliert     
xeout = [];     
ieout = [];

k = 1;
while k == 1
% Lösen bis zum ersten Ereignis
   [t,x,te,xe,ie] = ode23(@ableitung,[tstart,tfinal],x0,my_option);
   % der Ausgang wird akkumuliert (aus den Abschnitten zusammengesetzt)
   nt = length(t);
   tout = [tout; t];
   xout = [xout; x];
   teout = [teout; te];         % Das Ereignis beim Start wird nicht aufgenommen
   xeout = [xeout; xe];
   ieout = [ieout, ie];
   
   x0(1) = 0;
   x0(2) = -reflexion*x(nt,2);
   if t(nt) ~= tfinal
       tstart = t(nt);
   else
       k = 0;
   end;    
end;

% Darstellung
plot(tout, xout);           % Höhe und Geschwindigkeit
title('Hoehe und Geschwindigkeit')
xlabel('Zeit in s');    grid on;

hold on
plot(teout,xeout,'o');      % Stellen der Ereignisse
hold off

%***************************************************
function ableit = ableitung(t,x)
ableit = [x(2); -9.8];

%***************************************************
function [value, isterminal, direction] = ereignis(t,x)
% Detektiert wenn die Höhe durch null geht in fallender Richtung
% und stopt die Integration
value = x(1);       % Detektiert Höhe = 0
isterminal = 1;     % Stoped die Integration
direction = -1;     % Nur fallender Richtung

%***************************************************
