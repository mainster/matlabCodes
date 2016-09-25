function mfprintf(MAT, varargin)
%% mfprintf(MAT, FORMAT)     @@@MDB
%% mfprintf(MAT, SPACE)     
% 
% Matrix print
%
% MAT:      Matrix to print
% FORM:     format spec, eg.  '\t%.2g'
% SPACE:    count of leading whitespaces per element
%
% examples:
% mfprintf(Y,'\t% 2.1f')
% mfprintf(Y,'\t% .2g')
%
FORM = '  % g';

if nargin > 1
    if isstr(varargin{1})
        FORM = varargin{1};
    else
        if (isnumeric(varargin{1}) && length(varargin{1})==1)
            FORM = strrep(FORM,'  ',repmat(' ',1,varargin{1}));
        end
    end

            
end
% 
% %evalin('base','fprintf([repmat(FORM,1,size(MAT,2)), ''\n''] ,MAT.'')')
% if min(MAT(:)) < 0
%      [r c]=find(MAT+abs(MAT));
%      st = sprintf([repmat(FORM,1,size(MAT,2)), '\n'], MAT.');
%      st = regexprep(st,'.\t-','\t-');
% %     st = strrep(st,'.',' ');
% else
%     st = sprintf([repmat(FORM,1,size(MAT,2)), '\n'], MAT.');
% end
fprintf(['\n' repmat(FORM,1,size(MAT,2))], MAT.');
% fprintf('\n');
% disp(st)
fprintf('\n');
fprintf('\n');

end