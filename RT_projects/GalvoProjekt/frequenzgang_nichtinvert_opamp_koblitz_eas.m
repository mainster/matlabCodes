%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @!@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Nichtinvertierender OpAmp
%       Frequenzgang
%       Koblitz, WAS Skript S.34
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Galvoscanner Endstufe LM3886
% Berechnung Frequenzgang bei realem Op mit LM3886
% A0 = 90 ... 115dB          (Open loop Gain)
% GBWP = 2 ... 8MHz (@25°C)     (Gain-Bandwidth-Product)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
par2 = ol.par2;
Rsh = .015;
RL = 3.5;
L = 170e-6;
Cc = 470e-9;
Rc=1
%%%%%%%%%%%%%%%%%%
s=tf('s');
gp = Rsh/(Rsh+RL+s*L)
gc = Rc*1/(s*Cc)
g1 = Rsh/(par2(RL+s*L,  1/(s*Cc+Rc))+Rsh)

bodeplot(gp,ol.optb);
hold all;
bodeplot(gc,ol.optb);
hold all;
bodeplot(g1,ol.optb);
hold off;
legend('gp','gc','g1')
%% v2
gp = Rsh/(Rsh+RL+s*L)

return
%%
Rsh = .015;
RL = 3.5;
L = 170e-6;
%---
% LM3886 db
ft_db = 4e6;         % == GBWP (abgelesen, diagramm)
A0_db = 20^(100/20); % 
fg_db = ft_db/A0_db;
% Subs. 
syms w reals

R2 = RL+j*w*L;
R1 = Rsh;

fg = ft/(1+R2/R1);

Av_non=(1+R2/R1)*1/(1+j*f/fg)



