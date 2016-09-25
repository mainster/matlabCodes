classdef myClass
   % myClass   Summary of myClass
   % This is the first line of the description of myClass.
   % Descriptions can include multiple lines of text.
   %
   % myClass Properties:
   %    a - Description of a
   %    b - Description of b
   %
   % myClass Methods:
   %    doThis - Description of doThis
   %    doThat - Description of doThat
   %    doThisHelped - Description of doThisHelped. A detailed help for
   %    methode doThisHelped could be consulted by typing  help doThisHelped 
   %           
   
   
   properties
      a
      b
   end
   
   methods
      function obj = myClass
      end
      function doThis(obj)
      end
      function doThat(obj)
      end
      function doThisHelped(obj)
         % doThisHelped  Do this thing
         %   Here is some help text for the doThis method.
         %
         %   See also DOTHAT.
         
         disp(obj)
      end
   end
   
end