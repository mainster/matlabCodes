% Programm in dem ein zeitdiskretes zpk-Modell
% gebildet wird

zaehler = {[1,1],0.1;[1, 0.2],[1,0.2]};
nenner = {[1,0.2,0.4],1;[1,-0.3,-0.4],1};

mein_system = filt(zaehler, nenner, 0.1)

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(mein_system);

figure(2);       clf;
step(mein_system);

