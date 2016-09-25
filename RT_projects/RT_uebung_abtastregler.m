% RT Zusatz
% Abtastregler  26.11.2014
%
% Vorgabe: Tr <= 0.12s  fs=1/50ms    %OS<=40
%
% %OS <= 40     -->   phires ~ 30deg

RT_labor_faustformel_proc
%   %OS(D)  -->  D = 0.28
%   Knapp aber ist noch system mit geringer Dämpfung
%   --> Tr = 1.8/wn darf angewendet werden
%   --> wn = 15rad/s
%
syms s
s=tf('s')

% C=pid(56,0,11)
% g1=tf(1,[1 1 0])
% 
% G0=C*g1
% bodeplot(G0,ol.optb)
% hold all
% G0=wn^2/(s*(s+2*D*wn))
%
G0ap = 15^2/(s*(s+2*.28*15))
figure(3);
step(feedback(G0ap,1))
figure(4);
bodeplot(G0ap,ol.optb)




