% RT Reference, Control sys tools
%
oldLines=findall(0,'type','line');    % Inhalte der letzten plots löschen, figure handle behalten
delete(oldLines);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deconvolution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If
u = [1   2   3   4]
v = [10   20   30]

% the convolution is
c = conv(u,v)

% Use deconvolution to recover u:
[q,r] = deconv(c,u)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% residueConvert between partial fraction expansion and polynomial
% coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% [r,p,k] = residue(b,a)
% [b,a] = residue(r,p,k)
%
% b: num polynom
% a: den polynom
%
num=[1 5 3];
den=[1 3 2 0];
[r,p,k] = residue(num,den)

sys1=tf(num,den);
[r,p,k] = residue(sys1.num{1},sys1.den{1})
sprintf('%d+%.2f/(s+%d)+%.2f/(s+%d)+%.2f/(s+%d)',k,r(1),-p(1),r(2),-p(2),r(3),-p(3))










