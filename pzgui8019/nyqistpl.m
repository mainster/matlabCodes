function  FigHndl = nyqistpl(BodeFreqs, BodeMag, BodePhs, ...
                           ZeroLocs, PoleLocs, Gain, ...
                           PlotName, FrqSelNdx, PlotTitle, ...
                           Position, BtnDwnFn, Domain, Ts )     %#ok<INUSD>
% Creates and services the Nyquist plots, for both C-T and D-T pzgui.

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
FigHndl = [];
if isempty(PZG) && ~pzg_recovr
  return
end
evalin('base','global PZG')

% Check that the input arguments are valid:
if ( nargin == 1 ) && ischar(BodeFreqs)
  if ( strcmpi(BodeFreqs,'s') || strcmpi(BodeFreqs,'z') )
    % Request for Nyquist contour data at infinite magnitudes.
    % Return the Nyquist plot data, rather than the figure handle.
    FigHndl = local_get_nyq_contour(BodeFreqs);
  elseif strcmpi(BodeFreqs,'hybrid scaling')
    local_linlog_rescale
  elseif strcmpi(BodeFreqs,'full out')
    local_full_out
  end
  return
end

if ( nargin < 7 ) || ( nargin > 13 )
  disp('Correct format is:  ');
   disp(' nyqistpl( BodeFreqs, BodeMag, BodePhs, PlotName, ...');
   disp('           ZeroLocs, PoleLocs, Gain ...');
   disp('           <,FrqSelNdx, PlotTitle, Position, ... ');
   disp('             ButtonDownFcn, Domain > )');
  return
end

if nargin < 13
   Ts = 1; %#ok<NASGU>
end
if nargin < 12
   Domain = 's';
end
if ~ischar(Domain) || ( numel(Domain) ~= 1 )
  disp('Input argument, DOMAIN must be either ''z'' or ''s''.');
   return
else
   Domain = lower(Domain);
end
if strcmp(Domain,'s')
  dom_ndx = 1;
else
  dom_ndx = 2;
end

if nargin < 11
  BtnDwnFn = ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
              'catch,pzg_err(''button down'');' ...
              'end,clear tempfs;'];
end
if ( ~ischar(BtnDwnFn) ) || ( min(size(BtnDwnFn) > 1 ) )
  disp('Input argument, ButtonDownFcn must be a simple string.');
  return
end

if nargin < 10
  Position = [];
end
if sum( ( ( size(Position) ~= [1 4] ) | ischar(Position) ) ...
       &( size(Position) ~= [0 0] )) > 0
  disp('Input arg, POSITION must be a 1-by-4 numerical array.');
  return
end

if nargin < 9
  PlotTitle = '';
end
if ( ~ischar(PlotTitle) ) || ( min(size(PlotTitle) > 1 ) )
  disp('Input argument, PLOTTITLE must be a simple string.');
  return
end

if nargin == 8
  if ischar(FrqSelNdx)
    Domain = FrqSelNdx;
    FrqSelNdx = [];
  end
end
if nargin < 8
  FrqSelNdx = [];
end
if numel(FrqSelNdx) > 1
  disp('Input argument, FRQSELNDX must be a scalar.')
  return
elseif isempty(FrqSelNdx) ...
      &&( numel( PZG(dom_ndx).FrqSelNdx ) == 1 )
  FrqSelNdx = PZG(dom_ndx).FrqSelNdx;
end
SlctNdx = [];
tempVis = 'off';
neg_select_freq = 0;
if ( numel(FrqSelNdx) == 1 ) ...
  && ( FrqSelNdx > 0 ) && ( FrqSelNdx <= numel(BodeFreqs) )
  SlctNdx = FrqSelNdx;
  tempVis = 'on';
  if ( dom_ndx == 2 )
    select_freq = mod( BodeFreqs(SlctNdx), 2*pi/PZG(2).Ts );
    if select_freq > pi/PZG(2).Ts
      select_freq = 2*pi/PZG(2).Ts - select_freq;
      neg_select_freq = 1;
    end
    SlctNdx = pzg_gle( BodeFreqs, select_freq,'near');
  elseif PZG(1).NegSelect
    neg_select_freq = 1;
  end
end
if ~PZG(dom_ndx).pzg_show_frf_computation
  tempVis = 'off';
end

if ( ~ischar(PlotName) ) 
  disp('Input argument, PLOTNAME must be a simple string.');
  return
end
if ( min(size(PlotName))~=1 )
  disp('Input argument, PLOTNAME cannot be an empty string.');
  return
end

if ~isreal(BodeFreqs) || ~isreal(BodeMag) || ~isreal(BodePhs)
  disp('Bode data must be real numbers.');
  return
end
if ( numel(BodeFreqs) ~= numel(BodeMag) ) ...
   || ( numel(BodeFreqs) ~= numel(BodePhs) )
  disp('nyqistpl:  Arguments BODEFREQS, BODEMAG, and BODEPHS ');
  disp('           must all be the same length.');
  return
end
if ( min(size(BodeFreqs)) > 1 ) ...
   || ( min(size(BodeMag)) > 1 ) ...
   || ( min(size(BodePhs)) > 1 )
  disp('nyqistpl:  Arguments BODEFREQS, BODEMAG, and BODEPHS ');
  disp('           must column or row vectors.');
   return
else
  if size(BodeFreqs,1) == 1
    BodeFreqs = BodeFreqs.'; %#ok<NASGU>
  end
  if size(BodeMag,1) == 1
    BodeMag = BodeMag.'; %#ok<NASGU>
  end
  if size(BodePhs,1) == 1
    BodePhs = BodePhs.'; %#ok<NASGU>
  end
end
if isempty(Gain)
  disp('Input argument GAIN must be scalar.');
  return
end
if ~isnumeric(PoleLocs) || ~isnumeric(ZeroLocs)
  disp('Input arguments POLELOCS and ZEROLOCS ');
  disp('   must column or row vectors.');
  return
else
  if size(PoleLocs,1) == 1
    PoleLocs = PoleLocs.'; %#ok<NASGU>
  end
  if size(ZeroLocs,1) == 1
    ZeroLocs = ZeroLocs.'; %#ok<NASGU>
  end
end

FigHndl = pzg_fndo( dom_ndx, 7,'fig_h');
if isempty(FigHndl)
  FigHndl = findobj( allchild(0),'Name', PZG(dom_ndx).NyquistName );
  if ~isempty(FigHndl)
    delete(FigHndl)
    FigHndl = [];
  end
end
if ~isempty(FigHndl) && ~isappdata(FigHndl,'hndl')
  delete(FigHndl)
  FigHndl = [];
end
if ~isempty(FigHndl)
  temp0 = get(FigHndl,'userdata');
  if isempty(temp0)
    delete(FigHndl)
    FigHndl = [];
  end
end

bg_color = PZG(dom_ndx).DefaultBackgroundColor;
if ischar(bg_color)
  if strcmpi(bg_color,'k')
    contrast_color = 'w';
    bg_rgb = [1 1 1];
  else
    contrast_color = 'k';
    bg_rgb = [0 0 0];
  end
end
% ----------------------------------------------------------------------
% Refresh the contour data, if necessary.
if ~isequal( PZG(dom_ndx).recompute_frf, 0 ) ...
  || ~isfield( PZG(dom_ndx),'cntr_data') ...
  || isempty( PZG(dom_ndx).cntr_data ) ...
  ||~isstruct( PZG(dom_ndx).cntr_data ) ...
  ||~isfield( PZG(dom_ndx).cntr_data,'contour_freq')
  PZG(dom_ndx).recompute_frf = 0;
  pzg_cntr(dom_ndx);
  pzg_bodex(dom_ndx);
end

hybrid_scaling = 0;
hyb_h = [];
if ~isempty(FigHndl) && ishandle(FigHndl)
  hyb_h = pzg_fndo( dom_ndx, 7,'rescale_checkbox');
