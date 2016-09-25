function varargout = recCmd (varargin)
%% [Y] = recCmd(FS, NCHAN, T_REC)     @@@MDB
%% [Y, FS] = recCmd(FS, NCHAN, T_REC)     @@@MDB
%% [Y, MPLAY, OPT] = recCmd(FS, NCHAN, T_REC)     @@@MDB
% 
% einzelne mic- aufnahme
%

if nargin >= 1
    if ~isnumeric(varargin{1})
        error('first argument must be numeric')
    end
    fs = varargin{1};
else
    error('no input arguments')
end

if nargin >= 2
    if ~isnumeric(varargin{2})
        error('second argument must be numeric')
    end
    nchan = varargin{2};
end

if nargin >= 3
    if ~isnumeric(varargin{3})
        error('third argument must be numeric')
    end
    recLen = varargin{3};
end

    recObj = audiorecorder(fs, 16, nchan);
%    disp('Start speaking.')
    recordblocking(recObj, recLen);
    disp('End of Recording.');
    
    y=getaudiodata(recObj);
    mp=audioplayer(y, fs);
    
    if nargout >= 0
        varargout{1} = y;
    end
    if nargout == 2
        varargout{2} = fs;
    end
    if nargout == 3
        varargout{1} = y;
        varargout{2} = mp;
        varargout{3} = {fs, recLen, recLen*fs, nchan};
    end
end