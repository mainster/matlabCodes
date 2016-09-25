function [h] = plota(varargin)
% PLOTA is a wrapper function to the user defined custom object class seq
%
% PLOTA( <default plot arguments> ) 
% Calls the builtin plot function
%
% PLOTA( [X], Y, NAME)  
% Generates and plots a seq object with the name 'NAME'
%
% PLOTA( [X], Y, 'r--', NAME)  
% Generates and plots a seq object with the name 'Name'
%

if nargin == 1
   if isa(varargin{1},'seq')
      plotaFunc(varargin{1});
   end
else
   if ischar(varargin{end-1}) && ischar(varargin{end})
      tmp=varargin'; %  seq(varargin{1},varargin{2},varargin{4})
      tmp(end-1,:)=[];
      tmp=tmp';
      obj = seq(tmp{:});
      obj.custom = varargin{end-1};
      
      plotaFunc(obj,obj.custom)
   end
end

end

function plotaFunc(obj, varargin)
if isempty(obj.xData)
   plot(obj.xData, varargin{:});
else
   % plot(obj, varargin) > 1 if varargin != 0
   if nargin > 1
      plot(obj.xData, obj.yData, varargin{:});
   else
      plot(obj.xData, obj.yData);
   end
end
title('My plot graph');

% Check for a non-empty legend handle to append (e.g. in hold all mode)
if ~isempty(legend)
   str=[get(legend,'String'), obj.Name];
else
   str=[obj.Name];
end

% delete legend obj
legend off
legend show
set(legend,'String', str);
end