end
if ~isempty(hyb_h)
  hybrid_scaling = get( hyb_h,'value');
elseif max(abs(PZG(dom_ndx).cntr_data.Nyquist_pts)) > 20
  hybrid_scaling = 1;
end

if hybrid_scaling
  NyqMapping = PZG(dom_ndx).cntr_data.Nyquist_scaled_pts;
  BodeMapping = PZG(dom_ndx).cntr_data.bode2nyq_scaled_pts;
else
  NyqMapping = PZG(dom_ndx).cntr_data.Nyquist_pts;
  BodeMapping = PZG(dom_ndx).cntr_data.bode2nyq_pts;
end
NyqMapFreqs = PZG(dom_ndx).cntr_data.contour_freq;
BodeMapFreqs = PZG(dom_ndx).cntr_data.bode2nyq_freqs;

% ----------------------------------------------------------------------

XLimit = [ min( -1.1, min(real(NyqMapping)) ) ...
           max( 0, max(real(NyqMapping))) ];

YLimit = [ min( -1.1, min(imag(NyqMapping)) ) ...
           max( 1.1, max(imag(NyqMapping)) ) ];
YLimit = [ -max( abs(YLimit) )   max( abs(YLimit) ) ];

new_figure = 0;
temp0 = [];
if ~isempty(FigHndl)
  temp0 = get(FigHndl,'UserData');
end
if isempty(temp0)
  % No Nyquist figure exists, so create one.
  new_figure = 1;
  temp0 = zeros([10 2]);

  del_str = ...
    ['global PZG,' ...
     'try,' ...
       'if isfield(PZG(' num2str(dom_ndx) ').plot_h{14},''fig_h''),' ...
         'delete(PZG(' num2str(dom_ndx) ').plot_h{14}.fig_h),' ...
         'PZG(' num2str(dom_ndx) ').plot_h{14} = [];' ...
       'end,' ...
       'temp_nyqcb=pzg_fndo(' ...
          num2str(dom_ndx) ',' num2str(11+dom_ndx) ',''Nyquist_checkbox'');' ...
       'if~isempty(temp_nyqcb),' ...
         'set(temp_nyqcb,''value'',0);' ...
       'end,' ...
       'PZG(' num2str(dom_ndx) ').plot_h{7}=[];' ...
     'end,' ...
     'pzg_bkup,' ...
     'clear temp_nyqcb;'];

  FigHndl = ...
    figure('name', PlotName, ...
       'units','normalized', ...
       'color', bg_rgb, ...
       'menubar','figure', ...
       'numbertitle','off', ...
       'integerhandle','off', ...
       'dockcontrols','off', ...
       'visible','off', ...
       'windowbuttonmotionfcn', ...
         ['try,' ...
          'if pzg_disab,return,end,' ...
          'tempfs=freqserv(gcbf);pzg_ptr;' ...
          'catch,pzg_err(''mouse motion nyq'');' ...
          'end,clear tempfs;'], ...
       'WindowButtonDownFcn', BtnDwnFn, ...
       'deletefcn', del_str, ...
       'Interruptible','On', ...
       'tag','PZGUI plot', ...
       'handlevisibility','callback');

  if ~isempty(Position)
    if max(Position) > 1
      % Convert pixel-position to normalized.
      ScrSize = get(0,'screensize');
      Position([1;3]) = Position([1;3])/ScrSize(3);
      Position([2;4]) = Position([2;4])/ScrSize(4);
    end
    set( FigHndl,'Position', Position );
  end
  
  % Put a "Color Options" menu item in the figure's menubar.
  opt_menu_h = ...
    uimenu('parent', FigHndl, ...
           'label', 'PZGUI OPTIONS', ...
           'tag','pzgui_options_menu');
  pzg_menu( opt_menu_h, Domain );
  hndl = getappdata( FigHndl,'hndl');
  
  hndl.plot_name = get( FigHndl,'name');
  hndl.dom_ndx = dom_ndx;
  hndl.ploth_ndx = 7;
  
  gca0 = axes('parent', FigHndl, ...
    'units','normalized', ...
    'xgrid','on', ...
    'ygrid','on', ...
    'color', bg_rgb, ...
    'nextplot','add', ...
    'tag','pzg nyquist plot axes');
  temp0(1,1) = gca0;
  hndl.ax = gca0;
  hndl.ax_title = get(gca0,'title');
  hndl.ax_xlabel = get(gca0,'xlabel');
  hndl.ax_ylabel = get(gca0,'ylabel');
       
  temp0(2,1) = ...
    plot( NyqMapping,'r', ...
      'linestyle','--', ...
      'marker','none', ...
      'markersize', 4, ...
      'LineWidth', 1, ...
      'hittest','off', ...
      'handlevisibility','off', ...
      'parent', gca0, ...
      'userdata', NyqMapFreqs, ...
      'Tag','Nyquist Plot');
  hndl.Nyquist_Plot = temp0(2,1);
  
  hndl.Conjugate_Nyquist_Plot = ...
    plot( conj(NyqMapping), ...
      'color', contrast_color, ...
      'linestyle','--', ...
      'marker','none', ...
      'markersize', 4, ...
      'LineWidth', 1, ...
      'hittest','off', ...
      'handlevisibility','off', ...
      'parent', gca0, ...
      'Tag','Conjugate Nyquist Plot');

  temp0(4,1) = ...
    plot( BodeMapping, ...
      'color','r', ...
      'linestyle','-', ...
      'marker','none', ...
      'markersize', 4, ...
      'LineWidth', 3, ...
      'hittest','off', ...
      'handlevisibility','off', ...
      'parent', gca0, ...
      'userdata', BodeMapFreqs, ...
      'Tag','Bode2Nyq Plot');
  hndl.Bode2Nyq_Plot = temp0(4,1);

  hndl.Conjugate_Bode2Nyq_Plot = ...
    plot( conj(BodeMapping), ...
      'color', contrast_color, ...
      'linestyle','-', ...
      'marker','none', ...
      'markersize', 6, ...
      'LineWidth', 2, ...
      'hittest','off', ...
      'handlevisibility','off', ...
      'parent', gca0, ...
      'Tag',[ Domain ' conjugate Bode2Nyq Plot']);
       
  set( gca0, ...
      'Color', bg_color, ...
      'XColor', contrast_color, ...
      'YColor', contrast_color, ...
      'XLimMode','auto', ...
      'YLimMode','auto')
  ScrSize = get(0,'ScreenSize');
  if ScrSize(3) > 1024
    set(gca0, ...
      'Interruptible','On', ...
      'FontSize',10, ...
      'Position',[0.17 0.17 0.75 0.755] )
  else
    set(gca0, ...
      'Interruptible','On', ...
      'FontSize',8, ...
      'Position',[0.17 0.17 0.75 0.755] )
  end

   % ---------------------------------------------
   UCPts = exp(1i*(0:0.001:2*pi));
   hndl.Unit_Circle_highlight = ...
     plot( UCPts,'c', ...
        'parent', gca0, ...
        'tag','Unit Circle highlight');
   
   hndl.m1_marker = ...
     plot( -1, 0,'ys', ...
       'linewidth', 2, ...
       'markersize', 4, ...
       'hittest','off', ...
       'handlevisibility','off', ...
       'parent', gca0, ...
       'tag','-1 marker');
   
   hndl.Unit_Circle_text = ...
     text( cos(-3/4*pi), sin(-3/4*pi), ...
       {' unit';'   circle'}, ...
       'color','c', ...
       'hittest','off', ...
       'handlevisibility','off', ...
       'parent', gca0, ...
       'tag','Unit Circle text');
     

  % ---------------------------------------------
   % Plot the highlighted frequency, if there is one.
   temp0(3,1) = ...
     plot( 0, 0,'co', ...
       'MarkerSize', 8, ...
       'LineWidth', 3.0, ...
       'hittest','off', ...
       'handlevisibility','off', ...
       'parent', gca0, ...
       'Visible', 'off', ...
       'tag','implicit freq marker');
   set( temp0(3,1),'xdata',[],'ydata',[]);
   hndl.implicit_freq_marker = temp0(3,1);

   hndl.Nyquist_Plot_Xaxis_Highlight = ...
     plot( [XLimit(1);XLimit(end)], [0;0], ...
       'color',[0 0.7 0.7], ...
       'linestyle','--', ...
       'hittest','off', ...
       'handlevisibility','off', ...
       'parent', gca0, ...
       'Tag',[ Domain ' Nyquist Plot X-axis Highlight']);
   hndl.Nyquist_Plot_Yaxis_Highlight = ...
     plot( [0;0], [YLimit(1);YLimit(end)], ...
       'color',[0 0.7 0.7], ...
       'linestyle','--', ...
       'hittest','off', ...
       'handlevisibility','off', ...
       'parent', gca0, ...
       'Tag',[ Domain ' Nyquist Plot Y-axis Highlight']);
  
  set( hndl.ax_title,'string', PlotTitle,'Color', 1-get(FigHndl,'color') );
  temp0(6,1) = hndl.ax_xlabel;
  set( hndl.ax_xlabel,'string','Real Part of FRF');
  set( hndl.ax_ylabel,'string','Imag Part of FRF');
  
  hndl.rescale_checkbox = ...
    uicontrol( FigHndl, ...
      'Style','checkbox', ...
      'Units','normalized', ...
      'Position',[ 0.800 0.005 0.195 0.05 ], ...
      'backgroundcolor', bg_rgb, ...
      'foregroundcolor', 1-bg_rgb, ...
      'value', hybrid_scaling, ...
      'String','Hybrid Scale', ...
      'tooltipstring', ...
        ['"radial-log" outside the unit-circle,' ...
         ' "inverse radial-log" inside it'], ...
      'Tag','rescale checkbox', ...
      'Callback','nyqistpl(''hybrid scaling'');');
    
  % Adjust the background color.
  figopts('apply_default_color', FigHndl )
  
  set( FigHndl,'visible','on')
  
  hndl = local_adjust_scaling( gca0, hybrid_scaling, dom_ndx, hndl );
  
  % Display the number of CCW encirclements.
  nr_CCW_encircs = local_get_nr_CCW_encircs( dom_ndx );
  if nr_CCW_encircs >= 0
    nr_CCW_text = ['   = ' num2str(nr_CCW_encircs)];
  else
    nr_CCW_text = ['   =  - ' num2str(abs(nr_CCW_encircs))];
  end
  temp0(8,1) = ...
    uicontrol( FigHndl,'style','text', ...
      'units','normalized', ...
      'position',[0 0.900 0.140 0.089], ...
      'string',{'# of CCW';'encirclmnts'}, ...
      'fontsize', 8, ...
      'fontweight','bold', ...
      'horizontalalignment','center', ...
      'backgroundcolor', get(FigHndl,'color'), ...
      'foregroundcolor',[ 0 1 1 ], ...
      'tag','CCW encircs text');
  temp0(8,2) = ...
    uicontrol( FigHndl,'style','text', ...
      'units','normalized', ...
      'position',[0 0.840 0.120 0.059], ...
      'string', nr_CCW_text, ...
      'fontsize', 12, ...
      'fontweight','bold', ...
      'horizontalalignment','center', ...
      'backgroundcolor', get(FigHndl,'color'), ...
      'foregroundcolor',[ 0 1 1 ], ...
      'tag','# of CCW encircs text');
  hndl.nr_of_CCW_encircs_uitext = temp0(8,2);
  
  set( FigHndl,'UserData', temp0 );
  
  XLimit = get( gca0,'XLim');
  YLimit = get( gca0,'YLim');  
  hndl.ax_xlim = XLimit;
  hndl.ax_ylim = YLimit;  
  setappdata( FigHndl,'hndl', hndl );
  pzg_cphndl( FigHndl, dom_ndx, 7 );
  
  if PZG(dom_ndx).pzg_show_frf_computation
    freqserv('refresh selected_freq');
  end
  
