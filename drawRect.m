function drawRect () 

clear m*
load('rechtecke1');
clf; 
ax=gca; 
axis(ax, [-50 250 0 300]); 

for k=1:length(m1)
   drawRects(m1(k,:), ax); 
   pause(1e-3); 
end


function [rx, ry] = drawRects(co, h) 

%% length(co) = 4
% co =   [x1, y1, x2, y2]
x = [co(1),co(3)];
y = [co(2),co(4)];

rx=[min(x), min(x), max(x), max(x), min(x)];
ry=[min(y), max(y), max(y), min(y), min(y)];

disp(rx)
disp(ry)
hold all;
plot(h, rx, ry, '-'); 
axis(h,'square');
daspect([repmat(max(daspect),1,2),1]);

