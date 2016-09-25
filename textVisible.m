function [n] = textVisible(hfig, str, tog)
%   N = textVisible(FIGURE_HANDLE, SEARCH_STR, VISIBLE)
%
%   FIGURE_HANDLE   is handle to figure for label search. 
%   SEARCH_STR      is string cell containing search strings. 
%                   e.g. {'Phase','Magnitude','Bode Dia'}
%                   or:
%                   keyword 'bode' and 'nyquist' for standard bode or 
%                   nyquist plot texts. 
%   VISIBLE         'on' or 'off'.
%
%   Manuel Del Basso
%   2014-07-18
%

    n=0;
    
    if strcmp(lower(str),'bode'), str={'Phase','Magnitude','Bode Dia','Frequency'}; 
    elseif strcmp(lower(str),'nyquist'), str={'Imaginary','Real','Nyquist Dia','Locus'};
    end

    if ~ischar(tog),    error('tog needs to be a string'); end
    if ~iscellstr(str), error('str needs to be a cell of strings'); end

    for k=1:length(str)
        at=findall(hfig,'type','text');
        ind=find(~cellfun(@isempty, strfind(lower(get(at,'String')), lower(str{k}) )) );
        set(at(ind),'Visible',tog);
        n=n+length(ind);
    end
end