else
  % Nyquist figure already exists.
  if isappdata(FigHndl,'hndl')
    hndl = getappdata(FigHndl,'hndl');
    gca0 = hndl.ax;
  else
    hndl = [];
    gca0 = get(FigHndl,'currentaxes');
  end
  if numel(NyqMapping) > 1
    set( temp0(2,1), ...
        'Xdata',real(NyqMapping), ...
        'Ydata',imag(NyqMapping), ...
        'userdata', NyqMapFreqs, ...
        'Visible','on' );
      
    set( temp0(4,1), ...
        'Xdata',real(BodeMapping), ...
        'Ydata',imag(BodeMapping), ...
        'Visible','on');
    
    if isfield( hndl,'Conjugate_Nyquist_Plot')
      tempH = hndl.Conjugate_Nyquist_Plot;
    else
      tempH = findobj(gca0,'Tag','Conjugate Nyquist Plot');
    end
    if ~isempty(tempH)
       set( tempH, ...
           'color', ( 1 - get(gca0,'color') ), ...
           'Xdata', real(NyqMapping), ...
           'Ydata', -imag(NyqMapping), ...
           'Visible','on')
    else
      tempH = ...
        plot( conj(NyqMapping), ...
           'linestyle','none', ...
           'LineWidth', 1, ...
           'marker','.', ...
           'markersize', 4, ...
           'hittest','off', ...
           'handlevisibility','off', ...
           'parent', gca0, ...
           'Tag','Conjugate Nyquist Plot');
      if ~isempty(hndl)
        hndl.Conjugate_Nyquist_Plot = tempH;
        setappdata( FigHndl,'hndl', hndl );
      end
    end
    
    if isfield( hndl,'Conjugate_Bode2Nyq_Plot')
      tempH = hndl.Conjugate_Bode2Nyq_Plot;
    else
      tempH = findobj(gca0,'Tag',[ Domain ' conjugate Bode2Nyq Plot']);
    end
    if ~isempty(tempH)
      set( tempH, ...
          'Xdata', real(BodeMapping), ...
          'Ydata', -imag(BodeMapping), ...
          'color',( 1 - get(gca0,'color') ), ...
          'Visible','on')
        
    elseif ~isempty(BodeMapping)
      tempH = ...
        plot( conj(BodeMapping), ...
           'color',( 1 - get(gca0,'color') ), ...
           'linestyle','-', ...
           'LineWidth', 2, ...
           'marker','none', ...
           'markersize', 6, ...
           'hittest','off', ...
           'handlevisibility','off', ...
           'parent', gca0, ...
           'Tag',[ Domain ' conjugate Bode2Nyq Plot']);
      if ~isempty(hndl)
        hndl.Conjugate_Bode2Nyq_Plot = tempH;
        setappdata( FigHndl,'hndl', hndl );
      end
    end
    
    % Adjust scaling, if needed
    hybrid_scaling = 0;
    if isfield( hndl,'rescale_checkbox')
      hyb_h = hndl.rescale_checkbox;
    else
      hyb_h = findobj( FigHndl,'tag','rescale checkbox');
    end
    if ~isempty(hyb_h)
      hybrid_scaling = get( hyb_h,'value');
    end
    if hybrid_scaling
      if Domain == 's'
        hndl = local_adjust_scaling( gca0, hybrid_scaling, 1, hndl );
      else
        hndl = local_adjust_scaling( gca0, hybrid_scaling, 2, hndl );
      end
    end
  else
    set( temp0(2,1),'Xdata',0,'Ydata',0,'userdata',[],'Visible','off' );
    set( temp0(4,1),'Xdata',0,'Ydata',0,'Visible','off' );
    
    if isfield( hndl,'Conjugate_Nyquist_Plot')
      tempH = hndl.Conjugate_Nyquist_Plot;
    else
      tempH = findobj(gca0,'Tag','Conjugate Nyquist Plot');
    end
    if ~isempty(tempH)
      set( tempH,'Xdata', 0,'Ydata', 0,'Visible','Off')
    end
  end
  if ~isempty(SlctNdx) && ( SlctNdx > 0 ) && ( SlctNdx <= numel(BodeMapping) )
    set( temp0(3,1), ...
        'Xdata', real(BodeMapping(SlctNdx)), ...
        'Ydata', imag(BodeMapping(SlctNdx)), ...
        'Visible', tempVis );
  else
    set( temp0(3,1),'Visible','off');
  end
  
  nr_CCW_encircs = local_get_nr_CCW_encircs( dom_ndx );
  if nr_CCW_encircs >= 0
    nr_CCW_text = ['   = ' num2str(nr_CCW_encircs)];
  else
    nr_CCW_text = ['   =  - ' num2str(abs(nr_CCW_encircs))];
  end
  set( temp0(8,2),'string', nr_CCW_text )
