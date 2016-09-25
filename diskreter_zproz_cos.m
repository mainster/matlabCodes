
x=@(p,t) cos(2*pi*1000*t+p);
pv = [0, pi/2, pi, 372*pi];		% diskrete ZV, gleichverteilt
N = length(pv);					% Anzahl der Ecperimente
xv = x(pv,t);

% Moment 1. Ordnung
%
mx1 = 0;
for k=1:N
	mx1 = mx1 + xv(k)*1/4;
end

mx1
clf;
ezplot( x(pv(1),t), [0,4/(1000*pi)] ); hold all;
ezplot( x(pv(2),t), [0,4/(1000*pi)] ); 
ezplot( x(pv(3),t), [0,4/(1000*pi)] ); 
ezplot( x(pv(4),t), [0,4/(1000*pi)] ); 
grid on;



