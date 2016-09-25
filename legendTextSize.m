function varargout = legendTextSize (varargin)
% LEGENDTEXTSIZE  Change the FontSize of legend objects. 
%
% A global parameter exists, but the legend font size is set by the same
% "DefaultAxesFontSize" parameter. Size 14 is good for legend Strings but
% oversized for axis tick labels. set(0,'DefaultAxesFontSize',14)
%
% The only workaround is to specify a smaller default fontsize and change
% font size of legend object by their function handle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check function arguments by inputParser
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if false
   p = inputParser;
   expLength = {'equal','none'};
   expNorm = {'db','dB'};
   %defaultHeight = 0;

   valSeq = @(x) isnumeric(x) && isrow(x) && ~isscalar(x);
   valLength = @(x) isnumeric(x) || (ischar(x) && any(validatestring(x,expLength)));
   valNorm = @(x) isnumeric(x) || (ischar(x) && ~isempty(strfind(x,expNorm{2}))); 


   addRequired(p,'seqCmd',valSeq);
   addRequired(p,'seqRef',valSeq);
   addParam(p,'norm',0,valNorm);
   addParam(p,'length',0,valLength);


   parse(p,seqCmd,seqRef,varargin{:});
   a = p.Results     
end

if nargin > 0
   if isnumeric(varargin{1})
      FSIZE = varargin{1};
   else
      fprintf('Error, need numeric size parameter\n')
   end
else
   FSIZE=14;
end

h=findall(0,'Type','legend');
set(h,'FontSize',FSIZE);

% varargout{1}=0;

end