%% ********** Newton-Verfahren zur bestimmung von Nullstellen ********* %%
clc
maxiter=10;
x0=0;

x(1)=1;
tol=1e-5;

for i=1:maxiter
    x(i+1)=x(i)-(f(x(i))/(ableitung(@fun,x(i))));
    if (abs(f(x))<tol)
        disp('Fertig')
    end;
    if (i==maxiter)
        disp('Break, max. Iterationen erreicht')
    end;
end;
