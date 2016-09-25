% Programm dynamik2.m zur Untersuchung der Dynamik von LTI-Modellen
% Die speziellen Funktionen für SS-Modelle

% ------- SS-Modell (F14 Flugzeug)
a = [-0.0558 -0.9968  0.0802 0.0415;
      0.598  -0.115  -0.0318 0;
     -3.05    0.388  -0.465  0;
      0       0.0805  1      0];

b = [0.0073 0;
    -0.475  0.0077;
     0.153  0.143;
     0      0];

c = [0 1 0 0;
     0 0 0 1];

d = [0 0;0 0];

sys = ss(a,b,c,d)

% ------- Balance
sys_neu = ssbal(sys)

figure(1);      clf;
subplot(121), pzmap(sys);
subplot(122), pzmap(sys_neu);

figure(2);      clf;
bode(sys, sys_neu);

figure(3);      clf;
step(sys, sys_neu);

% ------- Steuerbarkeitsmatrix
C_s = ctrb(sys_neu)
rank_C_s = rank(C_s)

% ------- Beobachtbarkeitsmatrix
O_s = obsv(sys_neu)
rank_O_s = rank(O_s)






