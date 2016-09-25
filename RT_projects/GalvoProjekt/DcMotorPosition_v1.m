%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% DC Motor Position
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% http://ctms.engin.umich.edu/CTMS/index.php?example=MotorPosition&section=SystemModeling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------%
%    System Modeling     %
%------------------------%
param = {
    'J'     '3.2284e-6' 'kg.m^2'  'moment of inertia of the rotor'     
    'b'     '3.5077e-6' 'Nm.s'    'motor viscous friction constant'    
    'Kb'    '0.274'     'V/rad/s' 'electromotive force constant'
    'Kt'    '0.274'     'Nm/Amp'  'motor torque constant'
    'R'     '4'         'Ohm'     'electric resistance'
    'L'     '2.75e-6'   'H'       'electric inductance'
};
%%
% 
% <<motor.PNG>>
% 

% torque motor moving magnet construction