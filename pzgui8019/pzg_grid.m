function [ temp0, hndl, mod_hndl ] = ...
                pzg_grid( temp0, fig_h, ax_h, ploth_ndx, hndl, grid_vis )
% Updates the continuous-time pzgui grid lines (constant damping and 
% constant natural frequency) according to whether or not the discrete-time
% dpzgui is open, and (if open) according to which method of continuous-to-
% discrete is selected, ZOH-equiv, e^sT, or bilinear.

% The following copyrighted m-files comprise the PZGUI tool:
%    ** The contents of these files may not be included **
%    **  in any other program without explicit written  **
%    **    consent from the author, Mark A. Hopkins     **
%     bodepl.m        pzg_bodex.m     pzg_islink.m     pzg_seltxt.m
%     contents.m      pzg_box.m       pzg_islogx.m     pzg_tools.m
%     contourpl.m     pzg_c2d.m       pzg_isunwrp.m    pzg_tpwr.m
%     dpzgui.m        pzg_cntr.m      pzg_lims.m       pzg_txan.m
%     dupdatep.m      pzg_cphndl.m    pzg_menu.m       pzg_unre.m
%     figopts.m       pzg_d2c.m       pzg_moda.m       pzg_unwrap.m
%     fr_disp.m       pzg_disab.m     pzg_onoff.m      pzg_updtfilt.m
%     freqserv.m      pzg_efmt.m      pzg_pfesim.m     pzg_xtrfrq.m
%     gainfilt.m      pzg_err.m       pzg_prvw.m       pzgcalbk.m
%     helpserv.m      pzg_errvis.m    pzg_ptr.m        pzgui.m
%     ldlgfilt.m      pzg_fndo.m      pzg_recovr.m     pzmvserv.m
%     nicholpl.m      pzg_gle.m       pzg_reptxt.m     resppl.m
%     nyqistpl.m      pzg_grid.m      pzg_res.m        rlocuspl.m
%     pidfilt.m       pzg_inzpk.m     pzg_rsppfe.m     sensplot.m
%     pz_move.m       pzg_isdby.m     pzg_rss.m        updatepl.m
%     pzg_bkup.m      pzg_ishzx.m     pzg_scifmt.m     updtpzln.m
%                                     pzg_sclpt.m      zmimntcpt.m
% (c) 1996 - 2014
%    by Professor Mark A. Hopkins, Ph.D.
%       Electrical and Microelectronic Engineering
%       Rochester Institute of Technology
%       Rochester NY, USA 14623        Email:  mark.hopkins@rit.edu
%
% SHAREWARE INFORMATION:
%               FREE, IF USED ONLY FOR EDUCATIONAL PURPOSES.
%   Otherwise:
%    (corporations, companies, and other for-profit users) 
%    Individual licenses -- US$200 per computer
%    Site license -- US$2000 per industrial site, any number of users
%    Make check payable to "Mark A. Hopkins", and remit to address above
% ----------------------------------------------------------------------
global PZG
mod_hndl = 0;
if nargin < 5
  hndl = [];
end
if ~nargin
  temp0 = [];
end
if isempty(PZG) && ~pzg_recovr 
  return
end

if ( nargin < 4 ) || ( ( ploth_ndx ~= 10 ) && ( ploth_ndx ~= 12 ) )
  if ~isempty( PZG(1).plot_h{12} )
    ploth_ndx = 12;
  elseif ~isempty( PZG(1).plot_h{10} )
    ploth_ndx = 10;
  else
    return
  end
end

if nargin < 5
  if isfield( PZG(1).plot_h{ploth_ndx},'hndl');
    hndl = PZG(1).plot_h{ploth_ndx}.hndl;
  elseif isappdata( fig_h,'hndl')
    hndl = getappdata( fig_h,'hndl');
  else
    hndl = [];
  end
end

if ( nargin < 3 ) || ~isequal( 1, numel(ax_h) ) ...
  || ~isequal( 1, ishandle(ax_h) ) ...
  || ~strcmp( get(ax_h,'type'),'axes')
  if isfield( PZG(1).plot_h{ploth_ndx},'ax_h')
    ax_h = PZG(1).plot_h{ploth_ndx}.ax_h;
  elseif isfield( hndl,'ax')
    ax_h = hndl.ax;
  else
    return
  end
end

if ( nargin < 2 ) || ~isequal( 1, numel(fig_h) ) ...
  || ~isequal( 1, ishandle(fig_h) ) ...
  || ~strcmp( get(fig_h(1),'type'),'figure')
  if isfield( PZG(1).plot_h{ploth_ndx},'fig_h')
    fig_h = PZG(1).plot_h{ploth_ndx}.fig_h;
  else
    return
  end
