%Pade-Annäherung von Verspätungen

% Pure Verspätung
T_delay = 1;
sys = tf(1,1,'iodelay',T_delay);

figure(1);     clf;
for k = 1:6,
    sysr = pade(sys, k);
    step(sysr, 3);
    hold on;
end;
grid;
