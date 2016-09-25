% Programm in dem ein zeitdiskretes zpk-Modell
% gebildet wird

Z = {-1,[];-0.75,[]};
P = {0.5,[];[-0.8+i*0.5, -0.8-i*0.5], -0.5};
K = [1,0;10,1];

mein_system = zpk(Z,P,K, 0.1)

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(mein_system);

figure(2);       clf;
step(mein_system);

