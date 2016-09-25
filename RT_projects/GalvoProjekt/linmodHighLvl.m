function [varargout] = linmodHighLvl (ModelPath, varargin)
%% [varargout] = linmodHighLvl (ModelPath, varargin)        @!@MDB
% 
% SYS:              LTI system object (tf)
% REPRESENTATION:   'NumDen' for standard numerator denominator repres.
%                   'ZeroPole' for zero pole gain repres.
% ROUNDTO:          Numeric value (0 ... 9) 

    ARG2CMP = 'PoleZero;NumDen';
    ARG2CMPc = strsplit(ARG2CMP,';');

    ROUNDTO = 1e6;
    REPRESENTATION = '';
    %
    % bad input arguments error handling
    %
    ERR_STR_ARG2 = ['argument 2 could only be a string containing one of the following keywords: ''',...
                    ARG2CMPc{1} ''', ''',...
                    ARG2CMPc{2} ''''];
    ERR_STR_ARG3 = ['argument 2 needs to be numeric value between 0 and 9'];

    if nargin == 0
            error('no input data?')
    end

    if nargin >= 2
        if ~issystem(varargin{1})
            error('Please input SYSTEM')
        else
            sys=varargin{1};
        end
    end

    if nargin >= 2
        if ~ischar(varargin{2})
            error(ERR_STR_ARG2);
        else
            if ~( strcmpi(varargin{2}, ARG2CMPc{1}) || strcmpi(varargin{2}, ARG2CMPc{2}))
                error(ERR_STR_ARG2);
            end
            REPRESENTATION = varargin{2};
        end
    end

    if nargin >= 3
        if ~isnumeric(varargin{3})
            error(ERR_STR_ARG3);
        else
            if ((varargin{3} < 0) || (varargin{3} > 9))
                error(ERR_STR_ARG3);
            end
            ROUNDTO = varargin{3};
        end
    end
    %%%
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NUR LINMOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set_param( [SIMFILES{1} '/ScopeMain'],'open','off');
%LIMOD={'Galvo_CC_linmod_v30'};
ds='---------------------------------------------------';
LIMOD={  'Galvo_sys_cc_detailed_pwr_v40',...
         'CurrentComp_v20_shunt_fb',...
         'CurrentComp_v20',...
         'GalvoModel_v53',...
         'GalvoModel_v43'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear Gsys;
for selSys=5
    open_system(LIMOD{selSys});
    set_param(LIMOD{selSys}, 'MaxStep', '1e-6');
    clear S;

    S = linmod(LIMOD{selSys});
    S.filename = LIMOD{selSys};
    u_ = strrep(S.InputName, [S.filename '/'], '');
    y_ = strrep(S.OutputName, [S.filename '/'], '');
    S.InputName = u_;
    S.OutputName = y_;

    %GvCCa = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);           % Kompletter Regelkreis 
    statespace = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);           % Kompletter Regelkreis 

    if ((length(S.InputName) > 1) && (length(S.OutputName) > 1))
        sprintf('%s\n\tMIMO system\n%s',ds,ds)
    else
        if length(S.InputName) > 1
            sprintf('%s\n\tMISO system\n%s',ds,ds)
        else
            sprintf('%s\n\tSIMO system\n%s',ds,ds)
        end
    end

    [num, den] = tfdata(statespace);
    if exist('Gsys','var') > 0
        n = length(Gsys);
    else
        n = 1;
    end

    Gsys{n,1} = tf(num , den, 'u', u_, 'y', y_)
    Gsys{n,2} = LIMOD{selSys}
end

f99=figure(99);
delete(findall(f99,'type','line'));

leg=[];
length(Gsys(:,1))
for k=1:length(Gsys(:,1))
    step(Gsys{k,1})
    leg = [leg sprintf('%s:',Gsys{k,2})]
    hold all;
end
hold off;

legend(strsplit(leg(1:end-1),':'))
%end
return

syms Kp Ki Kd N p
pid=Kp+Ki/p+Kd*N/(1+N/p);
Kp=1.7;Ki=0.2;Kd=-1.26;N=0.1781;
PID=sym2tf(eval(pid))

loop=feedback(PID*GvCCb(2),1);
s1=balred(loop,1);
kb=1/pole(s1)


end