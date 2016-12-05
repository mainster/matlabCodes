function [ f ] = fibonacci_hasen( max )
% Bildungsgesetz Fibonacci Zahlen
% 
f=[1 1]; n=1;
while f(n) + f(n+1)<max
    f(n+2)=f(n)+f(n+1);
    n=n+1;
end;
sizef=size(f);
t=1:1:length(f);
figure
plot(t,f)
end