end

if ( nargin < 1 ) || isempty(temp0) ...
  || ( size(temp0,1) < 10 ) || ( size(temp0,2) ~= 2 )
  temp0 = get( fig_h,'userdata');
end
  
% Look at grid-visibility checkbox.
if ( nargin < 6 ) ...
  ||( ~isequal( grid_vis,'on') && ~isequal( grid_vis,'off') )
  grid_vis = 'on';
  if ( ( ploth_ndx == 10 ) && isfield( hndl,'rlocuspl_show_grid') ...
       && ~get( hndl.rlocuspl_show_grid,'value') ) ...
    ||( ( ploth_ndx == 12 ) && isfield( hndl,'GridOnCheckbox')...
        && ~get( hndl.GridOnCheckbox,'value') )
    grid_vis = 'off';
  end
end
  
this_cyan = [ 0 0.8 0.8 ];
this_yellow = [0.8 0.8 0 ];
if isequal( PZG(1).DefaultBackgroundColor,'w')
  this_cyan = [ 0 0.7 0.7 ];
  this_yellow = [0.7 0.7 0 ];
end

ImAxis = get( ax_h,'YLim');
ReAxis = get( ax_h,'XLim');

% Templates for s-plane lines
% U.C. points:
temp_new = [ 0; logspace( log10(pi/1000), log10(pi/4), 42 )' ];
temp_new = [ temp_new(1:end-1); pi/2-flipud(temp_new) ];
temp = temp_new;

UCPts = -cos(temp)+1i*sin(temp);
UCPts = [ flipud(UCPts); conj( UCPts ) ];
Circles = UCPts * (0.1:0.1:1)*pi;

Ts = PZG(2).Ts;
tempA = real( Circles ) / Ts;
tempB = imag( Circles ) / Ts;

tempA1 = [ tempA; 10*tempA; 100*tempA ];
tempB1 = [ tempB; 10*tempB; 100*tempB ];
all_ct_PZ = [ PZG(1).ZeroLocs; PZG(1).PoleLocs ];
if ~isempty(all_ct_PZ) && ( max(imag(all_ct_PZ)) > 0 ) 
  % Select a suitable multiplier for S-plane grid lines.
  % By default, this is Fs, but if there are p/z's beyond Nyquist,
  % then extend the grid lines, as necessary, into that region.
  pseudo_Ts = 1 / ( 2*max(imag(all_ct_PZ))/2/pi );
  if pseudo_Ts < Ts
    tempA1 = tempA1 * Ts/pseudo_Ts;
    tempB1 = tempB1 * Ts/pseudo_Ts;
  end
else
  pseudo_Ts = PZG(2).Ts;
end
tempA1 = [ tempA1; NaN*ones(1,size(tempA1,2)) ];
tempB1 = [ tempB1; NaN*ones(1,size(tempB1,2)) ];
if isfield( hndl,'Splane_constWn_semicirc')
  this_lineh = hndl.Splane_constWn_semicirc;
elseif size(temp0,1) >= 41
  this_lineh = temp0(41,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
      'xdata', tempA1(:), ...
      'ydata', tempB1(:), ...
      'color', this_cyan );
else
  this_lineh = ...
    plot( tempA1(:),tempB1(:),':', ...
         'color', this_cyan, ...
         'Visible','Off', ...
         'handlevisibility','off', ...
         'tag','grid_lines_411', ...
         'parent', ax_h );
  mod_hndl = 1;
end
hndl.Splane_constWn_semicirc = this_lineh;
temp0(41,1) = this_lineh;
set( this_lineh,'UserData', (tempA1+1i*tempB1)*Ts );

tempA = [ tempA;tempA;tempA;tempA;tempA;
          tempA;tempA;tempA;tempA ];
tempB = [ tempB+8*pi/Ts; tempB+6*pi/Ts;
          tempB+4*pi/Ts; tempB+2*pi/Ts;
          tempB;
          tempB-2*pi/Ts; tempB-4*pi/Ts;
          tempB-6*pi/Ts; tempB-8*pi/Ts ];
tempA = [ tempA; NaN*ones(1,size(tempA,2)) ];
tempB = [ tempB; NaN*ones(1,size(tempB,2)) ];
if isfield( hndl,'Splane_constWn_semicirc_repeated')
  this_lineh = hndl.Splane_constWn_semicirc_repeated;
elseif size(temp0,1) >= 41
  this_lineh = temp0(41,2);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 ) 
  set( this_lineh, ...
      'xdata', tempA(:), ...
      'ydata', tempB(:), ...
      'color', this_cyan );
