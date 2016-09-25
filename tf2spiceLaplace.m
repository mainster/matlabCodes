function spiceLap = tf2spiceLaplace(varargin)
%% spiceLap = tf2spiceLaplace(varargin)     @@@MDB
% 
% tf2spiceLaplace returns a LTspice conform transfer function
% representation of the given SYS. The laplace string is fed into
% clipboard. After function call, paste clipboard as LTspice argument to a
% voltage-controlled- voltage source in LTspice netlist.
% 
% SYS:              LTI system object (tf)
% REPRESENTATION:   'NumDen' for standard numerator denominator repres.
%                   'PoleZero' for zero pole gain repres.
%                   ----------------------------------------------
%                   ----------------------------------------------
%                   Bugy laplace string if 'PoleZero' is selected
%                   ----------------------------------------------
%                   ----------------------------------------------
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

    if nargin >= 1
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
    
    syms s;

%     switch lower(ROUNDTO)
%     end
    ZEROS_STR = [];
    POLES_STR = [];
    
    switch lower(REPRESENTATION)
        case {'polezero'}
            [zs ps ks]=zpkdata(sys); 
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!            
% Ja nicht, info ueber die Zuordnung eventueller Nullstellen geht verloren            
%             if iscell(ps)   ps=cell2mat(ps);     end
%             if iscell(zs)   zs=cell2mat(zs);     end
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!            
            
            spiceLap = sprintf(strrep(  'laplace=%.__e*( ZEROS )/( POLES )',...
                                        '__',num2str(ROUNDTO) ),...
                            round(ks*10^(ROUNDTO))/(10^(ROUNDTO)) );
            
            if isempty(find(zs{1}))    % no zeros
                ZEROS_STR = '1';
            else
                for k=1:length(cell2mat(zs))
                    ZEROS_STR = [ZEROS_STR sprintf(strrep('(s-%.__e)','__',num2str(ROUNDTO)),...
                                 round(zs{1}(k)*10^(ROUNDTO))/(10^(ROUNDTO)) )];
                end
            end
            
            if isempty(find(ps{1}))    % no poless
                POLES_STR = '1';
                disp('No poles???');
            else
                for k=1:length(cell2mat(ps))
                    POLES_STR = [POLES_STR sprintf(strrep('(s-%.__e)','__',num2str(ROUNDTO)),...
                                 round(ps{1}(k)*10^(ROUNDTO))/(10^(ROUNDTO)) )];
                end
            end
            
            ret = strrep({ZEROS_STR, POLES_STR},'--','+');
            ZEROS_STR = ret{1};
            POLES_STR = ret{2};
            ret = strrep({ZEROS_STR, POLES_STR},')(',')*(');
            ZEROS_STR = ret{1};
            POLES_STR = ret{2};
            
            spiceLap = strrep(spiceLap, 'ZEROS', ZEROS_STR);
            spiceLap = strrep(spiceLap, 'POLES', POLES_STR);
            clipboard('copy', spiceLap);

        otherwise   % standard selection: NumDen
            [num, den]=tfdata(sys);
            num=cell2mat(num);
            den=cell2mat(den);


            spowN=s.^[length(num)-1:-1:0];
            spowD=s.^[length(den)-1:-1:0];

            spiceLap=sprintf('laplace=(%s)/(%s)',...
                            strrep( strrep(char(vpa(num*spowN.',4)),'^','**'), ' ',''),...
                            strrep( strrep(char(vpa(den*spowD.',4)),'^','**'), ' ',''));
            clipboard('copy', spiceLap);
    end
end
    