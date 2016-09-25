% Programm in dem die MIMO-Übertragungsfunktion aus 
% Bild 5.2 aus Teil-SISO-Systeme gebildet wird

h11 = zpk(2.3,-3,1);
h21 = zpk(-1,[i*3, -i*3],1);
h22 = zpk(-5,[-1+i*1.7, -1-i*1.7],10);

H = [h11, 0; h21, h22]

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(H);

figure(2);       clf;
step(H);

