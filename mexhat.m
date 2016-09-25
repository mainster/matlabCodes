function [ output_args ] = mexhat(min,max,n )
%MEXHAT Summary of this function goes here
%   Detailed explanation goes here

%t=[min:0.1:max];
%y=(1-t.^2/2).*exp(-(t.^2)/2);
%plot(t,y)
%for k = 1:n
%t=sqrt((x*(k+1)).^2+(y*(k+1)).^2); 

a=3;
b=3;
c=3;

[x,y]=meshgrid(min:.03:max);
t=sqrt(x.^2+y.^2);  
z=(1-t.^2/2).*exp(-(t.^2)/2);
surf(x,y,z*2)

shading flat
hold on

surf(x+a,y+b,z+c)
shading flat

end

