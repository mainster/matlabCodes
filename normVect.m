function out=normVect (VECT)

if nargin == 0
    error('no input')
end
if ~isnumeric(VECT)
    error('no # input')
end    
    
[c, idx] = max(size(VECT));    % only select first row/column    

if idx == 1 % Zeilenvector
    y = VECT(:, 1);
else
    y = VECT(1,:);
end
    
 out = y/max(y);
%out = y;
    
end    
    