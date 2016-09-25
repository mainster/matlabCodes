% Regelungsnormalform
%
clear all;

s=tf('s');

p=1/(s+1)-1/(s+2);

f1=figure(1);

SUB=221;

subplot(SUB);
step(1/(s+1),10);grid on;
hold on;
step(-1/(s+2),10);grid on;
hold off;

subplot(SUB+1);
step(p,10);grid on;

subplot(SUB+2);
t=[0:0.1:10];
p1=1-exp(-t)+exp(-2*t)/2;
plot(t,p1); grid on;

subplot(SUB+3);
pzmap(s*p); 
break;
subplot(SUB+3);
step((1/0.06)/(s+4)^2,10);grid on;

