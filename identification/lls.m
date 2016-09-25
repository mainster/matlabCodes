function [theta] = lls(u, y, n_a, n_b, k)

X = [];
for i=1 : n_a
    X = [X [zeros(i,1); -y(1:length(y)-i)]];
end
for i=k : n_b+k
    X = [X [zeros(i,1); u(1:length(u)-i)]];
end

pseudo = inv(X'*X)*X';
theta = pseudo*y;