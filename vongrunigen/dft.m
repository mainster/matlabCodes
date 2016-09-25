function y = dft(x)

%DFT	DFT(X) is the discrete Fourier transform of vector X.

%	See also IDFT, FFT, IFFT.



%	J.N. Little 11-25-85

%	Copyright (c) 1985, 1986 by the MathWorks, Inc.



n = max(size(x));

Wn = exp(-sqrt(-1)*2*pi/n);

y = x;

N = 0:n-1;

for k=1:n

	y(k) = Wn.^((k-1)*N) * x(:);

end


