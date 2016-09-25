function [F] = fourierMDB(fhand, varargin)	
%% function [F] = fourierMDB(FHAND, C, S)				@@@MDB
%
% FHAND		handle zur funktion die transformiert werden soll
% c und s sind zum angeben einer anderen Fourier- Definition
%

syms t f w;

if nargin >= 3
	c = varargin{1};
	s = varargin{2};
else
	c = 2*pi;		% die standardfkt fourier(..) verwendet c=1 und s=-1
	s = -1;
end

F1 = c*int(fhand*exp(-1j*s*2*pi*f*t),-inf,inf);		% standard fourier definition

if nargout > 0
	F = F1;
end

end