else
  this_lineh = ...
    plot( tempA(:),tempB(:),':', ...
         'color', this_cyan, ...
         'Visible','Off', ...
         'handlevisibility','off', ...
         'tag','grid_lines_412', ...
         'parent', ax_h );
  mod_hndl = 1;
end
hndl.Splane_constWn_semicirc_repeated = this_lineh;
temp0(41,2) = this_lineh;
set( this_lineh,'UserData',(tempA+1i*tempB)*Ts);

temp = logspace( -3, log10(0.5), 43 )';
temp = [ 0; temp(1:end-1); 1-flipud(temp); 1 ];
ZetaAngles = acos( [ 0.01 0.02 0.05 (0.1:0.1:0.9) ] );
Sines = sin(ZetaAngles);
Cosines = cos(ZetaAngles);
Radii = -temp*(Cosines./Sines) + 1i*temp*(Sines./Sines);
Radii = [ flipud(Radii); conj(Radii) ]*pi;
tempA = real( Radii )/Ts;
tempB = imag( Radii )/Ts;
tempA1 = tempA*100;
tempB1 = tempB*100;
if ~isempty(all_ct_PZ)
  if pseudo_Ts < Ts
    tempA1 = tempA1 * Ts/pseudo_Ts;
    tempB1 = tempB1 * Ts/pseudo_Ts;
  end
end
tempA1 = [ tempA1; NaN*ones(1,size(tempA1,2)) ];
tempB1 = [ tempB1; NaN*ones(1,size(tempB1,2)) ];
if isfield( hndl,'Splane_constZeta_lines')
  this_lineh = hndl.Splane_constZeta_lines;
elseif size(temp0,1) >= 51
  this_lineh = temp0(51,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )  
  set( this_lineh, ...
      'xdata', tempA1(:), ...
      'ydata', tempB1(:), ...
      'color', this_yellow );
else
  this_lineh = ...
    plot( tempA1(:),tempB1(:),':', ...
         'color', this_yellow, ...
         'Visible','Off', ...
         'handlevisibility','off', ...
         'tag','grid_lines_511', ...
         'parent', ax_h );
  mod_hndl = 1;
end
hndl.Splane_constZeta_lines = this_lineh;
temp0(51,1) = this_lineh;
set( this_lineh,'UserData', Ts*(tempA1+1i*tempB1) );

tempA = [ tempA;tempA;tempA;tempA;tempA;
          tempA;tempA;tempA;tempA ];
tempB = [ tempB+8*pi/Ts; tempB+6*pi/Ts;
          tempB+4*pi/Ts; tempB+2*pi/Ts;
          tempB;
          tempB-2*pi/Ts; tempB-4*pi/Ts;
          tempB-6*pi/Ts; tempB-8*pi/Ts ];
tempA = [ tempA; NaN*ones(1,size(tempA,2)) ];
tempB = [ tempB; NaN*ones(1,size(tempB,2)) ];
if isfield( hndl,'Splane_constZeta_lines_repeated')
  this_lineh = hndl.Splane_constZeta_lines_repeated;
elseif size(temp0,1) >= 51
  this_lineh = temp0(51,2);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
      'xdata', tempA(:), ...
      'ydata', tempB(:), ...
      'color', this_yellow );
else
  this_lineh = ...
    plot( tempA(:),tempB(:),':', ...
         'color', this_yellow, ...
         'Visible','Off', ...
         'handlevisibility','off', ...
         'tag','grid_lines_512', ...
         'parent', ax_h );
  mod_hndl = 1;
end
temp0(51,2) = this_lineh;
hndl.Splane_constZeta_lines_repeated = this_lineh;
set( this_lineh,'UserData',(tempA+1i*tempB)*Ts);

% Templates for w-plane lines
WCircles = exp(Circles);
WCircles = 2*( WCircles - 1 )/ Ts ./( WCircles + 1 );
for Xk = 1:5
  WCircles(Xk,10) = WCircles(6,10);
  WCircles(end-5+Xk,10) = WCircles(end-5,10);
end
WCircles = [ WCircles; NaN*ones(1,size(WCircles,2)) ];
if isfield( hndl,'Wplane_constWn_lines')
  this_lineh = hndl.Wplane_constWn_lines;
elseif size(temp0,1) >= 71
  this_lineh = temp0(71,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
      'xdata', real( WCircles(:) ), ...
      'ydata', imag( WCircles(:) ), ...
      'color', this_cyan );
