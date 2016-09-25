%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Timer objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = timer;
set(t1,'ExecutionMode','fixedDelay','Period',1);
t1.StartFcn = @(x,y) disp('Direct start callback');
t1.StopFcn  = @(x,y) disp('Direct stop callback');
t1.TimerFcn = @(x,y) disp('TimerFcn...');

start(t1);