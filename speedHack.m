% http://undocumentedmatlab.com/blog/plot-performance
%%%

delete(get(f1,'Children'));

x=0:0.02:10; y=sin(x);
clf; cla; tic;


plot(x(1),y(1)); 
hold on; legend data;

for idx = 1 : length(x); 
    plot(x(idx),y(idx)); 
end;

toc




return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=0:0.02:10; y=sin(x);
clf; cla; tic;

drawnow; 

plot(x(1),y(1)); 
hold on; legend data;

for idx = 1 : length(x); 
    plot(x(idx),y(idx)); 
    drawnow; 
end;

toc
 
%Elapsed time is 21.583668 seconds.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return
%Performance hack #1: manual limits

x=0:0.02:10; y=sin(x);
clf; cla; tic; 

drawnow; 

plot(x(1),y(1)); 
hold on; legend data;
 
xlim([0,10]); ylim([-1,1]);  % static limits
 
for idx = 1 : length(x); 
    plot(x(idx),y(idx)); 
    drawnow; 
end;

toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%Elapsed time is 16.863090 seconds.