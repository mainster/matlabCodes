function l = line_(p1, p2, varargin)
    
    l = line([p1(:,1),p2(:,1)], [p1(:,2),p2(:,2)], varargin{:});
end