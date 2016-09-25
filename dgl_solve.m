% DGL Solve
% Aufruf:
% ta=0; te=10; y0=[0 1];
% [t,y]=ode23(@fu1,[ta te],y0); 
clear all;
ta=0; te=10; y0=[1 2];
[t,y]=ode23(@fu1,[ta te],y0); 
f1=figure(1);
plot(t,y),grid on;

clear all;
t = [0 10];            % Simulationsdauer 
y0 = [5 0 0 0];     % Anfangsbedingungen [x1 x1p x2 x2p] 
[tsim,xsim] = ode45(@odetest,t,y0); 
f1=figure(1);
plot(tsim,xsim),grid on;
break
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ohne extra m-file für berechnungsvorschrift des systems
%%% http://mo.mathematik.uni-stuttgart.de/inhalt/aussage/aussage713/f=@(t,u) ([u(2); -sin(u(1))+cos(t)/3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_1=@(t,u) ([u(2); -sin(u(1))+cos(t)/3]);
t_range = [0; 40]; u_0 = [0; 0];
[t_steps, u] = ode45(f_1, t_range, u_0);
f1=figure(1);
subplot(211);
plot(t_steps, u);grid on;
subplot(212);
plot(u(:,1),u(:,2));grid on;%%% Trajektorie in der Phasenebene 
break
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_2=@(t,y) ([y(2);-3*y(2)-2*y(1)-cos(t)])
%%% Inhomogenität der DGL 2. Ordnung b(t)=-cos(t)
t_range2 = [0; 10]; y0 = [1; 2];
[t_steps2, y] = ode45(f_2, t_range2, y0);
f1=figure(1);
subplot(211);
plot(t_steps2, y);grid on;
subplot(212);
plot(y(:,1),y(:,2));grid on;%%% Trajektorie in der Phasenebene 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear all;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% f_2=@(t,y) ([y(2);-3*y(2)-2*y(1)+3])
% t_range2 = [0; 10]; y0 = [1; 2];
% [t_steps2, y] = ode45(f_2, t_range2, y0);
% f1=figure(1);
% subplot(211);
% plot(t_steps2, y);grid on;
% subplot(212);
% plot(y(:,1),y(:,2));grid on;%%% Trajektorie in der Phasenebene 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
