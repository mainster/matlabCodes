function [ verteilung ]= sumBernoulli (p , n)
%
% Verteilung der Summe n unabhängiger Bernoulli-verteilter
% Zufallsvariablen und Plot als Balkendiagramm
vrtBernoulli =[1-p,p];

% Schleife zur Erzeugung der Summenverteilung
verteilung = vrtBernoulli ;
for k=2:n
   verteilung = conv( vrtBernoulli , verteilung );
end 
