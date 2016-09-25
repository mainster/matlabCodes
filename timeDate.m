function varargout = timeDate (varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print different time and date formats                               @@@MDB
%
% timeDate          ->      3:6:18
% timeDate('_')     ->      3_6_18
% timeDate(1,'_')   ->      DateDELIM 15-11-2014	Time: 3_7_28
% timeDate(1,'_')   ->      Date_15-11-2014	Time: 3_8_29
%

DELIM = ':';

cl = clock;
in = -99;

if (nargin > 0 && isnumeric(varargin{1}))
    in = varargin{1};
end
if nargin == 1
	if ischar(varargin{1})  % hh<DELIMITER>mm<DELIMITER>ss<DELIMITER>
        DELIM=varargin{1};
    end
end
if nargin == 2
	if ischar(varargin{2})  % hh<DELIMITER>mm<DELIMITER>ss<DELIMITER>
        DELIM=varargin{2};
    end
end

    switch in
        case 1
            varargout{1}=sprintf(['Date', DELIM, '%i-%i-%i\tTime: %i',DELIM '%i',DELIM '%i'],...
                           fliplr(cl(1:3)), round(cl(end-2:end)));
        case 2
            varargout{1}=sprintf(['%i',DELIM '%i',DELIM '%i'], round(cl(end-2:end)));
        case 3
            varargout{1}=sprintf('%i%i%i_%i-%i-%i', (cl(1:3)), round(cl(end-2:end)));
        case 4
            varargout{1}=sprintf('%i%i%i_%i-%i-%i', fliplr(cl(1:3)), round(cl(end-2:end)));
        otherwise
            varargout{1}=sprintf(['%i',DELIM '%i',DELIM '%i'], round(cl(end-2:end)));
    end

end