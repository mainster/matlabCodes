%%% DGL ss to tf
% y''+2*y'+4*y=2*u
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_3=@(t,y) ([y(2);-1*y(2)-3*y(1)+2])

f_3b=@(t,y) ([-1*y(2)-3*y(1)+2;y(2)])

%%% Inhomogenität der DGL 2. Ordnung b(t)=-cos(t)
t_range2 = [0; 10]; y0 = [0,0];
[t_steps2, y] = ode45(f_3, t_range2, y0);
[t_stepsb, yb] = ode45(f_3b, t_range2, y0);
f1=figure(1);
subplot(211);
plot(t_steps2, y(1:end,1));grid on;hold on;
%plot(t_stepsb, yb(1:end,1),'r');grid on;
hold off;
%axis([-5 2 -2 30])
subplot(212);
plot(y(:,1),y(:,2));grid on;%%% Trajektorie in der Phasenebene 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%