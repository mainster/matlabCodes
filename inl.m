% function varargout = inl(varargin)
% Helper function to extend inline access to a return argument of type cell
% 
syms a b c
ex1 = a*1/(b*1i*c)
sv=symvar(char(ex1))'
fun1 = str2func([sprintf(['@(%s',repmat(',%s',1,length(sv)-1),')'],sv{:}) char(ex1)])


% sprintf('(@)(%s,%s)',sv{:})
% end
