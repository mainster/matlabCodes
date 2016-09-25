function ret = saveCell2ascii(filename, cellvar, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% saveCell2ascii.m                                                      @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cell variable mit numeric und char in textdatei speichern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ret = saveCell2ascii(filename, cellvar, varargin)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   parse function arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p = inputParser;
    modes = {'w', 'w+', 'a', 'a+'};

%     var =       @(x) isnumeric(x) && ~isscalar(x); 
    valMode =   @(x) ischar(x)    && ~isempty(regexp(x,modes)); 
    
    addRequired(p,'filename', @ischar);
    addRequired(p,'cellvar', @iscell);
    addOptional(p,'permission', 'a', valMode);

    parse(p,filename, cellvar,varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[nrows,ncols]= size(mycell);

% strcmpi(pars.select,'load')
% filename = 'celldata.dat';
[nrows,ncols]= size(cellvar);

fid = fopen(filename, p.Results.permission);
ret = fid;
for row=1:nrows
    idxNum =    find(cellfun(@isnumeric,(cellvar(row,:))));
    idxChar =   find(cellfun(@ischar,(cellvar(row,:))));
    LINE = cell(1,length(idxNum)+length(idxChar) + 1);
    LINE(idxNum)=repmat({'%g '},1,length(idxNum));
    LINE(idxChar)=repmat({'%s '},1,length(idxChar));
    LINE(end) = {'\n'};
    fprintf(fid, cell2mat(LINE), cellvar{row,:});
end

fclose(fid);

end