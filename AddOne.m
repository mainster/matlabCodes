classdef AddOne < matlab.System
% ADDONE Compute an output value one greater than the input value
  
  % All methods occur inside a methods declaration.
  % The stepImpl method has protected access
  methods (Access = protected)
    
    function [y1, y2] = stepImpl(~,x1,x2)
      y1 = x1 + 1;
      y2 = x2 + 1;
    end
  end
end
