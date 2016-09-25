function varargout = searchPath(varargin)
    if nargin==0,
        error( 'No search string' );
    elseif nargin==1,
        if ~ischar(varargin{1})
            error('please input search STRING')
        end
        
    end

    if nargin > 1,
        warning(['at this time, only single search string is supported!',...
                 'Ignore argument numbers >'])
    end

    pa = strsplit(evalin('base','pathdef'), ':');
    
    ind = find(~cellfun(@isempty, strfind(pa,  varargin{1})));
    
    if (isempty(ind))
        sprintf('String %s not found in matlab path', varargin{1})
        if (nargout > 0)
            varargout{nargout} = -1;
        end
    else 
        if (nargout > 0)
            varargout{1} = pa(ind)';
        else
            disp(pa(ind)')
        end
    end
    
end