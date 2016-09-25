function folge3 (nmax)

s=zeros(nmax,1);
a=1;
%s(1)=sqrt(6+1);
s(1)=(1+1/2)
for k=2:1:nmax;
 %   s(k)=sqrt(6+k);
 s(k)=(1+(1/2*k))^k
end

axis ([0 nmax+1 -3 3])

hold on
plot (s,'r*')
%plot (s,'b-');
