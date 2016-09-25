% Postprocessing sys2order.mdl
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

A=[0 1;-2 -3];
b=[0;3];
c=[1,0];
x0=[1;2];
d=0;

J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

A=[0 1;0 -(R*rho+psi)/(R*J)];
b=[0;1/(J*R)];
c=[1,0];
x0=[0;0];
d=0;

% sim('sys2order.mdl');

[A1,b1,c1,d1]=linmod('sys2order');
[nom den]=ss2tf(A1,b1,c1,d1);

sys=tf(nom,den);
f2=figure(2);
subplot(211);
step(sys,10);grid on;
break;

% y''-y'+y=0
% y(0)=0
% y'(0)=1
% Wird in System gew. DGLs überführt
%
% y1'=y2
% y2'=y2-y1
dt=100e-3;

ta=0; te=15; y0=[0 1];
[t,y]=ode23(@fu1,[ta:dt:te],y0); 

% Simulink Simulation
 sim('sys2order.mdl');
t2=simoutTime.signals.values;
%subplot(211);
length(t)
length(t2)
hold on;
plot(t,y(1:end,1),'r');grid on;
plot(t,y(1:end,2),'g');grid on;
plot(t2,outY.signals.values,'b');grid on;
hold off;
legend('y´[t]','y[t]','y[t] simulink')
xlabel('time [s]')
ylabel('out')
%subplot(212);
