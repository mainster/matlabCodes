function mountain (res,del)
    %TRY Summary of this function goes here
    %   Detailed explanation goes here
    
    x = -2*pi+del:res:2*pi+del;
    y=sin(x);
    ind=find(y>0.6);
    ind2=find(y>-0.2&y<0.2);
    plot(x,y,'g',x(ind),y(ind),'r*',x(ind2),y(ind2),'bp');
end