end

freqserv('refresh_plot_h', FigHndl );
pzg_seltxt(dom_ndx)

if isfield( hndl,'Nyquist_Plot_Xaxis_Highlight')
  tempXHi = hndl.Nyquist_Plot_Xaxis_Highlight;
else
  tempXHi = findobj( FigHndl,'Tag',[ Domain ' Nyquist Plot X-axis Highlight']);
end
if isfield( hndl,'Nyquist_Plot_Yaxis_Highlight')
  tempYHi = hndl.Nyquist_Plot_Yaxis_Highlight;
else
  tempYHi = findobj( FigHndl,'Tag',[ Domain ' Nyquist Plot Y-axis Highlight']);
end
if ( diff(XLimit) > 1e4 ) && ( diff(YLimit) > 1e4 )
  set( [tempXHi;tempYHi],'visible','off')
  set( gca0,'xlimmode','auto','ylimmode','auto')
  XLimit = get( gca0,'xlim');
  YLimit = get( gca0,'ylim');
  set( tempXHi,'xdata', XLimit,'ydata', [0 0] )
  set( tempYHi,'xdata', [0 0],'ydata', YLimit )
  set( [tempXHi;tempYHi],'visible','on')
else
  if ~isempty(tempXHi)
    set( tempXHi,'Xdata',get( get(tempXHi,'Parent'),'XLim') )
  end
  if ~isempty(tempYHi)
    set( tempYHi,'Ydata',get( get(tempYHi,'Parent'),'YLim') )
  end
end

fig_color = get(FigHndl,'color');
if isfield( hndl,'rescale_checkbox')
  rescale_h = hndl.rescale_checkbox;
else
  rescale_h = findobj( FigHndl,'Tag','rescale checkbox');
end

if isfield( hndl,'equimargin_checkbox')
  tempH5 = hndl.equimargin_checkbox;
else
  tempH5 = findobj( get(gca0,'parent'),'tag','equimargin checkbox');
end
if isempty(tempH5)
  hndl.equimargin_checkbox = ...
    uicontrol( FigHndl, ...
     'style','checkbox', ...
     'units','normalized', ...
     'position',[0.580 0.005 0.20 0.05], ...
     'backgroundcolor', fig_color, ...
     'foregroundcolor', 1-fig_color, ...
     'string','equi-margins', ...
     'value', 0, ...
     'tooltipstring','show the gainphase equi-margin grid', ...
     'tag','equimargin checkbox', ...
     'callback', ...
       ['global PZG,' ...
          'try,' ...
           'if get(gcbo,''value''),' ...
             'set(PZG(' num2str(dom_ndx) ').plot_h{7}.hndl.equimargin_grid,' ...
                  '''visible'',''on'');' ...
             'set(PZG(' num2str(dom_ndx) ').plot_h{7}.hndl.equimargin_text,' ...
                  '''visible'',''on'');' ...
           'else,' ...
             'set(PZG(' num2str(dom_ndx) ').plot_h{7}.hndl.equimargin_grid,' ...
                  '''visible'',''off'');' ...
             'set(PZG(' num2str(dom_ndx) ').plot_h{7}.hndl.equimargin_text,' ...
                  '''visible'',''off'');' ...
           'end,' ...
          'catch,' ...
           'pzg_err(''nyquist equi-margin checkbox'');' ...
          'end']);
end

title_str = get( FigHndl,'name');
del_ndx = strfind( title_str,' System');
if ~isempty(del_ndx)
  title_str(del_ndx(1):del_ndx(1)+6) = '';
  if hybrid_scaling
    title_str = [ title_str ' (Nonlinear Scale)'];
  end
  if ~strcmp( get(hndl.ax_title,'string'), title_str )
    set( hndl.ax_title,'string', title_str );
  end
end

if isfield( hndl,'Closeup_Pushbutton')
  tempH = hndl.Closeup_Pushbutton;
else
  tempH = findobj( FigHndl,'Tag','Closeup Pushbutton');
