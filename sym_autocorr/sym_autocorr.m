% SYM_AUTOCORR Autocorrelation of a symbolic vector
%  [V, VCORR] = SYM_AUTOCORR(SEQLEN), where SEQLEN>=1 is the length of the
%  sequence whose autocorrelation is to be calculated. V is a symbolic
%  vector of length SEQLEN that the function constructs and VCORR is the
%  symbolic autocorrelation vector.
%
%  The autocorrelation is calculated by first constructing the outer
%  product matrix and then summing over each diagonal.

function [v, vcorr] = sym_autocorr(seqLen)

v = sym('var', [seqLen,1]);
N = numel(v);
vcorr = [];
outerProd = v*v';
for i = -N+1:N-1
    vcorr = [vcorr; sum(diag(outerProd, i))];
end