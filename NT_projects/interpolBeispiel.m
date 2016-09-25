clc; 
close all; 
clear all; 

% Stützstellen 
xs = [0, 35, 75, 110, 150]; 
ys = [20, 0, -50, 40, 20]; 
xs=[0:1:7];
ys=sin(xs);

% Interpolationspunkte 
xi = 0:0.5:(max(xs)); 

% Interpolation 
yi = interp1(xs, ys, xi); 

% Plotten 
plot(xs, ys, 'or') 
hold on 
plot(xi, yi, '.b') 
axis equal