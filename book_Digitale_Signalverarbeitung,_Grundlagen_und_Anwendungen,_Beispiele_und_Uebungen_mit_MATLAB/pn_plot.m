function pn_plot(pol,nst,bereich);

%pn_plot(pol,nst,bereich)   Pol- Nullstellendiagramm  Z - E B E N E

%	falls 'bereich' nicht angegeben ist, wird i.a. -1.2..+1.2 

%       verwendet.

%	L. Arevalo, R. Reng, 301287

% Angepasst fuer MATLAB40 von D.v.Gruenigen am 4.10.93



clf



if nargin < 3, bereich = max( [ abs(pol(:)); abs(nst(:)); 1 ] ); end

if bereich < 1.1, bereich = 1.2; end



t=(0:2*pi/399:2*pi);

kr=cos(t);

ki=sin(t);

[pa,pb] = size(pol);

[na,nb] = size(nst);

if pa == 0	% keine Pole angegeben

   plot(kr,ki,'-',real(nst),imag(nst),'o');

elseif na == 0	% keine Nullstellen angegeben

   plot(kr,ki,'-',real(pol),imag(pol),'x');

else

   plot(kr,ki,'-',real(nst),imag(nst),'o',real(pol),imag(pol),'x');

end

axis( [ -bereich, bereich, -bereich, bereich ] );

axis('equal')
