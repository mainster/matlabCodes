%%
%d %% Dimension
%n %% n-ter Einheitsvektor
d=[1:3];
n=1;

% so:
einh = [zeros(1,n-1) 1 zeros(1,d-n)]'
% oder so:
(1:d==n)'

