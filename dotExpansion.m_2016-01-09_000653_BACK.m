function [varargout] =  dotExpansion (in)
persistent callno
%%DOTEXPANSION replace the operators {'*','/','^'} by {'.*','./','.^'} 
% if ishandle(in)
% 	SNR2 = str2func( ['@(fg)' regexprep(char(SNR1(fg)),...
%       {'*','/','\^','atan'},{'.*','./','.^','atand'})] );


   % Test if input 'in' is of class 'function_handle'
   if isa(in,'function_handle')
      inStr = char(in);
   %    idxarg = regexp(ins,'@\(.+\)');
   % 
   %    if ~isempty( idxarg ) 
   %       argend = strfind(ins,')');
   %       inarg = ins( idxarg:argend(1) );
   %    end
   %    varargout{1} = inarg;
   else 
       inStr = char(in);
       warning(['Input ''in'' at call #' num2str(callno) 'is not a function handle...'])
       if ~isa(in,'symfun')
          error('... and also not a object of class ''symfun'' --> halt')
       else
          sv=symvar(in);
          svStr = '@(';
          for k=1:length(sv)
             svStr=[svStr char(sv(k)) ','];
          end
          inStr=[svStr(1:end-1) ') ' inStr];
       end
   end
   callno=callno+1;
   
   inStr = regexprep(inStr, {'*','/','\^'}, {'\.*','\./','\.^'});
   inStr = regexprep(inStr, {'(\.\.)'}, {'\.'});

   if nargout == 1
      varargout{1} = str2func( inStr );
      return;
   end

   if nargout == 0
      
      
      
      
      infunc = str2func( inStr );
      evalin('base', '')
      return;
   end

end