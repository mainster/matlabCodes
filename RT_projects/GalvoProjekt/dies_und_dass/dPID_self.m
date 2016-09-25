function [Y] = dPID_self(setPoint, processValue, time, Kp,Ki,Kd,Tf,Ts)
%yd = (Kd*(e - e_1) + Tf * yd_1) / (Tf + Ts);
    yi=[];
    yd=[];
    Y=[];
    e=[];

    e(1) = setPoint(1) - processValue(1);
    yi(1) = Ki*Ts*e(1) - 0;
    yd(1) = (Kd * (e(1) - 0) + Tf * 0) / (Tf + Ts);
    Y(1) = Kp + yi(1) + yd(1);

    for k=2:length(time)
        e(k) = setPoint(k) - processValue(k);
        yi(k) = Ki*Ts*e(k) - yi(k-1);
        yd(k) = (Kd * (e(k) - e(k-1)) + Tf * yd(k-1)) / (Tf + Ts);
        Y(k) = Kp + yi(k) + yd(k);
    end

end