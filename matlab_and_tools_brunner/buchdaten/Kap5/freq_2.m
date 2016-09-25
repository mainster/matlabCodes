% Programm freq_2.m in dem die Frequenzfunktionen mit eigenen
% Darstellungen angewandt werden

clear
% ------- LTI-Systeme
sys1 = tf(1,[1,1]);
sys2 = tf([0.1,1],[1,0.5,1]);
sys3 = tf(1,[1,0.2,1]);
sys4 = zpk([],[-1,-0.5+j*0.2,-0.5-j*0.2],1);
              
              
% ------- Darstellung der Nichols-Diagramme              
figure(1);      clf;
subplot(221), nichols(sys1);
ngrid
subplot(222), nichols(sys2);
ngrid
subplot(223), nichols(sys3);
ngrid
subplot(224), nichols(sys4);
ngrid

% ------- Bestimmung der Amplituden- und Ohasenreserve
figure(2);      clf;
margin(sys1);
figure(3);      clf;
margin(sys2);
figure(4);      clf;
margin(sys3);
figure(5);      clf;
margin(sys4);