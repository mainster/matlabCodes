function [varargout] =  dotExpansion (in, varargin)
%% DOTEXPANSION replaces scalar operators by it's 'elementwise' operator @@@MDB
% {'*','/','^'}   ->    {'.*','./','.^'}
%
% Usage:
% h = DOTEXPANSION(f1) where f1 must be a function handle
% f1 = DOTEXPANSION(f1) where f1 must be a function handle
% DOTEXPANSION('f1')    where f1 must be a function handle
% DOTEXPANSION(___, 'remove') replace the elementwise by it's scalar operator



persistent callno

handleName='';
makeOutpFunction=0;

% Test if input 'in' is of class 'function_handle' or 'sym'
if isa(in,'function_handle') || isa(in, 'sym')
   instr = char(in);
else
   if ischar(in)  % function handle as string?
      if length(strfind(in,'.')) == 1      % struct field function handle as string? (only 1 dot allowed)
         structName=in(1,strfind(in,'.')-1);
         fieldName=in(strfind(in,'.')+1:end);         
         fmems=evalin('base',sprintf('fieldnames(%s);', structName));
         if isempty(strfind(fmems,fieldName))
            error('In base workspace is no variable called %s', in);
         end
         if ~evalin('base',['isa(' in ' ,''function_handle'')'])  % check if a base variable exists
            error('In base workspace is no variable called %s', in);
         end
      else
         if ~evalin('base',sprintf(['exist(''%s'')'], in))  % check if a base variable exists
            error('In base workspace is no variable called %s', in);
         end
      end
      if evalin('base',['isa(' in ' ,''function_handle'')'])  % check for in to be a handle in base
         handleName = in;
         instr = char(evalin('base',in));
      else
         error(['Argument ' in ' must be either a string containing the name',...
            'to fhandle or it must be THE function handle'])
      end
   else
      %% Error
      instr = char(in);
      warning(['Input ''in'' at call #' num2str(callno) 'is not a function handle...'])
      if ~isa(in,'symfun')
         error('... and also not a object of class ''symfun'' --> halt')
      else
%          sv=symvar(in);
%          svStr = '@(';
%          for k=1:length(sv)
%             svStr=[svStr char(sv(k)) ','];
%          end
%          instr=[svStr(1:end-1) ') ' instr];
            makeOutpFunction=0;
      
      end
   end
end
callno=callno+1;

%% To make the function compatible with a mixed-operator input, remove possible
% elemenwise operators befor the selected action takes place
instr = regexprep(char(instr), {'(\.\/)','(\.\*)','(\.\^)'},{'/','*','^'});

if nargin == 2 && (  ~isempty(strfind(varargin{1}, 'scal')) ||...
      ~isempty(strfind(varargin{1}, 'remove')))
   %   inStr = regexprep(inStr, {'\.*','\./','\.^'},{'*','/','\^'});
   instr = regexprep(char(instr), {'(\.\/)','(\.\*)','(\.\^)'},{'/','*','^'});
else
   instr = regexprep(instr, {'*','/','\^'}, {'\.*','\./','\.^'});
   %   inStr = regexprep(inStr, {'(\.\.)'}, {'\.'});
end


if nargout == 1
   if makeOutpFunction==1
      varargout{1} = str2func( instr );
   else
      varargout{1} =  instr ;
   end      
   return;
end

if nargout == 0
   evalin('base', [handleName '=' instr ';'])
   return;
end

end
