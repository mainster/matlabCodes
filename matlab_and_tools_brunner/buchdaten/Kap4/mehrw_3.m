% Programm mehrw_3.m zur Simulation einer mehrfach besetzten Welle
% mit dem Modell mehrw3.mdl

% Lineares Modell der Welle

J = [0.1,0.1,0.1,0.1,0.1];		D = [1.5,1,1,0.75];
r = [0.05, 0.05, 0.05, 0.05, 0.05];

A = zeros(10,10);			A(1:5,6:10) = eye(5,5);

A(6,1) = -D(1)/J(1);		A(6,2) = D(1)/J(1);	
A(7,1) = D(1)/J(2);		    A(7,2) = -(D(1)+D(2))/J(2);
A(7,3) = D(3)/J(2);		    A(8,2) = D(2)/J(3);	
A(8,3) = -(D(2)+D(3))/J(3);	A(8,4) = D(4)/J(3);
A(9,3) = D(3)/J(4);		    A(9,4) = -(D(3)+D(4))/J(4);
A(9,5) = D(4)/J(4);		    A(10,4) = D(4)/J(5);	
A(10,5) = -D(4)/J(5);

for k = 1:5
   A(k+5,k+5) = -r(k)/J(k);
end;
B = [zeros(5,2); 1, 0; zeros(3,2); 0, -1];	
C = eye(10,10); 				D = zeros(10,2);
Cy = zeros(1,10);				Cy(1,10) = 1;
rT = 0.1;		% Parameter des turbulenten Drehmomentes

% -------Aufruf der Simulation
tf = 20; 
x0 = [0 0 0 0 0 1 0 0 0 0];

my_options = simset('OutputVariables',' ','InitialState',x0);
[t,x,y] = sim('mehrw3',[0,tf],my_options);


% -------Darstellungen der Ergebnisse
figure(1);	   clf;	
set(gcf,'DefaultLineLinewidth',1);		
Y1 = [simout(:,1),simout(:,2),simout(:,3),simout(:,4),simout(:,5)];
Y2 = [simout(:,6),simout(:,7),simout(:,8),simout(:,9),simout(:,10)];
subplot(211), plot(tout,Y1);
title('Winkeln');
xlabel('Zeit in s');			grid;
subplot(212), plot(tout,Y2);
title('Winkelgeschwindigkeiten');
xlabel('Zeit in s');			grid;

[V,D] = eig(A);
eigenwerte = diag(D)

