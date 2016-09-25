function [ gx gy ] = gradientS1(g,x,y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%Vorw?rtsgenommener Differenzenquiotient f?r gradient 
h=0.001;
gx=(g(x+h,y)-g(x,y))./h;
gy=(g(x,y+h)-g(x,y))./h;

end

