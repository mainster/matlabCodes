function paramSet = loadGalvoParam (varargin)
% @@@MDB
global param;

paramVers = 0;
EVALUATE = 0;       % flag for base workspace evaluation at the end

if nargin > 0
    if isnumeric(varargin{1})
        paramVers = varargin{1};
    else
        if isstr(varargin{1})
            if ~strcmpi(varargin{1}, 'desc')
                error 'if param 1 is a str, only DESC is currently valied'
            end
            paramVers=99;
        else
            error 'param 1 must be numeric or string: DESC'
        end
    end
    
    if nargin > 1
        if isstr(varargin{2})
            if strcmpi(varargin{2}, 'eval')
                EVALUATE=1;
            end
        end
    end
end
% ret=loadGalvoParam 
%
% Load parameter values for galvo model v3
%
%   PARAM_SET   Mod_6860
%               Mod_2            
%    if evalin('base','~exist(''param'')')
%    if ~exist('param')

switch paramVers
    case {0, 1, 2, 3}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Liste der Modellparameter (alt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parTmp=struct(...
        'RIN',0,...   % Rotor inertia
        'TRC',0,...   % Torque constant
        'CR',0,...    % Coil resistance
        'CL',0,...    % Coil inductance
        'FR',0,...    % Rotor dynamic friction
        'KTR',0,...   % Torsion bar constant
        'BEM',0,...   % Back electromotive force
        'SHR',0);     % Current shunt resistor

    case {4, 5}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Liste der Modellparameter neu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parTmp=struct(...
        'JR',0,...    % Rotor inertia
        'KMT',0,...   % Torque constant
        'Rc',0,...    % Coil resistance
        'Lc',0,...    % Coil inductance
        'KFR',0,...   % Rotor dynamic friction
        'KTB',0,...   % Torsion bar constant
        'KBM',0,...   % Back electromotive force
        'Rsh',0,...   % Current shunt resistor
        'KPOS1',0);   % position Demod gain (Galvo #1)
    
   case 98
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Liste der Modellparameter  
% 10.12.2016 (WHZ docu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parTmp={...
        'JR',   'Rotor inertia';...
        'KEL',  'Torque constant';...
        'RL',   'Coil resistance';...
        'L',	'Coil inductance';...
        'KFR',	'Rotor dynamic friction';...
        'KTB',	'Torsion bar constant';...
        'KEMF',	'Back electromot. force';...
        'Rsh',	'Current shunt resistor';...
        'KPOS1','PosDemod gain Galvo#1'};

	units={...
        'JR',   'kg*m^2';...
        'KEL',  'Nm/A';...
        'RL',   'Ohm';...
        'L',	'H';...
        'KFR',	'Nm*s/rad';...
        'KTB',	'Nm/rad';...
        'KEMF',	'Vs/rad';...
        'Rsh',	'Ohm';...
        'KPOS1','V/deg'};

    case 99
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Liste der Modellparameter neu mit 
% beschreibung
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parTmp={...
        'JR',   'Rotor inertia';...
        'KMT',  'Torque constant';...
        'Rc',   'Coil resistance';...
        'Lc',	'Coil inductance';...
        'KFR',	'Rotor dynamic friction';...
        'KTB',	'Torsion bar constant';...
        'KBM',	'Back electromot. force';...
        'Rsh',	'Current shunt resistor';...
        'KPOS1','PosDemod gain Galvo#1'};

	units={...
        'JR',   'kg*m^2';...
        'KMT',  'Nm/A';...
        'Rc',   'Ohm';...
        'Lc',	'H';...
        'KFR',	'Nm*s/rad';...
        'KTB',	'Nm/rad';...
        'KBM',	'Vs/rad';...
        'Rsh',	'Ohm';...
        'KPOS1','V/deg'};

    otherwise
        error(['Unknown parameter version: ' num2str(paramVers)]);
        
end
%    end
%    if find( ~cellfun(@exist, param(:)))


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Modell 6860
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mod_6860={
        '6e-8'       % Rotor inertia
        '9.3e-3'     % Torque constant
        '1.5'        % Coil resistance
        '170e-6'     % Coil inductance
        '4e-12'      % Rotor dynamic friction
        '1e-9'          % Torsion bar constant
        '170e-6/(pi/180)'     % Back electromotive force !!! deg --> rad
        '10e-3'     % Current shunt resistor 
    };

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Modell 6860, Galvo #1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mod_6860_No1={
        '6e-8'       % Rotor inertia
        '9.3e-3'     % Torque constant
        '3.5'        % Coil resistance
        '170e-6'     % Coil inductance
        '4e-12'      % Rotor dynamic friction
        '1e-9'          % Torsion bar constant
        '170e-6/(pi/180)'     % Back electromotive force !!! deg --> rad
        '15e-3'     % Current shunt resistor 
        '0.172'     % position Demod gain (Galvo #1)
    };
 %       '100e-3'     % Current shunt resistor 
 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % another CamTech 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mod2={
        '1.25e-8'    % Rotor inertia
        '6.17e-3'      % Torque constant
        '2.79'        % Coil resistance
        '180e-6'      % Coil inductance
        '1e-12'        % Rotor dynamic friction
        '47e-3'      % Torsion bar constant
        '108e-6'       % Back electromotive force
        '10e-3'     % Current shunt resistor 
    };
%        '100e-3'     % Current shunt resistor 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameter für Blockvereinfachung
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    paramSimp={
        'T1', 'CL/CR';
        'K1', 'TRC/CR';
        'T2', 'RIN/FR';
        'K2', '1/FR';
    };

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Wertetabelle für simulink- mod. laden
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%   paramSet=cell2struct(Mod2,fieldnames(parTmp));
    if (paramVers ~= 99) && (paramVers ~= 98)
        if paramVers==5         % Kpos1 param added
            paramSet=cell2struct(Mod_6860_No1,fieldnames(parTmp));
        else
            paramSet=cell2struct(Mod_6860,fieldnames(parTmp));
        end
            
    else
        paramSet(:,1)=parTmp(:,1);
        paramSet(:,2)=Mod_6860_No1;
        paramSet(:,3)=units(:,2);
        paramSet(:,4)=parTmp(:,2);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    evalGalvoParam;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if EVALUATE
        fprintf('Evaluating struct members as single variables in base workspace...')
        fn=fields(paramSet);

        for k=1:length(fn)
            assignin('base', fn{k}, ['param.' fn{k}])
        end
        fprintf('     done!\nwhos?\n\n')
        evalin('base','whos');
    end
end

%%

% 
% JR=evalin('base','param.JR');
% KMT=evalin('base','param.KMT');
% Rc=evalin('base','param.Rc');
% Lc=evalin('base','param.Lc');
% KFR=evalin('base','param.KFR');
% KTB=evalin('base','param.KTB');
% KBM=evalin('base','param.KBM');
% Rsh=evalin('base','param.Rsh');
% 
% 

% RIN=evalin('base','param.RIN');
% TRC=evalin('base','param.TRC');
% CR=evalin('base','param.CR');
% CL=evalin('base','param.CL');
% FR=evalin('base','param.FR');
% KTR=evalin('base','param.KTR');
% BEM=evalin('base','param.BEM');
% SHR=evalin('base','param.SHR');