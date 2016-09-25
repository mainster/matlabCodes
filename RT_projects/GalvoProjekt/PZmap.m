function PZmap(varargin)
%@!@MDB
    fh=[];
    figHold={};
    if nargin == 0
        error('Please give me a SYS object as first parameter')
    else
        if nargin >= 1
            if ~issystem(varargin{1})
                error('This is not a valied LTI system object')
            end
        end
        if nargin >= 2
            if ~ishandle(varargin{2})
                error('axis handle expected')
            else
                fh=varargin{2};
            end
        end
        if nargin >= 3
            if ~ischar(varargin{3})
                error('available parameters for arg 3: ''''hold'''', ''''clear'''' ')
            else
                figHold=varargin{3};
            end
        end
    end

    sys=varargin{1};

    [ps zs]=pzmap(sys);

    if isempty(fh)
        figure;
        plot(real(ps),imag(ps),'x','LineWidth',2);
        plot(real(zs),imag(zs),'o','LineWidth',2);
        grid on;
    else 
        if strcmpi(figHold,'hold')
%           set(fh, 'NextPlot','add');
           hold all;
        end
        plot(fh, real(ps),imag(ps),'x','LineWidth',2);
        plot(fh, real(ps),imag(ps),'x','LineWidth',2);
        hold off
        grid on;
    end
   

end