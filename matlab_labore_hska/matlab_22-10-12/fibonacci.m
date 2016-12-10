f=[1 1]; n=1;
while f(n) + f(n+1)<150
    f(n+2)=f(n)+f(n+1);
    n=n+1;
end;
f