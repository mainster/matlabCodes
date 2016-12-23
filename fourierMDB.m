function [F] = fourierMDB(fhand, varargin)	
%% function [F] = fourierMDB(FHAND, A, B)				@@@MDB
%
% FHAND		handle to a function which should be transformed.
% a und b sind zum angeben einer anderen Fourier- Definition:
%
% F(v)=c*int(f(x)*exp(i*s*v*x), -inf, +inf)
% Here, c and s are parameters of the Fourier transform. The fourier 
% function uses c = 1, s = –1.
%
% From Wolfram:
% F(w)=sqrt(abs(b)/(2*pi)^(1-a))*int(f(x)*exp(i*b*f*x), -inf, +inf)
%
%        Inf
%          /
%         |                                  a-1 1/2
% F(v)=   |  f(x) exp(i b v x) dx (|b| (2 pi)   )
%        /
%       -Inf
%
% Some common choices for {a,b} are 
% { 0, 1} (default; modern physics), 
% { 1,-1} (pure mathematics; systems engineering), 
% {-1, 1} (classical physics), 
% {0,-2Pi} (signal processing).
%

global t f w;

if nargin >= 3
	a = varargin{1};
	b = varargin{2};
else
	a = 0;		% die standardfkt fourier(..) verwendet a=1 und b=-1
	b = -2*pi;
end

F = sqrt(abs(b)/(2*pi)^(1-a))*int(fhand*exp(1i.*b.*f.*t), -inf, +inf);

% if nargout > 0
% 	F = F1;
% end

end