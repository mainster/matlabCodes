%%% Matlab Berechnungen 
% Nominelle Bauteilwerte 
R=100; 
L=10e-3; 
C=1.5e-9; 
%--------------------------------------------------------------- 
%%% Tatsaechliche Bauteilwerte 
R_ = 137.5; 
L_ = 9.819e-3; 
C_ = 1.519e-9; 
%--------------------------------------------------------------- 
s = tf('s'); 
Z1 = R + 1/(s*C) + s*L; 
Z2 = R_ + 1/(s*C_) + s*L_; 

G1 = 1/Z1; 
G2 = 1/Z2; 

subplot(2,1,1); 
nyquist(G1) 
grid on; 
subplot(2,1,2); 
nyquist(G2) 
grid on; 