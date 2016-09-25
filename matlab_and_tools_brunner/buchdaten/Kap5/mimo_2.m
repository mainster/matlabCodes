% Programm in dem die MIMO-Übertragungsfunktion aus 
% Bild 5.2 gebildet wird


z = {2.3,[];-1,-5};
p = {-3,[];[-i*3,i*3],[-1+i*1.7, -1-i*1.7]};
k = [1,0;1,10];
H = zpk(z,p,k)

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(H);

figure(2);       clf;
step(H, 0:0.1:20);

