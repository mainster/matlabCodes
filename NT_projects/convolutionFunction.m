%the program is developed my Mohendra Roy 
%Bioelectronics division, Department of ECE, Tezpur Central University, INDIA, 
a=input('Please Give The RANGE : '); 
k=-a:+1:+a; 
x=input('The input the x: ') 
h=input('The input the h: ') 
% x=[1 .5 .25] 
% h=[1 .5 .25] 
f=fliplr(h); 
l1=length(x); 
l2=length(h); 
l3=l1+l2-1; 
l4=l2-1; 
y=zeros(1,l3); 
for p=1:1:l3 
p1=p+l4; 
h2=zeros(1,l3); 
h2([p:p1])=f; 
l5=length(h2); 
h1=zeros(1,l5); 
h1([l2:l3])=x 
c1=h1.*h2 
c2=0; 
for i=1:1:l3 
c2=c2+c1([i]); 
end 
sum=c2 
y([p])=sum 
end 
% temp1=length(x); 
% temp2=length(h); 
t=length(y); 
t2=(t-1)/2; 
v=-t2:1:t2; 
subplot(3,1,1),stem(k,x,'*'); 
subplot(3,1,2),stem(k,h,'g*'); 
subplot(3,1,3),stem(v,y,'r*'); 
n=input('The lower limit of X axis is: ') 
m=input('The Upper limit of X axis is: ') 
o=input('The lower limit of Y axis is: ') 
p=input('The Upper limit of Y axis is: ') 
subplot(3,1,1),stem(k,x,'*');axis([n m o p]);grid on 
subplot(3,1,2),stem(k,h,'g*');axis([n m o p]);grid on 
subplot(3,1,3),stem(v,y,'r*');axis([n m o p]);grid on 
% subplot(3,1,1);stem(x); 
% subplot(3,1,2);stem(h); 
% subplot(3,1,3);stem(y);