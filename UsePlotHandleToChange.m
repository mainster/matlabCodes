%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the plot handle to change the color of the plot's title

sys = rss(2);
sys2 = rss(2);
sys3 = rss(2);

h = pzplot(sys,'r',sys2,'g',sys3,'b');
p = getoptions(h); % Get options for plot.
p.Title.Color = [1,0,0]; % Change title color in options.
setoptions(h,p); % Apply options to plot.
