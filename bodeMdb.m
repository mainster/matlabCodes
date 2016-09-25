classdef bodeMdb
   % bodeMdb   Summary of bodeMdb
   % This class was introduced to implemented to extend some of the builtin
   % 'DefaultProperties'. For example, I missed the possibility to default 
   % enabled calling of legend('show') for LTI system plots like bodeplot, rlocus...
   % Example:
   % g=zpk(-1, [-2, -3], 1,'name','G0 - OpenLoop'); bodeplot(g); legend('show')
   %
   % bodeMdb Properties:
   %    bodeCfg - Description of bodeCfg
   %
   % bodeMdb Methods:
   %    doThis - Description of doThis
   %    doThat - Description of doThat
   %    doThisHelped - Description of doThisHelped. A detailed help for
   %    methode doThisHelped could be consulted by typing  help doThisHelped 
   %    
   properties
      % bodeCfg   Summary of bodeCfg
        bodeCfg;
        velocity;
    end
    methods
        function p = bodeMdb(x,y,z)
            p.velocity.x = x;
            p.velocity.y = y;
            p.velocity.z = z;
        end
        function disp(p)
            builtin('disp',p) %call builtin
            if isscalar(p)
                disp('  Velocity')
                disp(['  x: ',num2str(p.velocity.x)])
                disp(['  y: ',num2str(p.velocity.y)])
                disp(['  z: ',num2str(p.velocity.z)])
            end
        end
    end
end
