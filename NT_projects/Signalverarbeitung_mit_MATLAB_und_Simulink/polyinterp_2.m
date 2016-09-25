function [v, l] = polyinterp_2(x,y,u)
%POLYINTERP  Polynomial interpolation.
%   v = POLYINTERP(x,y,u) computes v(j) = P(u(j)) where P is the
%   polynomial of degree d = length(x)-1 with P(x(i)) = y(i).

% Use Lagrangian representation.
% Evaluate at all elements of u simultaneously.

n = length(x);
v = zeros(size(u));
l = zeros(n,length(u));
for k = 1:n
   w = ones(size(u));
   for j = [1:k-1, k+1:n]     % es fehlt j = k
      w = (u-x(j))./(x(k)-x(j)).*w;
   end
   v = v + w*y(k);
   l(k,:) = w;
end