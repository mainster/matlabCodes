% This is really a small hack that I wanted to share just to inspire more people to make interactive Matlab graphics. Use it as is or use the code as a template to do more advanced stuff.
% 
% Here is how it works (for a 2-D patch):

% First make the patch ... 
    t = 0:2*pi/20:2*pi; 
    X = 3 + sin(t); Y = 2 + cos(t); Z = X*0; 
    h = patch(X,Y,Z,'g') 
    axis([-10 10 -10 10]); 
% Then make it movable 
    moveit2(h); 
  
%It also works for e.g. pcolor and plot:

% Adjust data to fit hypothesis using the mouse ... :-) 
a = plot(rand(10,10)); 
moveit2(a);