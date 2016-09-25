function y = PidFcn(p, w, k, ESUM, E)

esum_1=ESUM(k-1);
   Kp=PID_Kp;
   Ki=PID_Ki;
   Kd=PID_Kd;
   err=w-p;
   e_1=E(k-1);
   
   if err > PID_maxError
       y_p = PID_MAX_INT;
   else
       if e < -PID_maxError
            y_p = -PID_MAX_INT;
       else 
           y_p = Kp * err;
       end
   end
   
   
   if esum_1 > PID_maxSumError
       y_i = PID_MAX_I_TERM;
       eSum_1 = PID_maxSumError;
   else
       if eSum_1 < -PID_maxSumError
           y_i = -PID_MAX_I_TERM;
           eSum_1 = -PID_maxSumError;
       else 
%           y_i = eSum_1 + Ki * err;
            y_i = (eSum_1 + err) * Ki * Ts;
       end
   end
   
   y_d = Kd/Ts * (e - e_1);
   
   y = y_p + y_i + y_d;
   
   if y > PID_UPPER_DAC_LIMIT
       y = PID_UPPER_DAC_LIMIT;
   else 
       if y < PID_LOWER_DAC_LIMIT
           y = PID_LOWER_DAC_LIMIT
       end
   end
   
   ESUM(k) = (sSum_1 + e) * Ki;
   E = err;
   k = k+1;
   
