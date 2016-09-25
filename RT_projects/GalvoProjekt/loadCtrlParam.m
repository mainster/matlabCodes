function paramSet = loadCtrlParam (varagin)
% ret=loadCtrlParam 
%
% Load parameter values for Controlers
if nargin == 0
    sprintf(['\n------------------------------------------\n',...
             'Load old compensator param struct',...
             '\n------------------------------------------\n'])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % List of parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parTmp=struct(...
        'Kp_cc',1,...   % Gain of underlying current controlle
        'dummy',0);   

            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameter values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    paramSet1={
        '10'           % Gain of underlying current controller
        '0'
    };
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % List of parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parTmp=struct(...
        'I_LIM',0,...   % Saturation limit for current controller
        'Kbc',0,...         % Back calculation coeff. PID
        'Kp_cc',1,...   % Gain of underlying current controlle
        'KshM',0,...   % Current shunt monitor Gain
        'dummy',0);   

            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameter values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    paramSet1={
        '20'           % Saturation limit for current controller
        '1e-5'
        '25'        % Gain of underlying current controlle
        '50'        % Gain of shunt monitor
        '0'
    };
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Wertetabelle für simulink- mod. laden
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%    paramSet=cell2struct(Mod2,fieldnames(parTmp));
    paramSet=cell2struct(paramSet1, fieldnames(parTmp));
end