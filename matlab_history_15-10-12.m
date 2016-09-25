plot(x,y)
x=0:0.1:2*pi
y=sin(x)
plot(x,y)
y=tan(x)
plot(x,y)
ylim(-10 10)
ylim([-10 10])
plot(x,y)
ylim ([-10 10])
plot(x,y)
y=tan(x)
ylim ([-10 10])
plot (x,y)
ylim ([-10 10])
clear all
x=0:1:10
y=sin(x)
max(y)
min(y)
[ys ind]=sort(y)
ys
ind
ind=find(y<0)
x=0:1:10
y=sin(x);
plot(x,y)
clear all
x0:1:10
x=0:1:10
y=sin(x)
plot(x,y)
ind=find(y<0,6)
plot(x,y)
x(ind)
plot(x,y,'b),x(ind),y(ind),'r*')
plot(x,y,'b',x(ind),y(ind),'r*')
clear all
x=0:1:10
y=sin(x)
plot(x,y)
clear all
x=0:0,1:10
y=sin(x)
plot(x,y)
clear all
x=0:0.1:10
y=sin(x)
plot(x,y)
ind=find(y<0.6)
plot(x,y)
x(ind)
plot(x,y,'b',x(ind),y(ind),'r*')
ind=find(y>0.6)
x(ind)
plot(x,y,'b',x(ind),y(ind),'r*')
ind=find(-0.2<y>0.2)
plot(x,y,'b',x(ind),y(ind),'g*')
x(ind)
plot(x,y,'b',x(ind),y(ind),'g*')
ind=find([0.2 -0.2])
plot(x,y,'b',x(ind),y(ind),'g*')
plot(x,y,'b',x(ind),y(ind),'r*')
clear all
x=0:0.1:10
y=sin(x)
plot(x,y)
x(ind)
ind=find(y>0,6)
x(ind)
plot(x,y,'b',x(ind),y(ind),'r*')
plot(x,y,'b',x(ind),y(ind),'g*')
ind=find(y<0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
ind=find(y>0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
clear all
x=0:0.1:10
y=sin(x)
plot(x,y)
ind2=find(y<0.2 & y>-0.2)
plot(x,y,'r',x(ind),y(ind),'b', x(ind2),y(ind2),'k+')
Clear all
clear all
x=0:0.1:10
y=sin(x)
x(ind)
clear all
x=0:0.1:10
y=sin(x)
x(ind)
ind=find(y<0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
clear all
x=0:0.1:10
y=sin(x)
ind=find(y>0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
ind2=find(y<0.2 & y>-0.2)
plot(x,y,'b',x(ind),y(ind),'r*', x(ind2),y(ind2),'k+')
clear all
x=0:0.1:10
y=sin(x)
ind=find(y>0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
ind2=find(y<0.2 & y>-0.2)
plot(x,y,'b',x(ind),y(ind),'r*', x(ind2),y(ind2),'k+')
plot(x,y,'b',x(ind),y(ind),'rSchnee', x(ind2),y(ind2),'k+')
plot(x,y,'b',x(ind),y(ind),'r*', x(ind2),y(ind2),'k+')
clear all
y=sin(x)
clear all
x=0:0.1:10
y=sin(x)
ind=find(y>0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
ind2=find(y<0.2 & y>-0.2)
plot(x,y,'b',x(ind),y(ind),'r*', x(ind2),y(ind2),'k+')
Test
%-- 15.10.12 08:01 --%
test
sinusschnee
clear
x=0:0.01:10;
f(x>=2)=4
plot(x,f)
jump(1 3 2)
jump(1,3,2)
clear
a=1:2:9
b=1:1:5
a*b
a*b'
a'*b
a'*b'
a.*b
a
b
a.*b
a./b
a./b'
a'./b'
a.^b
a^b
a'.^b'
a'.^b
a.^b'
A=[3 4 -2; -1 2 8; 2 0 -5]
A'
A''
A(1,3
A(1,3)
A
A(1,1:3)
A'(1,1:3)
A(1,1:2)
A(1,2:2)
A(1,2:)
A(1,:)
A(:,:)
A(:,1)
A(:,2)
A(:,2)size(A)
size(A)
t=1:0.1:10;
size(t)
t=1:0.01:10;
size(t)
t=0:0.1:10;
size(t)
rand(size(A))
rand(size(t))
size(rand(size(t)))
zeros(3)
n=[0 0 ]
n=[0,0,0;0,0,0;0,0,0]
eye(6)
eye(6)'
e=eye(6)
e'
A
det(A)
det(n)
inf(n)
inf(A)
inv(A)
inv(n)
A
b=[1 2 3]'
A
b
x=inv(A)*b
x=inv(A).*b
b=[1 2 3]
x=inv(A).*b
x=inv(A)*b
x=inv(A)*b'
b=[1 2 3]'
A*x-b
A=rand(1000);
b=rand(1000)'
x=A*b
x=A*b;
A=rand(100000);
A=rand(10000);
b=rand(10000)'
%-- 15.10.12 08:33 --%
A=[1 2 4; 0 2 4; 1 2 8]
A*det(A)
A.*det(A)
eig(A)
eigen=eig(A)
dum=A-eigen(1)*eye(3)
inv(dum)
det(dum)
if(det(dum))<1
error
endif
end
if(det(dum))<1
print(error)
end
print("error")
print('error')
plot(1 2)
plot(1,2)
print('error')
[V D]=eig(A)
C=[1 i 2; 2 1 3; 1 0 2]
[V D]=eig(A)
[V D]=eig(C)
A=rand(10);
A
A=rand(10)+eye(10)
[V D]=eig(A)
eig(A)
[V]=eig(A)
[D]=eig(A)
[V D]=eig(A)
V'
inv[V]
V
V[:,3]
V[:;3]
V[3]
V(:,3)
D(:,3)
D(:,3)-D(:,4)
V(:,3)-V(:,4)
[V D]=eig(A)
V(:,3)-V(:,4)
V(:,3)+V(:,4)
A=rand(10);
[V D]=eig(A)
clear
A=rand(10)
A=rand(10)+eye(10)
[V D]=eig(A)
V(:,1)
[V D]=eig(A)
v1=V[:,1]
v1=V(:,1)
d1=D(:,1)
d1-v1'
v1
v1'
A*v1
v2=A*v1
A*v1-D(1,1)*V(:1,1)
A*v1-D(1,1)*V(:,1)
A*V[:,2]-D(2,2)*V(:,2)
A*V(:,2)-D(2,2)*V(:,2)
A*V(:,k)-D(k,k)*V(:,k)
k=3
A*V(:,k)-D(k,k)*V(:,k)
k=4
A*V(:,k)-D(k,k)*V(:,k)
clear all
p=[1 2 2]
ein pol wird representiert durch einen vektor mit den koeffizienten des pol
root(p)
roots(p)
roots(-1)
p=[1 2 3 4 5 6]
roots(p)
roots([-1])
roots([-1 1 2])
roots([-1 1 -2])
rp=roots(p)
t=[0:,01;5]
t=[0:.01;5]
t=[0:0.01;5]
t=[0:0.01:5];
y1=exp(rp(1)*t);
y1r=real(y1);
y1i=im(y1);
y1i=imag(y1);
y1i
plot(t,y1r,'r',t,y1i,'b')
rp
y1=exp(rp(3)*t);
y1r=real(y1);
y1i=imag(y1);
plot(t,y1r,'r',t,y1i,'b')
y1=exp(rp(4)*t);
y1r=real(y1);
y1i=imag(y1);
plot(t,y1r,'r',t,y1i,'b')
y1i=imag(y1);
ReIm(rp,1)
clear all
ReIm(rp,1)
p=[1 2 3 4 5 6]
rp=roots(p)
ReIm(rp,1)
ReIm(rp,2)
ReIm(rp,3)
hist(10)
help history
