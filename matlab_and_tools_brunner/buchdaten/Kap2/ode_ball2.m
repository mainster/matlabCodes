function ode_ball2
% Funktion ode_ball1.m in der ein springender Ball
% mit der ODE-Funktion ode23 simuliert wird
% Es wird die Option Events eingesetzt

tstart = 0;
tfinal = 30;
x0 = [0;30];

refine = 4;
reflexion = 0.86;

my_option = odeset('Events',@ereignis,'Maxstep',1,'Refine',refine);

tout = [];          % Hier werden die Trajektorien akkumuliert
xout = [];

teout = [];         % Hier werden die Ereignisse akkumuliert     
xeout = [];     
ieout = [];

k = 1;
while k == 1
% Lösen bis zum Ereignis Höhe = 0
   [t,x,te,xe,ie] = ode23(@ableitung,[tstart,tfinal],x0,my_option);
   % der Ausgang wird akkumuliert (aus den Abschnitten zusammengesetzt)
   nt = length(t);
   tout = [tout; t];
   xout = [xout; x];
   teout = [teout; te];         % Das Ereignis beim Start wird nicht aufgenommen
   xeout = [xeout; xe];
   
   if length(ie) == 2
       ieout = [ieout, ie];
   end;    
   
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
value(1) = x(1);       % Detektiert Höhe = 0
value(2) = x(2);       % Detektiert Geschwindigkeit = 0

isterminal(1) = 1;     % Stoped die Integration
isterminal(2) = 0;     % kein Stopp
direction(1) = -1;     % Nur fallender Richtung
direction(2) = -1;     % Nur fallender Richtung

%***************************************************
