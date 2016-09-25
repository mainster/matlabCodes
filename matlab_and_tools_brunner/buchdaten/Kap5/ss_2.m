% Programm in dem ein Descriptor-Zustandsmodell für ein 
% Feder-Masse-System definiert wird

m = 10;
D = 2;
r = 0.1;

a = [0,1;-D,-r];
b = [0;1];
c = [1,0];
d = 0;
e = [1,0;0,m];

mein_system = dss(a,b,c,d,e);

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(mein_system);

figure(2);       clf;
step(mein_system);

