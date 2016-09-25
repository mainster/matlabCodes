function [] = ReIm(rp, n)
%UNTITLED Summary of this function goes here
% Detailed explanation goes here
% p=[1 2 3 4 5 6]
% rp=roots(p)
% ReIm(rp,1)
% ReIm(rp,2)
% ReIm(rp,3)
t=0:0.01:3;
y1=exp(rp(n)*t);
y1r=real(y1);
y1i=imag(y1);
figure
plot(t,y1r,'r',t,y1i,'b')
end

