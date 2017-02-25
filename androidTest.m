%% Acquire and Plot Sensor Data from s7 edge Android(TM) Device
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear m;
passwd='swordfish';
connector off;
pause(.1)

connector('on','PASSWORD', passwd);
fprintf('Mobile connector password is %s\n', passwd);

global mdev;
%%
mdev = mobiledev;
%%
while(~mdev.Connected)
    disp('please connect phone')
    pause(1);
end

%% Connection detected
disp('Connected!')

% Samplerate: get a sample from android device every 1/fs  
fs = 100    % Hz
ts = 1/fs;  % s

mdev.SampleRate=fs;

mdev.AccelerationSensorEnabled = 1;
mdev.Logging = 1;

% Redraw resolution tick = 10*ts
% So acquire 10 samples each tick
tick = 10*ts;

% Run time
tRun = 0;   % s
tEnd = 5;
idx = 0;

while tRun < tEnd
%     fprintf('x: %i\ty: %i\tz: %i\t[m/s^2]\n', m.Acceleration);
    [xyz_, tt_] = accellog(mdev);
    idx = idx + length(tt_);
    
    discardlogs(mdev);
    fprintf('x: %i\ty: %i\tz: %i\t[m/s^2] | %s\n', xyz, tt);
    
    delay(tick);
    tRun = tRun + tick;
end

connector off
return
%%
connector('on','PASSWORD', passwd);
