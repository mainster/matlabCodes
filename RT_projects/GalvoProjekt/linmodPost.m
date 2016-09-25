function varargout = linmodPost(SYS_STRUCT, varargin)
%% varargout = linmodPost(SYS_STRUCT, varargin)     @!@MDB
% 
% Post processing MIMO/SIMO/MISO system struct returned by s=linmod(...)
% 
% SYS_STRUCT:       output structure of linmod 
% IN_NAME:          String consisting the name of input port for post processing
% OUT_NAME:         String consisting the name of output port for post processing
%
if nargin == 0
    error('no linmod return struct specified!')
else
    if nargin >= 1
        if ~isstruct(SYS_STRUCT)
            error('param 1 needs to be a linmod return struct!')
        end
        if nargin == 1;
            error('specify input and output port name')
        end
        S=SYS_STRUCT;
    end
    if nargin >= 2
        if ~ischar(varargin{1})
            error('second and third parameter: Must be strings of Input and Output port Name')
        end
        IN_NAME_STR=varargin{1};
    end
    if nargin >= 3
        if ~ischar(varargin{2})
            error('second and third parameter: Must be strings of Input and Output port Name')
        end
        OUT_NAME_STR=varargin{2};
    end
    if nargin >= 4
        warning('To much parameters, ignoring extra params!')
    end
end


indIn = find(~cellfun(@isempty,strfind(S.InputName, IN_NAME_STR)));
indOut = find(~cellfun(@isempty,strfind(S.OutputName, OUT_NAME_STR)));
if isempty(indIn)
    error(['Input Port ''' IN_NAME_STR ''' not found'])
end
if isempty(indOut)
    error(['Output Port ''' OUT_NAME_STR ''' not found'])
end

inName=cellfun(@strsplit, S.InputName,repmat({'/'},length(S.InputName),1),...
    'UniformOutput',false);
outName=cellfun(@strsplit, S.OutputName,repmat({'/'},length(S.OutputName),1),...
    'UniformOutput',false);

tmp=ss(S.a, S.b, S.c, S.d);
[nu, de]=tfdata(tmp(indOut,indIn));
sys=tf(nu{:},de{:},'u',inName{indIn,:}{2},'y',outName{indOut,:}{2});

varargout{1} = sys;
end