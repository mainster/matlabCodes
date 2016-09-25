% Programm in dem die MIMO-Übertragungsfunktion aus 
% Bild 5.1b gebildet wird

h11 = tf([1,-2.3], [1,3]);
h21 = tf([1, 1], [1,0,3]);
h22 = tf([1,5], [1,3.5,7]);

H = [h11, 0; h21, h22]

% ------- Einige Eigenschaften des System h
figure(1);       clf;
bode(H);

figure(2);       clf;
step(H);

% ------- Zweite Möglichkeit
N = {[1,-2.3],0;[1,1],[1,5]};
D = {[1,3],1;[1,0,3],[1,3.5,7]};

H = tf(N,D)
figure(3);       clf;
bode(H);

figure(4);       clf;
step(H);