else
  this_lineh = ...
    plot( real( WCircles(:) ), imag( WCircles(:) ),':', ...
         'color', this_cyan, ...
         'Visible','Off', ...
         'handlevisibility','off', ...
         'tag','grid_lines_711', ...
         'parent', ax_h );
  mod_hndl = 1;
end
hndl.Wplane_constWn_lines = this_lineh;
temp0(71,1) = this_lineh;
set( this_lineh,'UserData', WCircles*Ts );

WRadii = exp(Radii);
WRadii = 2*( WRadii - 1 ) / Ts ./ (WRadii + 1 );
WRadii = [ WRadii; NaN*ones(1,size(WRadii,2)) ];
if isfield( hndl,'Wplane_constZeta_lines')
  this_lineh = hndl.Wplane_constZeta_lines;
elseif size(temp0,1) >= 81
  this_lineh = temp0(81,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
      'xdata', real( WRadii(:) ), ...
      'ydata', imag( WRadii(:) ), ...
      'color', this_yellow );
else
  this_lineh = ...
    plot( real( WRadii(:) ), imag( WRadii(:) ),':', ...
         'color', this_yellow, ...
         'Visible','Off', ...
         'handlevisibility','off', ...
         'tag','grid_lines_811', ...
         'parent', ax_h );
  mod_hndl = 1;
end
hndl.Wplane_constZeta_lines = this_lineh;
temp0(81,1) = this_lineh;
set( temp0(81,1),'UserData', WRadii*Ts );

ImAxis(1) = min( ImAxis(1), -pi/pseudo_Ts );
ImAxis(2) = max( ImAxis(2), pi/pseudo_Ts );
ReAxis(1) = min( ReAxis(1), -7/pseudo_Ts );
ReAxis(2) = max( ReAxis(2), 0 );
if ~isempty(gcbo) && ~strcmp( get(gcbo,'type'),'figure')
  cb_str = get( gcbo,'callback');
  if ~strcmp(get(gcbo,'type'),'uicontrol') ...
    ||~isempty( strfind( cb_str,'% Move') ) ...
    ||~isempty( strfind( cb_str,'% Add') )
    set( ax_h,'YLim', ImAxis );
    set( ax_h,'XLim', ReAxis );
  end
end

% Highlight the x- and y-axis.
ReAxis = get( ax_h,'XLim');
ct_ylim = get( ax_h,'YLim');
if isfield( hndl,'PZmap_xaxis_highlight')
  this_lineh = hndl.PZmap_xaxis_highlight;
elseif size(temp0,1) >= 5
  this_lineh = temp0(5,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
      'xdata', ReAxis, ...
      'ydata', [ 0 0 ], ...
      'color', this_cyan, ...
      'visible','on');
else
  this_lineh = ...
    plot( ReAxis, [ 0 0 ], ...
      'color', this_cyan, ...
      'tag','xaxis highlight', ...
      'parent', ax_h );
  mod_hndl = 1;
end
hndl.PZmap_xaxis_highlight = this_lineh;
temp0(5,1) = this_lineh;

if isfield( hndl,'PZmap_yaxis_highlight')
  this_lineh = hndl.PZmap_yaxis_highlight;
elseif size(temp0,1) >= 5
  this_lineh = temp0(4,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
      'xdata', [ 0 0 ], ...
      'ydata', ct_ylim, ...
      'color', this_cyan, ...
      'visible','on');
else
  this_lineh = ...
    plot( [ 0 0 ], ct_ylim, ...
      'color', this_cyan, ...
      'tag','yaxis highlight', ...
      'parent', ax_h );
  mod_hndl = 1;
end
hndl.PZmap_yaxis_highlight = this_lineh;
temp0(4,1) = this_lineh;

% Create or update the Ts lines and the half-Ts lines.
nline = 5;
temp = pi / PZG(2).Ts;
y_data = temp*[ (-(2*nline-1):2:(2*nline-1)); (-(2*nline-1):2:(2*nline-1)) ];
y_data = [ y_data; NaN*ones(1,size(y_data,2)) ];
x_data = ...
  [ ReAxis(1)*ones(1,size(y_data,2)); ReAxis(2)*ones(1,size(y_data,2)) ];
x_data = [ x_data; NaN*ones(1,size(x_data,2)) ];    
if isfield( hndl,'Splane_halfTS_lines')
  this_lineh = hndl.Splane_halfTS_lines;
elseif size(temp0,1) >= 21
  this_lineh = temp0(21,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )
  set( this_lineh, ...
    'xdata', x_data(:), ...
    'linestyle',':', ...
    'ydata', y_data(:), ...
    'color', this_cyan, ...
    'Visible','Off');
