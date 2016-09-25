% Discrete Delta
% 
% For our purposes, we are going to define the function as 1 when the argument 
% of the Dirac function is 0, and the output will be 0 for any other value of 
% the input argument. 
% We can define the function having a scalar as an input. For example:

function y = dd1(n)
% Our default value is 0
y = 0; 

% The function is 1 only if the input is 0
if n == 0
    y = 1;
end

