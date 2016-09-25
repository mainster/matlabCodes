% Programm in dem ein Zustandsmodell für ein 
% Feder-Masse-System definiert wird

m = 10;
D = 2;
r = 0.1;

a = [0,1;-D/m,-r/m];
b = [0;1/m];
c = [1,0];
d = 0;

mein_system = ss(a,b,c,d);

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(mein_system);

figure(2);       clf;
step(mein_system);

