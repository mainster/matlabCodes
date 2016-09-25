function druecken(o,e,h) 
pt = get(h.a, 'CurrentPoint'); 
set(h.f,'Name',num2str([pt(1,1) pt(1,2)])); 
set(h.f, 'WindowButtonMotionFcn', {@ziehen,h}) 
