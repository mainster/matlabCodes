function [f] = badfib( n )
%BADFIB Summary of this function goes here
%   Detailed explanation goes here
if n>2
    f=badfib(n-1)+badfib(n-2);
else
    f=1;

end

