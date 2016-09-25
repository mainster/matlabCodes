function [A,b,c,d]=rt_uebung2_post_func(K)
% berechnet ZRD als Funktion von K der Aufgabe 2 der Übung 3
s=tf('s');
sys1=(s+2)/(s+1);
sys2=1/(s+3);
sys12=series(sys1,sys2); % Entspricht sys12=sys1*sys2;

h=tf(K);
systot=feedback(sys12,h);    % h nicht k
ztots=cell2mat(systot.num);
ntots=cell2mat(systot.den);

[A,b,c,d]=tf2ss(ztots,ntots);