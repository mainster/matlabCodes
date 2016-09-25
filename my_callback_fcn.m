function my_callback_fcn(obj, event, string_arg)

txt1 = ' event occurred at ';
txt2 = string_arg;

event_type = event.Type;
event_time = datestr(event.Data.time);
    
if strcmp('My stop message',txt2);
    ar=sort(findall(0,'type','figure'));
    set(ar,'WindowStyle','docked');
end

msg = [event_type txt1 event_time];
disp(msg)
disp(txt2)


% t1 = timer;
% set(t1,'ExecutionMode','SingleShot','Period',5, 'StartDelay',1);
% t1.StartFcn = {@my_callback_fcn, 'My start message'};
% t1.StopFcn = {@my_callback_fcn, 'My stop message'};
% t1.TimerFcn = @(x,y)disp('Hello World!');
% 
% start(t1);
