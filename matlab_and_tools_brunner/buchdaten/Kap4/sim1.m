% Programm (sim_1.m) aus dem mit dem Befehl sim
% das Modell fixed_4.mdl aufgerufen wir

%------- Erste M�glichkeit
[t,x,y] = sim('fixed_4',[0:0.02:10]);

figure(1);      clf;
subplot(211), plot(t,y);
title('Ausgangsvektor y (vom Outport)');
xlabel('Zeit in s');     grid;
legend('Eingang', 'Ausgang', 'Zeit');

subplot(212), plot(t,x);
title('Zustandsvektor x');
xlabel('Zeit in s');     grid;

dimension_t = size(t)
dimension_x = size(x)
dimension_y = size(y)

schrittweite = diff(t(1:10))

%------- Zweite M�glichkeit mit simset und Option 
% 'OutputVariables', 'ty' 

my_options = simset('OutputVariables','ty');
[t,x,y] = sim('fixed_4',[0:0.02:10], my_options);

figure(2);      clf;
plot(t,y);
title('Ausgangsvektor y (vom Outport)');
xlabel('Zeit in s');     grid;
legend('Eingang', 'Ausgang', 'Zeit');

Zustandsvektor = x

%------- Dritte M�glichkeit mit simset und zus�tzlichen Optionen 
% f�r den Solver 

my_options = simset('Solver', 'ode45','MaxStep','auto',...
   'InitialStep','auto','OutputVariables','ty');
[t,x,y] = sim('fixed_4',[0:0.02:10], my_options);

figure(3);      clf;
plot(t,y);
title('Ausgangsvektor y (vom Outport)');
xlabel('Zeit in s');     grid;
legend('Eingang', 'Ausgang', 'Zeit');

Zustandsvektor = x