else
  this_lineh = ...
    plot( x_data(:), y_data(:), ...
      'linestyle',':', ...
      'color', this_cyan, ...
      'parent', ax_h, ...
      'handlevisibility','off', ...
      'tag','grid_lines_211', ...
      'Visible','Off');
  mod_hndl = 1;
end
hndl.Splane_halfTS_lines = this_lineh;
temp0(21,1) = this_lineh;

temp = 2*pi / PZG(2).Ts;

y_data = temp*[ [(-nline:1:-1),(1:nline)]; [(-nline:1:-1),(1:nline)] ];
y_data = [ y_data; NaN*ones(1,size(y_data,2)) ];
x_data = ...
  [ ReAxis(1)*ones(1,size(y_data,2)); ReAxis(2)*ones(1,size(y_data,2)) ];
x_data = [ x_data; NaN*ones(1,size(x_data,2)) ];     
if isfield( hndl,'Splane_fullTS_lines')
  this_lineh = hndl.Splane_fullTS_lines;
elseif size(temp0,1) >= 31
  this_lineh = temp0(31,1);
else
  this_lineh = [];
end
if ~isempty(this_lineh) && isequal( 1, ishandle(this_lineh) ) ...
  && ~isequal( this_lineh, 0 )  
  set( this_lineh, ...
    'xdata', x_data(:), ...
    'ydata', y_data(:), ...
    'color', this_cyan, ...
    'Visible','Off');
else
  this_lineh = ...
    plot( x_data(:), y_data(:), ...
      'linestyle','-', ...
      'color', this_cyan, ...
      'parent', ax_h, ...
      'handlevisibility','off', ...
      'tag','grid_lines_311', ...
      'Visible','Off');
  mod_hndl = 1;
end
hndl.Splane_fullTS_lines = this_lineh;
temp0(31,1) = this_lineh;

if isempty( PZG(2).plot_h{13} )
  set( ...
    [ hndl.Wplane_constWn_lines; ...
      hndl.Wplane_constZeta_lines; ...
      hndl.Splane_constWn_semicirc_repeated; ...
      hndl.Splane_constZeta_lines_repeated; ...
      hndl.Splane_halfTS_lines; ...
      hndl.Splane_fullTS_lines ],'visible','off');
  set( ...
    [ hndl.Splane_constWn_semicirc; ...
      hndl.Splane_constZeta_lines ],'visible', grid_vis );
else
  set( [ hndl.Splane_constWn_semicirc; ...
         hndl.Splane_constZeta_lines ],'visible','off');
  linkmethod = 2;
  linkmethod_h = pzg_fndo( 1,(12:13),'LinkMethod');
  if ~isempty(linkmethod_h)
    linkmethod = get( linkmethod_h,'value');
    if iscell(linkmethod)
      linkmethod = linkmethod{1};
    end
  end
  if isequal( 3, linkmethod )
    set( ...
      [ hndl.Splane_constWn_semicirc_repeated; ...
        hndl.Splane_constZeta_lines_repeated; ...
        hndl.Splane_halfTS_lines; ...
        hndl.Splane_fullTS_lines; ...
        hndl.Splane_constWn_semicirc; ...
        hndl.Splane_constZeta_lines ],'visible','off');
    set( ...
      [ hndl.Wplane_constWn_lines; ...
        hndl.Wplane_constZeta_lines ],'visible', grid_vis );
  else
    set( ...
      [ hndl.Splane_constWn_semicirc_repeated; ...
        hndl.Splane_constZeta_lines_repeated; ...
        hndl.Splane_halfTS_lines; ...
        hndl.Splane_fullTS_lines ],'visible', grid_vis );
    set( ...
      [ hndl.Wplane_constWn_lines; ...
        hndl.Wplane_constZeta_lines; ...
        hndl.Splane_constWn_semicirc; ...
        hndl.Splane_constZeta_lines ],'visible','off');
  end
end

if mod_hndl && ~nargout
  set( fig_h,'userdata', temp0 );
end
if mod_hndl && ( nargout < 2 )
  if isappdata( fig_h,'hndl')
    setappdata( fig_h,'hndl', hndl );
  end
  pzg_cphndl( fig_h, 1, ploth_ndx );
end

PZG(1).Ts = PZG(2).Ts;
ts_h = pzg_fndo( 1,(12:13),'pzgui_Set_TS');
if ~isempty(ts_h)
  set( ts_h,'string', pzg_efmt(PZG(2).Ts) );
end

return

