function gtktermFun1(fileName, varargin)
    
titleIn = 'notitle';
nSamps = 100;

if nargin >= 2
        if ~isstr(varargin{1})
            error('Arg 2 must be title string')
        else
            titleIn = varargin{1};
        end
    nSamps = 100;
end

if nargin == 3
    if ~isnumeric(varargin{2})
        error('Arg 3 must be numeric')
    else
        nSamps = varargin{2};
    end
end

    fd=fopen(fileName,'r');
    line=fgetl(fd);
    k=1;
    while isempty(strfind(line,'W:'))
        line=fgetl(fd);
    end

    C = textscan(fd, '%s %d %s %d %s %d %s %d');
    fclose(3);

    figure;
%    clf;

    hold all;
    plot(C{2});
    plot(C{4});
    plot(C{6});
    plot(C{8});
    hold off;
    grid on
    xlim([0,nSamps]);
    title(titleIn)

    legend('W:','Y:','E:','P:');
    %din.(strsplit(C{1}{1},':'))=C{2}

return