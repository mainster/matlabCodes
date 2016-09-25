clear all
x=0:0.1:10
y=sin(x)
ind=find(y>0.6)
plot(x,y,'b',x(ind),y(ind),'r*')
ind2=find(y<0.2 & y>-0.2)
plot(x,y,'b',x(ind),y(ind),'r*', x(ind2),y(ind2),'k+')
text(x(ind2), y(ind2), 'glatt')