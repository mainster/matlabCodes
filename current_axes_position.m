function x = current_axes_position()


% CURRENT_AXES_POSITION returns pointer
% position on current axes in units of pixels


% Author: David Liebowitz, Seeing Machines


  x = [0 0];
  % get the pointer's screen position
  scrn_pt = get(0, 'PointerLocation');


  % Now get the figure and axis positions on
  % the screen and infer
  % axes co-ordinates of the pointer:


  % It's a good idea to find out what units
  % the current axes and figure use:
preunits_ax = get(gca,'Units');
 	 preunits_fig = get(gcf,'Units');
  %set them to pixels and get the positions
   set(gca,'units','pixels');
   ax_loc = get(gca, 'Position');
   set(gcf,'units','pixels');
   fig_loc = get(gcf, 'Position');
 % now you can convert screen co-ordinates to
 % axes co-ordinates


   lx = (scrn_pt(1) - (ax_loc(1) + ... fig_loc(1)))/ax_loc(3);
   xlim = get(gca, 'XLim');
   x(1) = xlim(1) + lx*diff(xlim);
   ly = (scrn_pt(2) - (ax_loc(2) + ...
fig_loc(2)))/ax_loc(4);
   ylim = get(gca, 'YLim');
   x(2) = ylim(1) + ly*diff(ylim);


% Set the units back to what they were
set(gca,'Units',preunits_ax);
set(gcf,'Units',preunits_fig);