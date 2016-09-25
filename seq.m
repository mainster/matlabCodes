classdef seq
   % seq   Summary of seq
   % This class was introduced to extend some of the builtin
   % 'DefaultProperties'. For example, I missed the possibility to default 
   % enabled calling of legend('show') for LTI system plots like bodeplot, rlocus...
   % Example:
   % g=zpk(-1, [-2, -3], 1,'name','G0 - OpenLoop'); bodeplot(g); legend('show')
   %
   % seq Properties:
   %    bodeCfg - Description of bodeCfg
   %
   % seq Methods:
   %    doThis - Description of doThis
   %    doThat - Description of doThat
   %    doThisHelped - Description of doThisHelped. A detailed help for
   %    methode doThisHelped could be consulted by typing  help doThisHelped 
   %    

   properties
      xData
      yData
      Name
      custom
   end
   methods
      function obj = seq(varargin)
         if nargin == 1
            obj.yData = varargin{1};
         end
         while nargin == 2
            % check if plot(xx,yy) has been passed
            if isnumeric(varargin{1}) && isnumeric(varargin{2})
               if length(varargin{1}) ~= length(varargin{2})
                  error('arg1 and arg2 has different lengths')
               end

               obj.xData = varargin{1};            
               obj.yData = varargin{2};
               break;
            end
            % check if plot(yy,'seq name') has been bassed
            if isnumeric(varargin{1}) && ischar(varargin{2})
               obj.yData = varargin{1};            
               obj.Name = varargin{2};
               break;
            end
            % Error
            error('Unknown combination of %i input arguments',nargin);            
         end
         while nargin == 3
            if length(varargin{1}) ~= length(varargin{2})
               error('arg1 and arg2 has different lengths')
            end

            % check if plot(xx,yy,'seq name') has been bassed
            if isnumeric(varargin{1}) && isnumeric(varargin{2}) ...
                  && ischar(varargin{3})
               obj.xData = varargin{1};            
               obj.yData = varargin{2};
               obj.Name = varargin{3};            
               break;
            end
            % Error
            error('Unknown combination of %i input arguments',nargin);                
         end
      end
      function plot(obj, varargin)
         if isempty(obj.xData)
            plot(obj.xData, varargin);
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
   end
end