end
if isempty(tempH)
  hndl.Closeup_Pushbutton = ...
    uicontrol( FigHndl, ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[ 0.005 0.005 0.12 0.05 ], ...
      'String','Unit Circ', ...
      'tooltipstring','zoom in to region of the unit circle', ...
      'Tag','Closeup Pushbutton', ...
      'Callback', ...
        ['global PZG,' ...
         'temp_gcba=PZG(' num2str(dom_ndx) ').plot_h{7}.ax_h;' ...
         'set(temp_gcba,''xlim'',[-1.2 1.2],''xlimmode'',''manual'',' ...
              '''ylim'',[-1.05 1.05],''ylimmode'',''manual'');' ...
         'temp_hyb_h=PZG(' num2str(dom_ndx) ...
            ').plot_h{7}.hndl.rescale_checkbox;' ...
         'if get(temp_hyb_h,''value''),' ...
           'set(temp_gcba,''xticklabel'','''','...
                         '''xticklabelmode'',''manual'',' ...
                         '''yticklabel'','''',' ...
                         '''yticklabelmode'',''manual'');' ...
         'else,' ...
           'set(temp_gcba,''xticklabelmode'',''auto'',' ...
                         '''yticklabelmode'',''auto'');' ...
         'end,' ...
         'temp_hilite_x=pzg_fndo(' num2str(dom_ndx) ...
                          ',7,''Nyquist_Plot_Xaxis_Highlight'');' ...
         'if~isempty(temp_hilite_x),' ...
           'set(temp_hilite_x,''xdata'',[-1.2 1.2],''ydata'',[0 0]);' ...
         'end,' ...
         'temp_hilite_y=pzg_fndo(' num2str(dom_ndx) ...
                          ',7,''Nyquist_Plot_Yaxis_Highlight'');' ...
         'if~isempty(temp_hilite_y),' ...
           'set(temp_hilite_y,''xdata'',[0 0],''ydata'',[-1.05 1.05]);' ...
         'end,' ...
         'drawnow,' ...
         'temp_xlim=get(temp_gcba,''xlim'');' ...
         'temp_ylim=get(temp_gcba,''ylim'');' ...
         'temp_hndl=getappdata(gcbf,''hndl'');' ...
         'temp_hndl.ax_xlim=temp_xlim;' ...
         'temp_hndl.ax_ylim=temp_ylim;' ...
         'setappdata(gcbf,''hndl'',temp_hndl);' ...
         'PZG(' num2str(dom_ndx) ').plot_h{7}.xlim=temp_xlim;' ...
         'PZG(' num2str(dom_ndx) ').plot_h{7}.hndl.ax_xlim=temp_xlim;' ...
         'PZG(' num2str(dom_ndx) ').plot_h{7}.ylim=temp_ylim;' ...
         'PZG(' num2str(dom_ndx) ').plot_h{7}.hndl.ax_ylim=temp_ylim;' ...
         'clear temp_hilite_x temp_hilite_y temp_hyb_h temp_gcba,' ...
         'clear temp_xlim temp_ylim']);
end

if isfield( hndl,'FarOut_Pushbutton')
  tempH = hndl.FarOut_Pushbutton;
else
  tempH = findobj( FigHndl,'Tag','FarOut Pushbutton');
end
if isempty(tempH)
  hndl.FarOut_Pushbutton = ...
    uicontrol( FigHndl, ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[ 0.005 0.06 0.12 0.05 ], ...
      'String','Full Out', ...
      'tooltipstring','show the entire plot', ...
      'Tag','FarOut Pushbutton', ...
      'Callback', [ mfilename '(''full out'');']);
end

if isfield( hndl,'show_contour_pushbutton')
  tempH = hndl.show_contour_pushbutton;
else
  tempH = findobj( FigHndl,'Tag','show-contour pushbutton');
end
if isempty(tempH)
  hndl.show_contour_pushbutton = ...
    uicontrol( FigHndl, ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[ 0.14 0.005 0.24 0.04 ], ...
      'String','Show Nyq Contour', ...
      'tooltipstring','show the Nyquist Contour', ...
      'Tag','show-contour pushbutton', ...
      'Callback', ...
        ['contourpl(''bring forward'',' num2str(dom_ndx) ');']);
end

% Determine whether the plot should be automatically hybrid scaled.
if new_figure ...
  && isfield(PZG(dom_ndx),'cntr_data') ...
  && isfield(PZG(dom_ndx).cntr_data,'ld_poles') ...
  && ~isempty(PZG(dom_ndx).cntr_data.ld_poles)
  hybrid_scaling = 1;
  set( rescale_h,'value', 1 );
  hndl = local_adjust_scaling( gca0, hybrid_scaling, dom_ndx, hndl );
end

if new_figure
  pzg_prvw( dom_ndx );
end

hndl.ax_xlim = get( hndl.ax,'xlim');
hndl.ax_ylim = get( hndl.ax,'ylim');
setappdata( FigHndl,'hndl', hndl );
pzg_cphndl( FigHndl, dom_ndx, 7 );

set( FigHndl,'doublebuffer','on');

return

% ////////////////////////////////////////////////////////////
% LOCAL FUNCTIONS
function local_full_out
  global PZG
  if isempty(gcbf)
    return
  end
  if isempty( strfind( get(gcbf,'name'),'Continuous') )
    dom_ndx = 2;
  else
    dom_ndx = 1;
  end
  if isempty( PZG(dom_ndx).plot_h{7} ) ...
    || ~isfield( PZG(dom_ndx).plot_h{7},'ax_h')
    return
  end
  hndl = getappdata( PZG(dom_ndx).plot_h{7}.fig_h,'hndl');
  temp_ax = PZG(dom_ndx).plot_h{7}.ax_h;
  xaxis_hilite_h = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Xaxis_Highlight');
  if isempty(xaxis_hilite_h)
    xaxis_hilite_h = ...
      [ findobj( allchild(temp_ax),'tag','s Nyquist Plot X-axis Highlight'); ...
        findobj( allchild(temp_ax),'tag','z Nyquist Plot X-axis Highlight') ];
  end
  yaxis_hilite_h = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Yaxis_Highlight');
  if isempty(yaxis_hilite_h)
    yaxis_hilite_h = ...
      [ findobj( allchild(temp_ax),'tag','s Nyquist Plot Y-axis Highlight'); ...
        findobj( allchild(temp_ax),'tag','z Nyquist Plot Y-axis Highlight') ];
  end
  if ~isempty( xaxis_hilite_h)
    set( xaxis_hilite_h,'visible','off')
  end
  if ~isempty( yaxis_hilite_h)
    set( yaxis_hilite_h,'visible','off')
  end
  
  set( temp_ax,'XLimmode','auto','YLimmode','auto');
  temp_xlim = get( temp_ax,'xlim'); 
  temp_ylim = get( temp_ax,'ylim'); 
  if temp_xlim(2) > 1.5
    temp_xlim(1) = min( -2, temp_xlim(1) ); 
  elseif temp_xlim(2) > 1.25
    temp_xlim(1) = min( -1.5, temp_xlim(1) ); 
  elseif temp_xlim(2) > 1.1
    temp_xlim(1) = min( -1.25, temp_xlim(1) ); 
  end
  drawnow
  if ~isempty( xaxis_hilite_h)
    set( xaxis_hilite_h,'xdata', temp_xlim,'visible','on')
  end
  if ~isempty( yaxis_hilite_h)
    set( yaxis_hilite_h,'ydata', temp_ylim,'visible','on')
  end
  hndl.ax_xlim = temp_xlim;
  hndl.ax_ylim = temp_ylim;
  setappdata( PZG(dom_ndx).plot_h{7}.fig_h,'hndl', hndl );
  PZG(dom_ndx).plot_h{7}.xlim = temp_xlim;
  PZG(dom_ndx).plot_h{7}.hndl.ax_xlim = temp_xlim;
  PZG(dom_ndx).plot_h{7}.ylim = temp_ylim;
  PZG(dom_ndx).plot_h{7}.hndl.ax_ylim = temp_ylim;
  
return

function NyqPlotData = local_get_nyq_contour( Domain )

  global PZG
  
  NyqPlotData = []; 
  if ~nargin
    return
  end
  if isequal( Domain, 1 )
    Domain = 's';
  elseif isequal( Domain, 2 )
    Domain = 'z';
  end
  
  if strcmpi(Domain,'s')
    dom_ndx = 1;
  else
    dom_ndx = 2;
  end
    
  NyqPlotData.poles = PZG(dom_ndx).cntr_data.ld_poles;
  if dom_ndx == 1
    NyqPlotData.pole_freqs = abs(NyqPlotData.poles);
  else
    NyqPlotData.pole_freqs = imag(log(NyqPlotData.poles)/PZG(2).Ts);
  end
  NyqPlotData.pole_rep = PZG(dom_ndx).cntr_data.ld_pole_rep;
  NyqPlotData.direction = PZG(dom_ndx).cntr_data.encirc_dir;
  
  NyqPlotData.contour_freqs = PZG(dom_ndx).cntr_data.contour_freq;
  NyqPlotData.contour_pts = PZG(dom_ndx).cntr_data.contour_pts;
  
  NyqPlotData.cplxbode = PZG(dom_ndx).cntr_data.Nyquist_pts;
  NyqPlotData.full_cplx_bode = NyqPlotData.cplxbode;
  NyqPlotData.scaled_cplxbode = PZG(dom_ndx).cntr_data.Nyquist_scaled_pts;
  
  if dom_ndx == 1
    NyqPlotData.rhp_contour_ndxs = ...
      find( real(PZG(dom_ndx).cntr_data.contour_pts) > 1e-12 );
  else
    NyqPlotData.rhp_contour_ndxs = ...
      find( abs(PZG(dom_ndx).cntr_data.contour_pts) > 1+1e-12 );
  end
  NyqPlotData.rhp_contour_pts = ...
    NyqPlotData.contour_pts(NyqPlotData.rhp_contour_ndxs);

 % NyqPlotData.diff_angle = diff( PZG(dom_ndx).cntr_data.Nichols_phs );

return

function local_linlog_rescale
  global PZG
  
  if isempty(gcbf)
    return
  end
  gcbf_name = get( gcbf,'name');
  if isempty( strfind( gcbf_name,'Discrete-Time') )
    dom_ndx = 1;
    dom_str = 's';
  else
    dom_ndx = 2;
    dom_str = 'z';
  end
  
  % Turn off root-locus gein-previews
  parmK_h = ...
    [ pzg_fndo( (1:2), 7,'parameter_K_effect_line'); ...
      pzg_fndo( (1:2), 7,'parameter_K_effect_prvw_line') ];
  if ~isempty(parmK_h)
    set( parmK_h,'visible','off');
  end
  
  % Get current scaling.
  rescale_h = pzg_fndo( dom_ndx, 7,'rescale_checkbox');
  if isempty(rescale_h)
    return
  end
  hybrid_scaling = get( rescale_h,'value');
 
  if ~isempty( PZG(dom_ndx).plot_h{7}) ...
    && isfield( PZG(dom_ndx).plot_h{7},'ax_h')
    ax_h = PZG(dom_ndx).plot_h{7}.ax_h;
  else
    ax_h = pzg_fndo( dom_ndx, 7,'ax');
  end
  if isfield( PZG(dom_ndx).plot_h{7},'hndl')
    hndl = PZG(dom_ndx).plot_h{7}.hndl;
  else
    hndl = [];
  end
  
  hndl = local_adjust_scaling( ax_h, hybrid_scaling, dom_ndx, hndl );
  hndl = local_equimargin_grid( ax_h, hybrid_scaling, hndl ); 
  
  title_str = get( get(ax_h,'parent'),'name');
  del_ndx = strfind( title_str,' System');
  if ~isempty(del_ndx)
    title_str(del_ndx(1):del_ndx(1)+6) = '';
    if hybrid_scaling
      title_str = [ title_str ' (Nonlinear Scale)'];
    end
    set( get(ax_h,'title'),'string', title_str );
  end
  % Rescale the Pure Gain lines, if they exist.
  gain_line_h = pzg_fndo( dom_ndx, 7,'Gain_Preview');
  if isempty(gain_line_h)
    gain_line_h = findobj( allchild(ax_h),'tag',[ dom_str 'Gain Preview']);
  end
  if numel(gain_line_h) == 2
    ud_line = get(gain_line_h(1),'userdata');
    if ~isempty(ud_line) && isstruct(ud_line) ...
      && isfield( ud_line,'scaled_OLCplxBode') ...
      && isfield( ud_line,'OLCplxBode')
      if hybrid_scaling
        xdata = real( ud_line.scaled_OLCplxBode );
        ydata = imag( ud_line.scaled_OLCplxBode );
      else
        xdata = real( ud_line.OLCplxBode );
        ydata = imag( ud_line.OLCplxBode );
      end
      set( gain_line_h(2),'xdata', xdata,'ydata', ydata ); % First line.
      set( gain_line_h(1),'xdata', xdata,'ydata', -ydata );
    end
  end
  
  % Rescale the Gain lines, if they exist.
  gain_line_h = pzg_fndo( dom_ndx, 7,'Gain_Preview');
  if numel(gain_line_h) == 2
    ud_line = get(gain_line_h(1),'userdata');
    if ~isempty(ud_line) && isstruct(ud_line) ...
      && isfield( ud_line,'scaled_OLCplxBode') ...
      && isfield( ud_line,'OLCplxBode')
      if hybrid_scaling
        xdata = real( ud_line.scaled_OLCplxBode );
        ydata = imag( ud_line.scaled_OLCplxBode );
      else
        xdata = real( ud_line.OLCplxBode );
        ydata = imag( ud_line.OLCplxBode );
      end
      set( gain_line_h(1),'xdata', xdata,'ydata', ydata );
      set( gain_line_h(2),'xdata', xdata,'ydata', -ydata );
    end
  end
  
  % Rescale the Lead-Lag lines, if they exist.
  ldlg_line_h = pzg_fndo( dom_ndx, 7,'LDLG_Preview');
  if numel(ldlg_line_h) == 2
    ud_line = get(ldlg_line_h(1),'userdata');
    if ~isempty(ud_line) && isstruct(ud_line) ...
      && isfield( ud_line,'scaled_OLCplxBode') ...
      && isfield( ud_line,'OLCplxBode')
      if hybrid_scaling
        xdata = real( ud_line.scaled_OLCplxBode );
        ydata = imag( ud_line.scaled_OLCplxBode );
      else
        xdata = real( ud_line.OLCplxBode );
        ydata = imag( ud_line.OLCplxBode );
      end
      set( ldlg_line_h(1),'xdata', xdata,'ydata', ydata );
      set( ldlg_line_h(2),'xdata', xdata,'ydata', -ydata );
    end
  end

  xaxis_hilite_h = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Xaxis_Highlight');
  if isempty(xaxis_hilite_h)
    xaxis_hilite_h = ...
      [ findobj( allchild(ax_h),'tag','s Nyquist Plot X-axis Highlight'); ...
        findobj( allchild(ax_h),'tag','z Nyquist Plot X-axis Highlight') ];
  end
  yaxis_hilite_h = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Yaxis_Highlight');
  if isempty(yaxis_hilite_h)
    yaxis_hilite_h = ...
      [ findobj( allchild(ax_h),'tag','s Nyquist Plot Y-axis Highlight'); ...
        findobj( allchild(ax_h),'tag','z Nyquist Plot Y-axis Highlight') ];
  end

  % Rescale the PID lines, if they exist.
  pid_line_h = pzg_fndo( dom_ndx, 7,'PID_Preview');
  if numel(pid_line_h) == 2
    ud_line = get(pid_line_h(1),'userdata');
    if ~isempty(ud_line) && isstruct(ud_line) ...
      && isfield( ud_line,'scaled_OLCplxBode') ...
      && isfield( ud_line,'OLCplxBode')
      if hybrid_scaling
        xdata = real( ud_line.scaled_OLCplxBode );
        ydata = imag( ud_line.scaled_OLCplxBode );
      else
        xdata = real( ud_line.OLCplxBode );
        ydata = imag( ud_line.OLCplxBode );
      end
      set( pid_line_h(1),'xdata', xdata,'ydata', ydata );
      set( pid_line_h(2),'xdata', xdata,'ydata', -ydata );
    end
    
    % Adjust the x-axis and y-axis, and their hilite lines.
    x_lim = get( ax_h,'xlim');
    y_lim = get( ax_h,'ylim');
    set( xaxis_hilite_h,'xdata', x_lim,'ydata', [0 0] );
    set( yaxis_hilite_h,'xdata', [0 0],'ydata', y_lim );
    set( [xaxis_hilite_h;yaxis_hilite_h],'visible','on');
  end
  
  % Rescale the selected point, if it exists.
  select_h = PZG(dom_ndx).plot_h{7}.hndl.implicit_freq_marker;
  if ~isempty(select_h)
    if isfield( PZG(dom_ndx),'NyqSelNdx') ...
      && ~isempty( PZG(dom_ndx).NyqSelNdx ) ...
      && ( PZG(dom_ndx).NyqSelNdx > 0 ) ...
      && ( PZG(dom_ndx).NyqSelNdx <= numel(PZG(dom_ndx).cntr_data.contour_pts) )
      if hybrid_scaling
        selected_pt = ...
          PZG(dom_ndx).cntr_data.Nyquist_scaled_pts(PZG(dom_ndx).NyqSelNdx);
      else
        selected_pt = ...
          PZG(dom_ndx).cntr_data.Nyquist_pts(PZG(dom_ndx).NyqSelNdx);
      end
      if isfield( PZG(dom_ndx),'NegSelect') ...
          && isequal( 1, numel(PZG(dom_ndx).NegSelect) ) ...
          && PZG(dom_ndx).NegSelect
        set( select_h,'xdata', real(selected_pt),'ydata', -imag(selected_pt) )
      else
        set( select_h,'xdata', real(selected_pt),'ydata', imag(selected_pt) )
      end
    end

    % Adjust the x-axis and y-axis, and their hilite lines.
    x_lim = get( ax_h,'xlim');
    y_lim = get( ax_h,'ylim');
    set( xaxis_hilite_h,'xdata', x_lim,'ydata', [0 0] );
    set( yaxis_hilite_h,'xdata', [0 0],'ydata', y_lim );
    set( [xaxis_hilite_h;yaxis_hilite_h],'visible','on');
    
    PZG(dom_ndx).plot_h{7}.xlim = x_lim;
    PZG(dom_ndx).plot_h{7}.ylim = y_lim;
    PZG(dom_ndx).plot_h{7}.hndl.ax_xlim = x_lim;
    PZG(dom_ndx).plot_h{7}.hndl.ax_ylim = y_lim;
    if ~isempty(hndl)
      hndl.ax_xlim = x_lim;
      hndl.ax_ylim = y_lim;
      setappdata( PZG(dom_ndx).plot_h{7}.fig_h,'hndl', hndl );
    end
  end
return

function hndl = local_adjust_scaling( ax_h, hybrid_scaling, dom_ndx, hndl )

  global PZG
  
  if ~nargin
    errdlg_h = ...
      errordlg({'Three input arguments are required by this function.'; ...
                ' ';'    Click "OK" to continue ...';' '}, ...
               'nyqistpl\local_adjust_scaling Error');
    uiwait(errdlg_h)
    return
  elseif nargin < 2
    if ~isreal(ax_h) || ~isequal( numel(ax_h), 1 )
      return
    end
    fig_h = get( ax_h,'parent');
    if nargin < 4
      hndl = getappdata(fig_h,'hndl');
    end
    if isfield( hndl,'rescale_checkbox')
      rescale_h = hndl.rescale_checkbox;
    else
      rescale_h = findobj( fig_h,'tag','rescale checkbox');
    end
    if isempty(rescale_h)
      return
    end
    hybrid_scaling = get( rescale_h,'value');
  end
  if nargin < 3
    nyq_name = get( get(ax_h,'parent'),'name');
    if isempty( strfind( nyq_name,'Discrete-Time') )
      dom_ndx = 1;
    else
      dom_ndx = 2;
    end
  end
  
  % Determine current scaling.
  if isfield( hndl,'Nyquist_Plot')
    nyqplot_h = hndl.Nyquist_Plot;
  else
    nyqplot_h = findobj( allchild(ax_h),'tag','Nyquist Plot');
  end
  nyqplot_data = ...
    get( nyqplot_h,'xdata') + 1i*get( nyqplot_h,'ydata');
  actual_max_mag = max( abs(PZG(dom_ndx).cntr_data.contour_mapping) );
  if actual_max_mag > 1
    plot_max_mag = max( abs(nyqplot_data) );
    if plot_max_mag < 0.99*actual_max_mag
      hybrid_scaling_state = 1;
    else
      hybrid_scaling_state = 0;
    end
  else
    actual_min_mag = min( abs(PZG(dom_ndx).cntr_data.contour_mapping) );
    abs_nyqplot_data = abs(nyqplot_data);
    plot_min_mag = min( abs_nyqplot_data( abs(abs_nyqplot_data) > 0 ) );
    if plot_min_mag > actual_min_mag
      hybrid_scaling_state = 1;
    else
      hybrid_scaling_state = 0;
    end
  end
  
  if hybrid_scaling_state == hybrid_scaling
    % Scaling is already as indicated.
    % Don't return, because the tick-strings might need updating.
    % return
  end
  
  % Get all the plot objects.
  if isfield( hndl,'Nyquist_Plot_Xaxis_Highlight')
    xaxis_hilite_h = hndl.Nyquist_Plot_Xaxis_Highlight;
  elseif dom_ndx == 1
    xaxis_hilite_h = ...
      findobj( allchild(ax_h),'type','line', ...
        'tag','s Nyquist Plot X-axis Highlight');
  else
    xaxis_hilite_h = ...
      findobj( allchild(ax_h),'type','line', ...
        'tag','z Nyquist Plot X-axis Highlight');
  end
  if ~isempty(xaxis_hilite_h)
    set( xaxis_hilite_h,'visible','off');
  end
  if isfield( hndl,'Nyquist_Plot_Yaxis_Highlight')
    yaxis_hilite_h = hndl.Nyquist_Plot_Yaxis_Highlight;
  elseif dom_ndx == 1
    yaxis_hilite_h = ...
      findobj(  allchild(ax_h),'type','line', ...
        'tag','s Nyquist Plot Y-axis Highlight');
  else
    yaxis_hilite_h = ...
      findobj( allchild(ax_h),'type','line', ...
        'tag','z Nyquist Plot Y-axis Highlight');
  end
  if ~isempty(yaxis_hilite_h)
    set( yaxis_hilite_h,'visible','off');
  end
  
  plotobj_h = allchild(ax_h);
  plotobj_tag = get( plotobj_h,'tag');
  for k = 1:numel(plotobj_h)
    
    switch plotobj_tag{k}
      
      case {'mouse motion phs text', ...
            'mouse motion mag text', ...
            'mouse motion freq text'}
        text_pos = get( plotobj_h(k),'position');
        text_loc = text_pos(1) + 1i*text_pos(2);
        loc_mag = abs(text_loc);
        loc_phs = angle(text_loc);
        if hybrid_scaling
          if loc_mag > 1
            loc_mag = 1 + log10(loc_mag);
          end
        else
          if loc_mag > 1
            loc_mag = 10^( loc_mag - 1 );
          end
        end
        text_loc = loc_mag * exp( 1i*loc_phs );
        text_pos(1) = real(text_loc);
        text_pos(2) = imag(text_loc);
        set( plotobj_h(k),'position', text_pos );
      
      case 'Nyquist Plot'
        if hybrid_scaling
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.Nyquist_scaled_pts), ...
              'ydata', imag(PZG(dom_ndx).cntr_data.Nyquist_scaled_pts), ...
              'visible','on');
        else
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.Nyquist_pts), ...
              'ydata', imag(PZG(dom_ndx).cntr_data.Nyquist_pts), ...
              'visible','on');
        end
        
      case 'Conjugate Nyquist Plot'
        if hybrid_scaling
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.Nyquist_scaled_pts), ...
              'ydata', -imag(PZG(dom_ndx).cntr_data.Nyquist_scaled_pts), ...
              'visible','on');
        else
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.Nyquist_pts), ...
              'ydata', -imag(PZG(dom_ndx).cntr_data.Nyquist_pts), ...
              'visible','on');
        end
        
      case 'Bode2Nyq Plot'
        if hybrid_scaling
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.bode2nyq_scaled_pts), ...
              'ydata', imag(PZG(dom_ndx).cntr_data.bode2nyq_scaled_pts), ...
              'visible','on');
        else
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.bode2nyq_pts), ...
              'ydata', imag(PZG(dom_ndx).cntr_data.bode2nyq_pts), ...
              'visible','on');
        end
        
      case {'s conjugate Bode2Nyq Plot','z conjugate Bode2Nyq Plot'}
        if hybrid_scaling
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.bode2nyq_scaled_pts), ...
              'ydata', -imag(PZG(dom_ndx).cntr_data.bode2nyq_scaled_pts), ...
              'visible','on');
        else
          set( plotobj_h(k), ...
              'xdata', real(PZG(dom_ndx).cntr_data.bode2nyq_pts), ...
              'ydata', -imag(PZG(dom_ndx).cntr_data.bode2nyq_pts), ...
              'visible','on');
        end
        
      case {'implicit freq marker', ...
            'mouse motion freq line', ...
            'mouse motion freq marker', ...
            'Nyquist Plot markers'}
        xdata = get( plotobj_h(k),'xdata');
        ydata = get( plotobj_h(k),'ydata');
        if ~isempty(xdata) ...
          && ( numel(xdata) == numel(ydata) )
          cplxdata = xdata + 1i*ydata;
          if hybrid_scaling && ~hybrid_scaling_state
            % Convert from normal scaling to hybrid.
            cplxdata = pzg_sclpt( cplxdata );    % Forward scaling.
          elseif ~hybrid_scaling && hybrid_scaling_state
            % Convert from hybrid scaling to normal.
            cplxdata = pzg_sclpt( cplxdata, 1 ); % Reverse scaling.
          end
          set( plotobj_h(k),'xdata', real(cplxdata),'ydata', imag(cplxdata) );
        end
      otherwise
    end
  end
  
  % Turn off visibility of the LDLG or PID lines, if any.
  curr_tools = pzg_tools(dom_ndx);
  if curr_tools(1)
    prvw_line_h = pzg_fndo( dom_ndx, 7,'Gain_Preview');
  elseif curr_tools(2)
    prvw_line_h = pzg_fndo( dom_ndx, 7,'LDLG_Preview');
  elseif curr_tools(3)
    prvw_line_h = pzg_fndo( dom_ndx, 7,'PID_Preview');
  else
    prvw_line_h = [];
  end
  if ~isempty(prvw_line_h)
    init_prvw_vis = get(prvw_line_h(1),'visible');
    set( prvw_line_h,'visible','off');
  end
  
  x_lim = get( ax_h,'xlim');
  y_lim = get( ax_h,'ylim');
  if hybrid_scaling 
    % Turn off the numerical values along the x- and y-axes.
    set( ax_h,'xticklabel','','xticklabelmode','manual', ...
              'yticklabel','','yticklabelmode','manual')
    if ( max(abs(x_lim)) > 20 ) || ( max(abs(y_lim)) > 20 )
      set( ax_h,'xlimmode','auto','ylimmode','auto')
    end
  else
    % Turn on regular numerical values along the x- and y-axes.
    set( ax_h,'xticklabelmode','auto','yticklabelmode','auto')
    if ( max(abs(x_lim)) > 2 ) || ( max(abs(y_lim)) > 2 )
      set( ax_h,'xlimmode','auto','ylimmode','auto')
    end
  end
  
  x_lim = get( ax_h,'xlim');
  y_lim = get( ax_h,'ylim');
  if hybrid_scaling && any( [ x_lim, y_lim ] > 30 )
    set( ax_h,'xlimmode','auto','ylimmode','auto')
  end
  
  % Adjust the x-axis and y-axis, and their hilite lines.
  set( xaxis_hilite_h,'xdata', x_lim,'ydata', [0 0] );
  set( yaxis_hilite_h,'xdata', [0 0],'ydata', y_lim );
  set( [xaxis_hilite_h;yaxis_hilite_h],'visible','on');
  
  if hybrid_scaling
    set( ax_h,'XTickLabelMode','manual')
    set( ax_h,'XTickLabel','')
    set( ax_h,'YTickLabelMode','manual')
    set( ax_h,'YTickLabel','')
  else
    set( ax_h,'XTickLabelMode','auto')
    set( ax_h,'YTickLabelMode','auto')
  end
  
  if ~isempty(prvw_line_h) && strcmp( init_prvw_vis,'on')
    % Switch out the data, as indicated by the selected scaling.
    for k = 1:numel(prvw_line_h)
      line_ud = get( prvw_line_h(k),'userdata');
      if hybrid_scaling
        if k == 1
          set( prvw_line_h(k), ...
            'xdata', real(line_ud.scaled_OLCplxBode), ...
            'ydata', imag(line_ud.scaled_OLCplxBode), ...
            'visible','on');
        else
          set( prvw_line_h(k), ...
            'xdata', real(line_ud.scaled_OLCplxBode), ...
            'ydata', -imag(line_ud.scaled_OLCplxBode), ...
            'visible','on');
        end
      else
        if k == 1
          set( prvw_line_h(k), ...
            'xdata', real(line_ud.OLCplxBode), ...
            'ydata', imag(line_ud.OLCplxBode), ...
            'visible','on');
        else
          set( prvw_line_h(k), ...
            'xdata', real(line_ud.OLCplxBode), ...
            'ydata', -imag(line_ud.OLCplxBode), ...
            'visible','on');
        end
      end
    end
  end
  
  hndl = local_equimargin_grid( ax_h, hybrid_scaling, hndl );

return

function nr_CCW_encircs = local_get_nr_CCW_encircs( dom_ndx )
  global PZG
  nr_CCW_encircs = [];
  if ~nargin
    return
  end
  if dom_ndx == 1
    nr_OL_unstable = sum( real(PZG(1).PoleLocs) > 1e-14 );
    nr_CL_unstable = sum( real(PZG(1).CLPoleLocs) > 1e-14 );
  else
    nr_OL_unstable = sum( abs(PZG(2).PoleLocs) > (1+1e-14) );
    nr_CL_unstable = sum( abs(PZG(2).CLPoleLocs) > (1+1e-14) );
  end
  nr_CCW_encircs = nr_OL_unstable - nr_CL_unstable;
return

function hndl = local_equimargin_grid( gca0, hybrid_scaling, hndl )
  % Delete existing target grid
  if ( nargin < 2 ) || ~isequal( ishandle(gca0), 1 ) ...
    || ~strcmp('axes', get( gca0,'type') )
    return
  end
  
  gm_pts = [ 1-1/2/sqrt(2); 1/2; 1-1/sqrt(2) ]; % (3dB, 6dB, 9dB)
  % Target points are inside UC.
  target_points = [];
  for k = 1:numel(gm_pts)
    target_points = [ target_points; ...
      -1 + gm_pts(k) ...
      *exp(1i*linspace(-acos(gm_pts(k)/2),acos(gm_pts(k)/2),2500)') ]; ...
                                                               %#ok<AGROW>
  end
  target_points = [ target_points; 1./conj(target_points) ];
  if hybrid_scaling
    target_points = pzg_sclpt(target_points);
  end
      
  target_h = findobj( allchild(gca0),'type','line','tag','equimargin grid');
  if numel(target_h) > 1
    delete(target_h)
    target_h = [];
  end
  eqmrgn_cb = findobj( get(gca0,'parent'),'tag','equimargin checkbox');
  if isempty(eqmrgn_cb) || isequal( get(eqmrgn_cb,'value'), 0 )
    eqmgn_vis = 'off';
  else
    eqmgn_vis = 'on';
  end
  if isempty(target_h)
    hndl.equimargin_grid = ...
      plot( real(target_points), imag(target_points), ...
        'linestyle','none', ...
        'marker','.', ...
        'markersize', 4, ...
        'linewidth', 2, ...
        'color',[0 0.8 0], ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'parent', gca0, ...
        'visible', eqmgn_vis, ...
        'tag','equimargin grid');
  else
    set( target_h, ...
      'xdata', real(target_points), ...
      'ydata', imag(target_points) );
  end
  target_h = findobj( allchild(gca0),'type','text','tag','equimargin text');
  if numel(target_h) ~= 3
    delete(target_h)
    target_h = [];
  end
  if hybrid_scaling
    text_pos = [ -1.18 0; -1.33 0; -1.48 0 ];
  else
    text_pos = [ -1.6 0; -2.2 0; -3.0 0 ];
  end
  if isempty(target_h)
    target_text = {' 3-dB eq';' 6-dB eq';' 9-dB eq'};
    for k = 1:3
      text( text_pos(k,1), text_pos(k,2), target_text{k}, ...
           'parent', gca0, ...
           'color',[0 0.8 0], ...
           'fontsize', 10, ...
           'rotation', 80, ...
           'visible','off', ...
           'tag','equimargin text');
    end
    hndl.equimargin_text = ...
      findobj( allchild(gca0),'type','text','tag','equimargin text');
  else
    for k = 1:3
      set( target_h(k),'position', [ text_pos(4-k,:) 0 ] )
    end
  end
return
