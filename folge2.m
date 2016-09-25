function folge2 (nmax)
 
s=zeros(nmax,1)
s(1)=42*(3/7)^1
for k=2:1:nmax;
    s(k)=s(k-1)+42*(3/7)^k
end
if s(nmax)>0
  axis ([0 nmax+1 s(1)-0.5 s(nmax)+1])
else
 axis ([0 nmax+1 s(1)-0.5 s(nmax)-1])
end
hold on
plot (s,'r*')
plot (s,'b-')
plot (s,'b-')