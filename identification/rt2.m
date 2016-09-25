function [rt2] = rt2(y_real, y_est)

n = length(y_real);
rt2 = 1 - sum((y_est-y_real).^2) / sum((y_real-sum(y_real)/n).^2);