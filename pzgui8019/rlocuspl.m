function rlocuspl( N, D, Gain, PlotName, GAINS, Domain, ...
                   PlotTitle, Position, BtnDwnFn, Callback )
% Creates and services the PZGUI root-locus plots.

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
if isempty(PZG) && ~pzg_recovr 
  return
end
evalin('base','global PZG')

% Check that the input arguments are valid:

if nargin == 1
  if isnumeric(N) && ( numel(N) == 1 )
    local_rlocserv(N);
    return
  elseif ischar(N)
    if strcmpi( N,'center it')
      local_center_it
      return
    elseif strcmpi( N,'Neg. Loci checkbox')
      local_neg_loci_cb
      return
    elseif strcmpi( N,'apply gain')
      local_apply_gain
      return
    end
  end
end

if ( nargin < 4 ) || ( nargin > 10 )
  disp('Correct format is:  ');
  disp(' rlocuspl( Num, Den, Gain, PlotName ...');
  disp('           <,RLocusGains> <,Domain> <,PlotTitle> ...')
  disp('           <,Position> <,BtnDwnFn> <,Callback> )');
  return
end

if nargin < 10
  Callback = '';
end
if ( ~ischar(Callback) ) || ( min(size(Callback) > 1 ) )
  disp('10-th input argument, CALLBACK must be a simple string.');
  return
end

if nargin < 9
  BtnDwnFn = '';
end
if ( ~ischar(BtnDwnFn) ) || ( min(size(BtnDwnFn) > 1 ) )
  disp('9-th input argument, BTNDWNFN must be a simple string.');
  return
end

if nargin < 8
  Position = [];
end
if sum( ( ( size(Position) ~= [1 4] ) | ischar(Position) ) ...
       &( size(Position) ~= [0 0] ) ) > 0
  disp('8-th input arg, POSITION must be a 1-by-4 numerical array.');
  return
end

if nargin < 7
  PlotTitle = '';
end
if ( ~ischar(PlotTitle) ) || ( min(size(PlotTitle) > 1 ) )
  disp('7-th input argument, PLOTTITLE must be a simple string.');
  return
end
  
if nargin < 6
  Domain = 's';   % Default domain is continuous-time.
end
if ( ~ischar(Domain) ) || ( max(size(Domain) > 1 ) )
  disp('6-th input argument, DOMAIN must be either ''s'' or ''z''.');
  return
end
if ~isempty(strfind( lower(Domain),'z'))
  dom_ndx = 2;
else
  dom_ndx = 1;
end

if nargin < 5
  GAINS = [];
end
if min(size(GAINS)) > 1
  disp('Fifth input argument, RLOCUSGAINS must be a vector.')
  return
end
if numel(GAINS) > 1
   if sign(GAINS(2)+eps) ~= sign(Gain+eps)
      GAINS = [];
   end
end

if ( ~ischar(PlotName) ) 
  disp('Fourth input argument, PLOTNAME must be a simple string.');
  return
end
if ( min(size(PlotName))~=1 )
  disp('Fourth input argument, PLOTNAME cannot be an empty string.');
  return
end

if ( min(size(Gain)) == 0 ) || ( max(size(Gain)) > 1 )
  disp('Argument GAIN must be a scalar.');
  return
end
if ischar(Gain) || ischar(N) || ischar(D)
  disp('NUM, DEN, and GAIN cannot be string data.');
  return
end
if ( numel(N) > numel(D) )
  disp('For root locus, transfer function must be proper, ');
  disp('  i.e., there must be at least as many poles as zeros.');
  return
end
if ( min(size(N)) > 1 ) || ( min(size(D)) > 1 )
  disp('Arguments NUM and DEN must column or row vectors.');
  return
end

% ----------------------------------------------------------------------
if dom_ndx == 1
  wb_h = findobj( allchild(0), ...
                 'name','C-T Root-Locus Computation Progress');
else
  wb_h = findobj( allchild(0), ...
                 'name','D-T Root-Locus Computation Progress');
end
for k = numel(wb_h):-1:1
  pause(0.1)
  if strcmp( get(wb_h(k),'visible'),'off')
    delete(wb_h(k))
    wb_h(k) = [];
  end
end
if ~isempty(wb_h)
  set(wb_h,'visible','on')
  disp( ...
    'rlocuspl:  Apparently, root-locus is already underway ("waitbar" exists)')
  return
end

gcf0 = pzg_fndo( dom_ndx, 9+dom_ndx,'fig_h');
if isempty(gcf0)
  gcf0 = findobj( allchild(0),'Name', PlotName );
  delete(gcf0)
  gcf0 = [];
  PZG(1).plot_h{9+dom_ndx} = [];
  PZG(2).plot_h{9+dom_ndx} = [];
elseif numel(gcf0) > 1
  delete(gcf0)
  gcf0 = [];
  PZG(1).plot_h{9+dom_ndx} = [];
  PZG(2).plot_h{9+dom_ndx} = [];
end

ColorOrder = [ 1 0 1; 1 0.7 0.5; 0.4 0.8 1; 1 0 0; 0 1 0; 0 0 1];
temp0 = [];
hndl = [];
if ~isempty(gcf0)
  temp0 = get(gcf0,'UserData');
  if isfield( PZG,'plot_h') ...
    && ~isempty(PZG(dom_ndx).plot_h) ...
    && isfield( PZG(dom_ndx).plot_h{9+dom_ndx},'hndl')
    hndl = PZG(dom_ndx).plot_h{9+dom_ndx}.hndl;
  elseif isappdata( gcf0,'hndl')
    hndl = getappdata( gcf0,'hndl');
  end
  if isfield( hndl,'ax') && isequal( 1, ishandle(hndl.ax) )
    gca0 = hndl.ax;
  else
    gca0 = findobj( gcf0,'type','axes','tag','pzg root locus plot axes');
  end
  if isempty(gca0)
    disp('rlocuspl.m Error: Root locus axes-object is not found.')
    return
  end
end

newFigure = 0;
if isempty(temp0)
  % Root locus figure doesn't exist, so create it.
  newFigure = 1;
  
  del_str = ...
      ['global PZG,' ...
       'try,' ...
         'temp_rloccb=pzg_fndo(' num2str(dom_ndx) ',' num2str(11+dom_ndx) ',' ...
            '''RtLoc_checkbox'');' ...
         'if~isempty(temp_rloccb),' ...
           'set(temp_rloccb,''value'',0);' ...
         'end,' ...
         'PZG(1).plot_h{' num2str(9+dom_ndx) '}=[];' ...
         'PZG(2).plot_h{' num2str(9+dom_ndx) '}=[];' ...
       'end,' ...
       'pzg_bkup;' ...
       'clear temp_rloccb;'];
  
  gcf0 = ...
    figure('menubar','figure', ...
      'numbertitle','off', ...
      'integerhandle','off', ...
      'handlevisibility','callback', ...
      'dockcontrols','off', ...
      'visible','off', ...
      'tag','PZGUI plot', ...
      'deletefcn', del_str );
  
  % Put a "Color Options" menu item in the figure's menubar.
  opt_menu_h = ...
    uimenu('parent', gcf0, ...
           'label', 'PZGUI OPTIONS', ...
           'tag','pzgui_options_menu');
  pzg_menu( opt_menu_h, Domain );
  hndl = getappdata( gcf0,'hndl');
  
  hndl.plot_name = get( gcf0,'name');
  hndl.dom_ndx = dom_ndx;
  hndl.ploth_ndx = 9+dom_ndx;
    
  gca0 = axes('parent', gcf0, ...
              'nextplot','add', ...
              'xgrid','on', ...
              'ygrid','on', ...
              'tag','pzg root locus plot axes');
  hndl.ax = gca0;
  hndl.ax_title = get( gca0,'title');
  hndl.ax_xlabel = get( gca0,'xlabel');
  hndl.ax_ylabel = get( gca0,'ylabel');
  ScrSize = get(0,'ScreenSize');
  if ScrSize(3) > 1024
    set(gca0,'Position',[0.16 0.21 0.795 0.715], ...
        'Interruptible','On', ...
        'FontSize',10, ...
        'ColorOrder',ColorOrder );
  else
    set(gca0,'Position',[0.16 0.21 0.795 0.715], ...
        'Interruptible','On', ...
        'FontSize',8, ...
        'ColorOrder',ColorOrder );
  end
  
  if ~isequal( size(Position),[1 4] )
    set( gcf0, ...
        'units','normalized', ...
        'Name', PlotName, ...
        'Color','k', ...
        'Interruptible','On');
  else
    if max(Position) > 1
      ScrSize = get(0,'screensize');
      Position([1;3]) = Position([1;3])/ScrSize(3);
      Position([2;4]) = Position([2;4])/ScrSize(4);
    end
    set( gcf0, ...
        'units','normalized', ...
        'Position', Position, ...
        'Name', PlotName, ...
        'Color','k', ...
        'Interruptible','On');
    set(gca0,'color','k','XColor','w','YColor','w');
  end
  XLimit = [];
  YLimit = [];
  
  if isfield( hndl,'PZmap_xaxis_highlight')
    temp = hndl.PZmap_xaxis_highlight;
  else
    temp = [];
  end
  if isempty(temp) || ~isequal( 1, ishandle(temp) )
    XLim = get( gca0,'xlim');
    temp = ...
      plot( XLim,[0 0],'c', ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'tag','rlocuspl x-axis highlight', ...
         'parent', gca0 );
    hndl.PZmap_xaxis_highlight = temp;
  end
  if isfield( hndl,'PZmap_yaxis_highlight')
    temp1 = hndl.PZmap_yaxis_highlight;
  else
    temp1 = [];
  end
  if isempty(temp1) || ~isequal( 1, ishandle(temp1) )
    YLim = get( gca0,'ylim');
    temp1 = plot( [0 0], YLim,'c', ...
              'tag','rlocuspl y-axis highlight', ...
              'parent', gca0 );
    hndl.PZmap_yaxis_highlight = temp1;
  end

  uicontrol(gcf0,'Style','text', ...
    'Units','normalized', ...
    'Position',[0.001 0.007 0.25 0.09], ...
    'String',{'Parameter';'  K ='}, ...
    'fontsize', 10, ...
    'fontweight','bold', ...
    'tooltipstring', ...
      'gain multiplier K to get the "yellow" C.L. poles', ...
    'HorizontalAlignment','left', ...
    'BackgroundColor', get(gcf0,'color'), ...
    'ForegroundColor', 1-get(gcf0,'color') );
  GainHndl = uicontrol(gcf0,'Style','edit', ...
    'Units','normalized', ...
    'Position',[0.10 0.005 0.195 0.045], ...
    'String','', ...
    'fontsize', 10, ...
    'fontweight','bold', ...
    'HorizontalAlignment','center', ...
    'BackgroundColor',[0.9 0.9 0.9], ...
    'ForegroundColor',[0 0 0], ...
    'tooltipstring', ...
      'gain multiplier K to get the "yellow" C.L. poles', ...
    'tag','rlocuspl gain text', ...
    'callback', ...
      ['tempUIh=findobj(gcbf,''type'',''uicontrol'');' ...
       'set(tempUIh,''enable'',''off'');' ...
       'try,' ...
         'temp_marker_h=pzg_fndo(' num2str(dom_ndx) ',' ...
         num2str(9+dom_ndx) ',''rlocuspl_gain_marker'');' ...
         'temp_str2num=str2num(get(gcbo,''string''));' ...
         'if isequal(1,numel(temp_str2num))&&isreal(temp_str2num)' ...
           '&&(abs(temp_str2num)>1e-15),' ...
           'set(gcbo,''string'',num2str(temp_str2num,8));' ...
           'if~isempty(strfind(get(gcbf,''name''),''Continuous'')),' ...
             'rlocuspl(PZG(1).Gain);' ...
           'else,' ...
             'rlocuspl(PZG(2).Gain);' ...
           'end,' ...
           'set(gcbo,''backgroundcolor'',[0.9 0.9 0]);' ...
         'else,' ...
           'temp_gcbo_str=get(gcbo,''string'');' ...
           'set(gcbo,''string'','''',''backgroundcolor'',[0.9 0.9 0.9]);' ...
           'if~isempty(temp_marker_h),' ...
             'set(temp_marker_h,''xdata'',[],' ...
                '''ydata'',[],''visible'',''off'');' ...
           'end,' ...
           'if~isempty(temp_gcbo_str),' ...
             'temp_errdlg_h=errordlg(' ...
               '{''Entry must evaluate to a real-valued nonzero scalar.'';' ...
                 ''' '';''    Click "OK" to continue.'';'' ''},' ...
               '''Invalid Parameter Value'',''modal'');' ...
             'uiwait(temp_errdlg_h);' ...
           'end,' ...
         'end,' ...
       'catch,pzg_err('' rlocuspl '');end,' ...
       'drawnow,' ...
       'tempUIh=findobj(gcbf,''type'',''uicontrol'');' ...
       'set(tempUIh,''enable'',''on'');' ...
       'clear tempC tempUIh temp_str2num temp_marker_h temp_gcbo_str;' ...
       'clear temp_gtexth temp_errdlg_h']);
  hndl.rlocuspl_gain_text = GainHndl;
  
  uicontrol(gcf0,'Style','pushbutton', ...
    'String','< Apply K to Gain', ...
    'Units','normalized', ...
    'Position',[0.303 0.005 0.26 0.045], ...
    'BackgroundColor',[.7 .9 .9], ...
    'ForegroundColor',[0 0 0], ...
    'tooltipstring', ...
      'multiply the existing gain by this parameter K', ...
    'horizontalalignment','left', ...
    'tag','rlocuspl apply gain', ...
    'callback', ...
      ['temp0=findobj(gcbf,''tag'',''rlocuspl gain text'');' ...
       'if isempty(temp0),' ...
         'clear temp0,' ...
         'return,' ...
       'end,' ...
       'try,' ...
         'set(temp0,''backgroundcolor'',[0.9 0.9 0.9]);' ...
         'temp_gain=str2num(get(temp0,''string''));' ...
         'if ~isreal(temp_gain)||~isequal(numel(temp_gain),1),' ...
           'set(temp0,''string'',''''),' ...
           'clear temp0 temp_gain,' ...
           'return,' ...
         'elseif abs(temp_gain)<1e-15,' ...
           'set(temp0,''string'',''''),' ...
           'temp_errdlg_h=errordlg(' ...
             '{''Zero gain cannot be applied to the model.'';' ...
               ''' '';''    Click "OK" to continue ...'';'' ''},' ...
             '''rlocuspl Error'',''modal'');' ...
           'uiwait(temp_errdlg_h),' ...
           'clear temp0 temp_gain temp_errdlg_h,' ...
           'return,' ...
         'end,' ...
         'tempUIh=findobj(gcbf,''type'',''uicontrol'');' ...
         'set(tempUIh,''enable'',''off'');' ...
         'pzg_onoff(0);' ...
         'rlocuspl(''apply gain'');' ...
         'tempUIh=findobj(gcbf,''type'',''uicontrol'');' ...
         'set(tempUIh,''enable'',''on'');' ...
       'catch,' ...
         'pzg_err('' rlocuspl Apply Gain '');' ...
       'end,' ...
       'drawnow,' ...
       'pzg_onoff(1);' ...
       'clear tempUIh temp0 temp_gain']);
  
  % Update the plot_h field.
  if dom_ndx == 1
    ploth_ndx = 10;
  else
    ploth_ndx = 11;
  end
  PZG(dom_ndx).plot_h{ploth_ndx} = [];
  PZG(dom_ndx).plot_h{ploth_ndx}.plot_name = get( gcf0,'name');
  PZG(dom_ndx).plot_h{ploth_ndx}.fig_h = gcf0;
  PZG(dom_ndx).plot_h{ploth_ndx}.ax_h = gca0;
  PZG(dom_ndx).plot_h{ploth_ndx}.xlim = get( gca0,'xlim');
  PZG(dom_ndx).plot_h{ploth_ndx}.ylim = get( gca0,'ylim');
  PZG(dom_ndx).plot_h{ploth_ndx}.bg_color = get( gcf0,'color');
  PZG(dom_ndx).plot_h{ploth_ndx}.mm_freq_h = [];
  PZG(dom_ndx).plot_h{ploth_ndx}.mm_mag_h = [];
  PZG(dom_ndx).plot_h{ploth_ndx}.mm_phs_h = [];
  PZG(dom_ndx).plot_h{ploth_ndx}.mm_line_h = [];
  PZG(dom_ndx).plot_h{ploth_ndx}.mm_mark_h = [];
  
  hndl.ax_xlim = PZG(dom_ndx).plot_h{ploth_ndx}.xlim;
  hndl.ax_ylim = PZG(dom_ndx).plot_h{ploth_ndx}.ylim;

  setappdata( gcf0,'hndl', hndl );
  if dom_ndx == 1
    pzg_cphndl( gcf0, 1, 10 )
  else
    pzg_cphndl( gcf0, 2, 11 )
  end
  
else
  % Figure already exists.
  if isappdata( gcf0,'hndl')
    hndl = getappdata( gcf0,'hndl');
  else
    return;
  end
  ploth_ndx = 9+dom_ndx;
  gca0 = PZG(dom_ndx).plot_h{ploth_ndx}.ax_h;
  XLimit = PZG(dom_ndx).plot_h{ploth_ndx}.hndl.ax_xlim;
  YLimit = PZG(dom_ndx).plot_h{ploth_ndx}.hndl.ax_ylim;
  GainHndl = PZG(dom_ndx).plot_h{ploth_ndx}.hndl.rlocuspl_gain_text;
end

if Domain == 's'
  PLocs = PZG(1).PoleLocs;
  ZLocs = PZG(1).ZeroLocs;
  if PZG(1).PureDelay > 0
    PLocs = [ PLocs; PZG(1).pade.P ];
    ZLocs = [ ZLocs; PZG(1).pade.Z ];
  end
else
  PLocs = PZG(2).PoleLocs;
  ZLocs = PZG(2).ZeroLocs;
  if PZG(2).PureDelay > 0
    PLocs = [ PLocs; zeros(PZG(2).PureDelay,1) ];
  end
end

hi_nr_poles = 500;

if isempty(GAINS)
  if numel(PLocs) > 200
    GAINS = [ logspace( -10, -7, 50 ), logspace( -7, -0.5, 200 ), ...
              logspace( -0.5, 0.5, 300 ), logspace( 0.5, 5, 150 ) ];
  elseif numel(PLocs) > 100
    GAINS = [ logspace( -10, -7, 100 ), logspace( -7, -0.5, 300 ), ...
              logspace( -0.5, 0.5, 600 ), logspace( 0.5, 5.5, 300 ) ];
  elseif numel(PLocs) > 60
    GAINS = [ logspace( -10, -7, 200 ), logspace( -7, -0.5, 600 ), ...
              logspace( -0.5, 0.5, 1200 ), logspace( 0.5, 6, 600 ) ];
  elseif numel(PLocs) > 20
    GAINS = [ logspace( -10, -7, 400 ), logspace( -7, -0.5, 1200 ), ...
              logspace( -0.5, 0.5, 2400 ), logspace( 0.5, 6.5, 1200 ) ];
  else
    GAINS = [ logspace( -10, -7, 900 ), logspace( -7, -0.5, 2700 ), ...
              logspace( -0.5, 0.5, 4800 ), logspace( 0.5, 7, 2400 ) ];
  end
end

% Add in gains for break-in and break-out points.
brk_pts = [];
if ( numel( PLocs ) > 1 ) && ( numel( PLocs ) < 14 )
  DEN = poly( PLocs );
  NUM = poly( ZLocs );
  if isempty( ZLocs )
    subNUM = [];
  elseif numel( ZLocs ) == 1
    subNUM = {DEN};
  else
    subNUM = cell(size(ZLocs));
    for k = 1:numel(subNUM)
      subzero = ZLocs;
      subzero(k) = [];
      subNUM{k} = conv( DEN, poly( subzero ) );
    end
  end
  subDEN = cell(size(PLocs));
  for k = 1:numel(subDEN)
    subpole = PLocs;
    subpole(k) = [];
    subDEN{k} = conv( NUM, poly( subpole ) );
  end
  full_poly = zeros(size(subDEN{1}));
  for k = 1:numel(subNUM)
    full_poly = full_poly - subNUM{k};
  end
  for k = 1:numel(subDEN)
     full_poly = full_poly + subDEN{k};
  end
  brk_pts = roots( full_poly );
  brk_gains = zeros( size(brk_pts) );
  for k = 1:numel(brk_gains)
    brk_gains(k) = prod( abs( brk_pts(k)-PLocs ) ) ...
                   /prod( abs( brk_pts(k)-ZLocs ) );
  end
  brk_gains = brk_gains/PZG(dom_ndx).Gain;
  GAINS = [ abs(GAINS(:)); abs(brk_gains(:)) ];
end

wb_h = -1;
ax_ud = get( gca0,'userdata');
nr_poles = 0;

if ~isempty(PLocs)
  purejordan = 1;
  include_pade = 1;
  modalss = pzg_moda( dom_ndx, purejordan, include_pade, [],'', 1 );
  if ~isequal( size(modalss.a,1), numel(PLocs) )
    PLocs = eig(modalss.a);
  end

  GAINS = abs(GAINS);
  zerogain_ndx = find( GAINS == 0 );
  if numel(zerogain_ndx) > 1
    GAINS(zerogain_ndx(2:end)) = [];
  elseif isempty(zerogain_ndx)
    GAINS = [ 0; GAINS(:) ];
  end
  GAINS( isnan(GAINS) ) = [];
  GAINS( isinf(GAINS) ) = [];
  GAINS = unique( [ GAINS; 1 ] );

  if ~isempty(modalss)
    nr_poles = size(modalss.a,1);
    AA = modalss.a;
    BB = modalss.b;
    CC = modalss.c;
    BC = BB*CC;
    DD = modalss.d;
    
    ax_ud.AA = AA;
    ax_ud.BC = BC;
    ax_ud.DD = DD;
    set( gca0,'userdata', ax_ud ) 
    
    if ( nr_poles > hi_nr_poles ) || ( nr_poles > 62 )
      % Weed out some of the gain factors.
      min_nr_gains = max( 500, ceil( 20000/nr_poles ) );
      pref_nr_gains = max( min_nr_gains, round( 1e7 / size(modalss.a,1)^2 ) );
      while numel(GAINS) > pref_nr_gains
        GAINS = GAINS(1:2:end);
      end
      if GAINS(1) ~= 0
        GAINS = [ 0; GAINS ];
      end
      ver_nr = version;
      if strcmp( ver_nr(1),'6')
        if dom_ndx == 1
          nm_text = 'C-T Root-Locus Computation Progress';
        else
          nm_text = 'D-T Root-Locus Computation Progress';
        end
        wb_text = 'Computing Root Locus (to cancel, close this window)';
      else
        if dom_ndx == 1
          nm_text = 'C-T Root-Locus Computation Progress';
          wb_text = {'Computing Continuous-Time Root Locus'; ...
                          ' ';' ';'(to cancel, close this window)'};
        else
          nm_text = 'D-T Root-Locus Computation Progress';
          wb_text = {'Computing Discrete-Time Root Locus'; ...
                          ' ';' ';'(to cancel, close this window)'};
        end
      end
      wb_h = waitbar( max(0.01, 1/numel(GAINS) ), wb_text, ...
                     'name',nm_text);
      wb_ax_h = get( wb_h,'currentaxes');
      wb_text_h = get(wb_ax_h,'title');
      if nr_poles < 120
        est_skip = 12;
      elseif nr_poles < 240
        est_skip = 6;
      else
        est_skip = 3;
      end
      Loci = zeros( numel(GAINS), size(modalss.a,1) );
      negLoci = zeros( numel(GAINS), size(modalss.a,1) );
      Loci(1,:) = PLocs(:).';
      
      tic
      for k = 2:numel(GAINS)
        if (DD+1/GAINS(k)) ~= 0
          Loci(k,:) = ( eig( AA-BC/(DD+1/GAINS(k)) ) ).';
          negLoci(k,:) = ( eig( AA-BC/(DD-1/GAINS(k)) ) ).';
        else
          Loci(k,:) = inf;
          negLoci(k,:) = inf;
        end
        if ~ishandle(wb_h)
          % User has canceled the root-locus computation
          % by deleting the waitbar figure.
          % Close the root-locus plot, which would otherwise be stale.
          rtloc_h = ...
            findobj( allchild(0), ...
                    'type','figure', ...
                    'name', PZG(dom_ndx).RootLocusName );
          delete(rtloc_h)
          if dom_ndx == 1
            PZG(1).plot_h{10} = [];
            PZG(2).plot_h{10} = [];
          else
            PZG(1).plot_h{11} = [];
            PZG(2).plot_h{11} = [];
          end
          dom_gui_h = pzg_fndo( dom_ndx, 11+dom_ndx,'fig_h');
          if ~isempty(dom_gui_h)
            temp0 = get(dom_gui_h,'userdata');
            set( temp0(10,2),'value', 0 )
          end
          return
        elseif ( k > 4 ) && ( ( est_skip == 1 ) || ~mod( k, est_skip ) )
          elap_time = toc;
          perloop_time = elap_time/k;
          remtime_est = ( numel(GAINS) - (k-1) )*perloop_time;
          if k < 10
            remtime_est = max( 1, ( 1+(11-k)/10 ) ) * remtime_est;
          end
          if remtime_est > 60
            remtime_text = ...
              ['Estimated time remaining:  ' ...
               num2str(remtime_est/60, 3 ) ' minutes.'];
          else
            remtime_text = ...
              ['Estimated time remaining:  ' ...
               num2str(round(remtime_est)) ' seconds.'];
          end
          if strcmp(ver_nr(1),'6')
            wb_text = [ remtime_text '(close, to cancel)'];
          else
            wb_text{2} = remtime_text;
          end
          set( wb_text_h,'string', wb_text );
          waitbar( max( 0.01, 0.95*k/numel(GAINS) ), wb_h )
        end
      end
    else
      Loci = zeros(size(modalss.a,1),numel(GAINS));
      if GAINS(1) == 0
        Loci(:,1) = eig(AA);
        negLoci(:,1) = eig(AA);
        for kg = 2:numel(GAINS)
          if (DD+1/GAINS(kg)) ~= 0
            Loci(:,kg) = eig( AA-BC/(DD+1/GAINS(kg)) );
            negLoci(:,kg) = eig( AA-BC/(DD-1/GAINS(kg)) );
          else
            Loci(:,kg) = inf;
            negLoci(:,kg) = inf;
          end
        end
      else
        for kg = 1:numel(GAINS)
          if (DD+1/GAINS(kg)) ~= 0
            Loci(:,kg) = eig( AA-BC/(DD+1/GAINS(kg)) );
            negLoci(:,kg) = eig( AA-BC/(DD-1/GAINS(kg)) );
          else
            Loci(:,kg) = inf;
            negLoci(:,kg) = inf;
          end
        end
      end
      if size(Loci,1) == size(modalss.a,1)
        Loci = Loci.';
      end
      if size(negLoci,1) == size(modalss.a,1)
        negLoci = negLoci.';
      end
      if size(Loci,2) > 1
        col2_Loci = Loci(:,2);
      else
        col2_Loci = Loci(1);
      end
      target_ndxs = (1:numel(PLocs));
      for k = 1:numel(PLocs)
        [ dist, closest_ndx ] = ...
           min( abs( PLocs(k) - col2_Loci(target_ndxs) ) ); %#ok<ASGLU>
        Loci(target_ndxs(1,closest_ndx)) = PLocs(k);
        target_ndxs(closest_ndx) = [];
      end
    end
    % Check that the open-loop transfer function has a relatively small
    % imaginary part, at each computed closed-loop pole location.
    loci_angles = zeros(numel(Loci),1) + angle(PZG(dom_ndx).Gain);
    for k = 1:numel(PLocs)
      loci_angles = loci_angles - angle( Loci(:) - PLocs(k) );
      if numel(ZLocs) >= k
        loci_angles = loci_angles + angle( Loci(:) - ZLocs(k) );
      end
    end
    loci_angles = mod( abs(loci_angles), 2*pi );
    Loci( abs( pi - loci_angles ) > pi/200 ) = NaN;
    
    if ~isempty(negLoci)
      loci_angles = zeros(numel(negLoci),1) + angle(PZG(dom_ndx).Gain);
      for k = 1:numel(PLocs)
        loci_angles = loci_angles - angle( negLoci(:) - PLocs(k) );
        if numel(ZLocs) >= k
          loci_angles = loci_angles + angle( negLoci(:) - ZLocs(k) );
        end
      end
      loci_angles = mod( abs(loci_angles), 2*pi );
      negLoci( abs(loci_angles) > pi/200 ) = NaN;
    end
    
  else
    % Use unfactored polynomials in "gnarly" cases (not as accurate).
    if numel(DEN) > 1
      nr_poles = numel(DEN) - 1;
      Loci = rlocus( PZG(dom_ndx).Gain*NUM, DEN, [ GAINS; -GAINS ] );
      if isempty(Loci)
        these_poles = roots(D);
        Loci = these_poles(1);
        negLoci = these_poles(1);
      else
        negLoci = Loci(numel(GAINS)+1:end,:);
        Loci(numel(GAINS)+1:end,:) = [];
      end
    else
      Loci = zeros(size(GAINS));
      negLoci = zeros(size(GAINS));
    end
  end
  if isempty(Loci)
    if ~isempty(modalss)
      these_poles = eig(modalss.a);
    else
      these_poles = roots(D);
    end
    Loci = these_poles(1);
  end
  
  if isempty(negLoci)
    if ~isempty(modalss)
      these_poles = eig(modalss.a);
    else
      these_poles = roots(D);
    end
    negLoci = these_poles(1);
  end
else
  Loci = zeros(size(GAINS));
  negLoci = zeros(size(GAINS));
end

minabsLoci = max( 1, min(abs(Loci( Loci(:) ~= 0 ))) );
maxabsLoci = max(abs(Loci(:)));
if ~isempty(minabsLoci) && ( maxabsLoci/minabsLoci > 1e6 )
  maxabs = minabsLoci * 1e4;
  excess_col_ndx = size(Loci,1) + 1;
  for k = 1:size(Loci,2)
    thisexcess_ndx = find( abs(Loci(:,k)) > maxabs );
    if ~isempty(thisexcess_ndx)
      excess_col_ndx = min( thisexcess_ndx, min(excess_col_ndx) );
    end
  end
  if excess_col_ndx < ( size(Loci,1) + 1 );
    Loci = Loci(1:excess_col_ndx-1,:);
    negLoci = negLoci(1:excess_col_ndx-1,:);
    GAINS = GAINS(1:excess_col_ndx-1);
  end
end

if isequal( 1, ishandle(gcf0) )
  tempRL0 = get(gcf0,'UserData');
else
  tempRL0 = [];
end
boxdata = [];
tempXX = [];
tempYY = [];
if size(tempRL0,2)>1
   if isequal( 1, ishandle( tempRL0(1,2) ) ) && ( tempRL0(1,2)~=0 )
      boxdata = get( tempRL0(1,2),'UserData');
      tempXX = boxdata.box_x;
      tempYY = boxdata.box_y;
   end
end

if isfield( hndl,'rlocuspl_root_loci')
  temp0 = hndl.rlocuspl_root_loci;
else
  temp0 = [];
end
if isempty(temp0) || ~isequal( 1, ishandle(temp0) )
  temp0 = ...
    plot( real(Loci(:)), imag(Loci(:)), ...
         'color','m', ...
         'linestyle','none', ...
         'marker','.', ...
         'markersize', 6, ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'parent', gca0, ...
         'tag','rlocuspl root loci' );
  hndl.rlocuspl_root_loci = temp0;
else
  set( temp0, ...
      'xdata', real(Loci(:)), ...
      'ydata', imag(Loci(:)), ...
      'color','m', ...
      'linestyle','none', ...
      'marker','.', ...
      'markersize', 6 )
end

if isfield( hndl,'rlocuspl_show_grid')
  showgrid_h = hndl.rlocuspl_show_grid;
else
  showgrid_h = [];
end

if isfield( hndl,'rlocuspl_show_neg_root_loci') ...
  && isequal( 1, ishandle(hndl.rlocuspl_show_neg_root_loci) )  
  show_negrloci_h = hndl.rlocuspl_show_neg_root_loci;
else
  show_negrloci_h = ...
    findobj( gcf0,'type','uicontrol','tag','rlocuspl show neg root loci');
end
if isempty(show_negrloci_h) || ~get( show_negrloci_h,'value')
  negloci_vis = 'off';
else
  negloci_vis = 'on';
end

if isfield( hndl,'rlocuspl_neg_root_loci')
  negloci_h = hndl.rlocuspl_neg_root_loci;
else
  negloci_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_neg_root_loci');
end
if nr_poles <= hi_nr_poles
  if isempty(negloci_h) || ~isequal( 1, ishandle(negloci_h) )
    negloci_h = ...
      plot( real(negLoci(:)), imag(negLoci(:)), ...
        'color','r', ...
        'linestyle','none', ...
        'linewidth', 2, ...
        'marker','.', ...
        'markersize', 6, ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'visible', negloci_vis, ...
        'parent', gca0, ...
        'tag','rlocuspl neg root loci');
  else
    set( negloci_h, ...
      'xdata', real(negLoci(:)), ...
      'ydata', imag(negLoci(:)), ...
      'color','r', ...
      'linestyle','none', ...
      'linewidth', 2, ...
      'marker','.', ...
      'markersize', 6, ...
      'visible', negloci_vis )
  end
else
  if isempty(negloci_h) || ~ishandle(negloci_h)
    negloci_h = ...
      plot( 0, 0, ...
         'color','r', ...
         'linestyle','none', ...
         'linewidth', 2, ...
         'marker','.', ...
         'markersize', 6, ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'visible','off', ...
         'parent', gca0, ...
         'tag','rlocuspl neg root loci');
  else
    set( negloci_h,'xdata',[],'ydata',[]);
  end
  set( negloci_h,'xdata',[],'ydata',[],'visible', negloci_vis )
end
hndl.rlocuspl_neg_root_loci = negloci_h;

if isequal( get(gcf0,'color'),[0 0 0])
  set( gca0, ...
      'FontSize',10, ...
      'ColorOrder',ColorOrder, ...
      'nextplot','add', ...
      'xgrid','on','ygrid','on', ...
      'Color','k','XColor','w','YColor','w');
else
  set( gca0, ...
      'FontSize',10, ...
      'ColorOrder',ColorOrder, ...
      'nextplot','add', ...
      'xgrid','on','ygrid','on', ...
      'Color','w','XColor','k','YColor','k');
end

if ~isempty(PlotTitle)
  set( get(gca0,'title'),'string', PlotTitle,'Color',[1 1 1] );
end
set( get(gca0,'xlabel'),'string',['Real Part of ' upper(Domain) '-Plane'] );
set( get(gca0,'ylabel'),'string',['Imaginary Part of ' upper(Domain) '-Plane'] );

if isfield( hndl,'rlocuspl_root_loci_markers')
  loci_h = hndl.rlocuspl_root_loci_markers;
else
  loci_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_root_loci_markers');
end
if isempty(loci_h) || ~ishandle(loci_h)
  loci_h = ...
    plot( real(Loci(:)),imag(Loci(:)), ...
       'color','m', ...
       'linestyle','none', ...
       'marker','.', ...
       'MarkerSize', 6, ...
       'hittest','off', ...
       'handlevisibility','off', ...
       'tag','rlocuspl root loci markers', ...
       'parent', gca0 );
else
  set( loci_h, ...
    'xdata', real(Loci(:)), ...
    'ydata', imag(Loci(:)), ...
    'color','m', ...
    'linestyle','none', ...
    'marker','.', ...
    'MarkerSize', 6, ...
    'visible','on')
end
hndl.rlocuspl_root_loci_markers = loci_h;

temp0 = [ temp0; loci_h ];
if isempty(Loci)
  Loci = 0;
end

if isfield( hndl,'rlocuspl_gain_marker')
  temp = hndl.rlocuspl_gain_marker;
else
  temp = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_gain_marker');
end
if isempty(temp) || ~ishandle(temp)
  temp = ...
    plot( real(Loci(1,1)), imag(Loci(1,1)),'y*', ...
        'MarkerSize', 10, ...
        'LineWidth', 2.5, ...
        'Visible','off', ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'tag','rlocuspl gain marker', ...
        'parent', gca0 );
end
hndl.rlocuspl_gain_marker = temp;

temp0 = [ temp0; temp; GainHndl ];
temp0 = [ temp0, zeros( size(temp0,1), 1 ) ];

temp0 = [ temp0; hndl.PZmap_xaxis_highlight hndl.PZmap_yaxis_highlight ];

boxdata.box_x = tempXX;
boxdata.box_y = tempYY;
if ~isfield( boxdata,'box_domain')
  boxdata.box_domain = Domain;
end

% Create the asymptotes as dashed lines.
asymp_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_asymptote');
neg_asymp_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_neg_asymptote');
nr_asymp = numel(PLocs) - numel(ZLocs);
if nr_asymp > 0
  asymp_angles = zeros(nr_asymp,1);
  neg_asymp_angles = zeros(nr_asymp,1);
  del_angle = 2*pi / nr_asymp;
  if mod(nr_asymp,2)
    % Odd number of asymptotes.
    asymp_angles(1) = pi;
    neg_asymp_angles(1) = 0;
    for k = 2:nr_asymp
      asymp_angles(k) = pi - (k-1)*del_angle;
      neg_asymp_angles(k) = (k-1)*del_angle;
    end
  else
    % Even number of asymptotes.
    asymp_angles(1) = pi-del_angle/2;
    neg_asymp_angles(1) = 0;
    for k = 2:nr_asymp
      asymp_angles(k) = asymp_angles(1) - (k-1)*del_angle;
      neg_asymp_angles(k) = neg_asymp_angles(1) + (k-1)*del_angle;
    end    
  end
  if Gain < 0
    asymp_angles = asymp_angles + del_angle/2;
    neg_asymp_angles = neg_asymp_angles + del_angle/2;
  end
  for k = 1:numel(asymp_angles)
    while asymp_angles(k) > pi
      asymp_angles(k) = asymp_angles(k) - 2*pi;
    end
    while asymp_angles(k) < -pi
      asymp_angles(k) = asymp_angles(k) + 2*pi;
    end
    while neg_asymp_angles(k) > pi
      neg_asymp_angles(k) = neg_asymp_angles(k) - 2*pi;
    end
    while neg_asymp_angles(k) < -pi
      neg_asymp_angles(k) = neg_asymp_angles(k) + 2*pi;
    end
  end
  asymp_angles = sort(asymp_angles);
  neg_asymp_angles = sort(neg_asymp_angles);
  asymp_intersect = real( sum(PLocs) - sum(ZLocs) ) / nr_asymp;
  
  ZLocs = ZLocs(:);
  PLocs = PLocs(:);
  brk_pts = brk_pts(:);
  real_pndx = find( abs(imag(PLocs(:))) < 1e-12 );
  real_zndx = find( abs(imag(ZLocs(:))) < 1e-12 );
  real_bndx = find( abs(imag(brk_pts(:))) < 1e-12 );
  real_pts = ...
    real( [ PLocs(real_pndx); ...
            ZLocs(real_zndx); ...
            brk_pts(real_bndx); ...
            asymp_intersect ] );     %#ok<FNDSB>
  if Gain > 0
    real_asymp_start = min( real_pts );
    neg_real_asymp_start = max( real_pts );
  else
    real_asymp_start = max( real_pts );
    neg_real_asymp_start = min( real_pts );
  end
  max_value = 1.1*max( abs(Loci(:)) );
  asymptotes = zeros( 2, nr_asymp );
  neg_asymptotes = zeros( 2, nr_asymp );
  for k = 1:nr_asymp
    this_angle = asymp_angles(k);
    this_neg_angle = neg_asymp_angles(k);
    if ( abs( abs(this_angle)-pi ) < del_angle/3 )
      asymptotes(:,k) = ...
        real_asymp_start - linspace( 0, max_value, size(asymptotes,1) )';
    elseif ( abs(this_angle) < del_angle/3 )
      asymptotes(:,k) = ...
        real_asymp_start + linspace( 0, max_value, size(asymptotes,1) )';
    else
      asymptotes(:,k) = asymp_intersect + ...
        exp(1i*this_angle) * linspace( 0, max_value, size(asymptotes,1) )';
    end
    if ( abs( abs(this_neg_angle) - pi ) < del_angle/3 )
      neg_asymptotes(:,k) = ...
        neg_real_asymp_start-linspace( 0, max_value, size(neg_asymptotes,1) )';
    elseif ( abs(this_neg_angle) < del_angle/3 )
      neg_asymptotes(:,k) = ...
        neg_real_asymp_start+linspace( 0, max_value, size(neg_asymptotes,1) )';
    else
      neg_asymptotes(:,k) = asymp_intersect + ...
        exp(1i*this_neg_angle) ...
        *linspace( 0, max_value, size(neg_asymptotes,1) )';
    end
  end
  asymptotes = [ asymptotes; NaN*ones(1,size(asymptotes,2)) ];
  neg_asymptotes = [ neg_asymptotes; NaN*ones(1,size(neg_asymptotes,2)) ];
  
  % Plot the asymptotes.
  if isempty(asymp_h)
    asymp_h = ...
      plot( real(asymptotes(:)), imag(asymptotes(:)), ...
         'LineStyle','--', ...
         'LineWidth', 0.5, ...
         'color', 1-get(gca0,'color'), ...
         'hittest','off', ...
         'tag','rlocuspl asymptote', ...
         'parent', gca0 );
    hndl.rlocuspl_asymptote = asymp_h;
  else
    set( hndl.rlocuspl_asymptote, ...
     'xdata', real(asymptotes(:)), ...
     'ydata', imag(asymptotes(:)), ...
     'color', 1-get(gca0,'color'), ...
     'LineStyle','--', ...
     'LineWidth', 0.5, ...
     'visible','on');
  end
  if isempty(neg_asymp_h)
    neg_asymp_h = ...
      plot( real(neg_asymptotes(:)), imag(neg_asymptotes(:)), ...
         'LineStyle','--', ...
         'LineWidth', 0.5, ...
         'color','r', ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'parent', gca0, ...
         'visible', negloci_vis, ...
         'tag','rlocuspl neg_asymptote' );
    hndl.rlocuspl_neg_asymptote = neg_asymp_h;
  else
    set( hndl.rlocuspl_neg_asymptote, ...
     'xdata', real(neg_asymptotes(:)), ...
     'ydata', imag(neg_asymptotes(:)), ...
     'LineStyle','--', ...
     'LineWidth', 0.5, ...
     'color','r', ...
     'visible', negloci_vis );
  end
else
  if isempty(asymp_h)
    asymp_h = ...
      plot( 0, 0, ...
         'LineStyle','--', ...
         'LineWidth', 0.5, ...
         'color', 1-get(gca0,'color'), ...
         'hittest','off', ...
         'parent', gca0, ...
         'tag','rlocuspl asymptote');
    set( asymp_h,'xdata', [],'ydata', [] );
    hndl.rlocuspl_asymptote = asymp_h;
  end
  if isempty(neg_asymp_h)
    neg_asymp_h = ...
      plot( 0, 0, ...
         'LineStyle','--', ...
         'LineWidth', 0.5, ...
         'color','r', ...
         'hittest','off', ...
         'parent', gca0, ...
         'tag','rlocuspl neg_asymptote');
    set( neg_asymp_h,'xdata', [],'ydata', [] );
    hndl.rlocuspl_neg_asymptote = neg_asymp_h;
  end
  set( asymp_h,'visible','off')
  set( neg_asymp_h,'visible','off')
end

set(gcf0,'UserData',temp0);

ax_ud.GAINS = GAINS;
set( gca0,'UserData', ax_ud );

if ( numel(XLimit)==2 ) && ( numel(YLimit)==2 )
  set(gca0,'XLim',XLimit,'YLim',YLimit);
  if ~isempty(hndl)
    hndl.ax_xlim = XLimit;
    hndl.ax_ylim = YLimit;
  end
end

if nr_poles > 30
  pz_markersize = 10;
  zero_markersize = 8;
  pole_markersize = 10;
  pz_linewidth = 2;
else
  pz_markersize = 12;
  zero_markersize = 10;
  pole_markersize = 12;
  pz_linewidth = 2.5;
end

if strcmpi( Domain,'s')
  temp1 = PZG(1).ZeroLocs;
else
  temp1 = PZG(2).ZeroLocs;
end
if ~isfield(hndl,'rlocuspl_zero_markers')
  hndl.rlocuspl_zero_markers = [];
end
if ~isempty(temp1)
  if isempty(hndl.rlocuspl_zero_markers) ...
    || ~ishandle(hndl.rlocuspl_zero_markers)
    hndl.rlocuspl_zero_markers = ...
      plot( real(temp1), imag(temp1), ...
         'color', [1 0 0], ...
         'marker','o', ...
         'MarkerSize', pz_markersize, ...
         'linestyle','none', ...
         'LineWidth', pz_linewidth, ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'tag','rlocuspl zero markers', ...
         'parent', gca0 );
    setappdata( gcf0,'hndl', hndl );
  else
    set( hndl.rlocuspl_zero_markers, ...
        'xdata', real(temp1), ...
        'ydata', imag(temp1), ...
        'MarkerSize', pz_markersize, ...
        'LineWidth', pz_linewidth, ...
        'visible','on')
  end
else
  if isequal( 1, ishandle(hndl.rlocuspl_zero_markers) )
    set( hndl.rlocuspl_zero_markers, ...
        'xdata', [],'ydata', [], ...
        'visible','off')
  end
end

if isfield( hndl,'rlocuspl_PADE_pole_markers')
  padepoles_h = hndl.rlocuspl_PADE_pole_markers;
else
  padepoles_h = pzg_fndo( 1, 10,'rlocuspl_PADE_pole_markers');
end
if isfield( hndl,'rlocuspl_PADE_zero_markers')
  padezeros_h = hndl.rlocuspl_PADE_zero_markers;
else
  padezeros_h = pzg_fndo( 1, 10,'rlocuspl_PADE_zero_markers');
end

if strcmp( Domain,'s') && ( PZG(1).PureDelay > 0 )
  if isfield(PZG(1),'pade') && isfield(PZG(1).pade,'Z')
    if isempty(padezeros_h)
      hndl.rlocuspl_PADE_zero_markers = ...
        plot( real(PZG(1).pade.Z), imag(PZG(1).pade.Z), ...
          'marker','o', ...
          'MarkerSize', zero_markersize, ...
          'LineWidth', pz_linewidth, ...
          'linestyle','none', ...
          'color',[0.7 0.7 0.7], ...
          'hittest','off', ...
          'handlevisibility','off', ...
          'tag','rlocuspl PADE zero markers', ...
          'parent', gca0 );
      PZG(1).plot_h{10}.hndl.rlocuspl_PADE_zero_markers = ...
        hndl.rlocuspl_PADE_zero_markers;
      PZG(2).plot_h{10}.hndl.rlocuspl_PADE_zero_markers = ...
        hndl.rlocuspl_PADE_zero_markers;
    else
      set( padezeros_h, ...
        'xdata', real(PZG(1).pade.Z), ...
        'ydata', imag(PZG(1).pade.Z), ...
        'marker','o', ...
        'MarkerSize', zero_markersize, ...
        'LineWidth', pz_linewidth, ...
        'linestyle','none', ...
        'color',[0.7 0.7 0.7], ...
        'visible','on');
    end
  end
end

if strcmpi( Domain,'s')
  temp1 = PZG(1).PoleLocs;
else
  temp1 = PZG(2).PoleLocs;
end
if isfield( hndl,'rlocuspl_OL_pole_markers')
  OLpole_h = hndl.rlocuspl_OL_pole_markers;
else
  OLpole_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_OL_pole_markers');
end
if ~isempty(temp1)
  if isempty(OLpole_h) || ~isequal( 1, ishandle(OLpole_h) )
    hndl.rlocuspl_OL_pole_markers = ...
      plot(real(temp1),imag(temp1), ...
        'color', [0 1 0], ...
        'marker','x', ...
        'MarkerSize', pole_markersize, ...
        'linestyle','none', ...
        'LineWidth', pz_linewidth, ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'tag','rlocuspl OL pole markers', ...
        'parent', gca0);
  else
    set( OLpole_h, ...
      'xdata', real(temp1), ...
      'ydata', imag(temp1), ...
      'MarkerSize', pole_markersize, ...
      'LineWidth', pz_linewidth, ...
      'visible','on')
  end
else
  if isempty(OLpole_h)
    hndl.rlocuspl_OL_pole_markers = ...
      plot( 0, 0, ...
        'color', [0 1 0], ...
        'linestyle','none', ...
        'LineWidth', pz_linewidth, ...
        'marker','x', ...
        'MarkerSize', pz_markersize, ...
        'tag','rlocuspl OL pole markers', ...
        'parent', gca0);
  else
    hndl.rlocuspl_OL_pole_markers = OLpole_h;
  end
  set( hndl.rlocuspl_OL_pole_markers,'xdata',[],'ydata',[]);
end

if strcmp( Domain,'s') && ( PZG(1).PureDelay > 0 )
  if isfield(PZG(1),'pade') && isfield(PZG(1).pade,'P')
    if isempty(padepoles_h) || ~isequal( 1, ishandle(padepoles_h) )
      hndl.rlocuspl_PADE_pole_markers = ...
        plot( real(PZG(1).pade.P), imag(PZG(1).pade.P), ...
           'color',[0.7 0.7 0.7], ...
           'linestyle','none', ...
           'LineWidth', pz_linewidth, ...
           'marker','x', ...
           'MarkerSize', pole_markersize, ...
           'hittest','off', ...
           'handlevisibility','off', ...
           'tag','rlocuspl PADE pole markers', ...
           'parent', gca0 );
    else
      set( padepoles_h, ...
        'xdata', real(PZG(1).pade.P), ...
        'ydata', imag(PZG(1).pade.P), ...
        'color',[0.7 0.7 0.7], ...
        'linestyle','none', ...
        'LineWidth', pz_linewidth, ...
        'marker','x', ...
        'MarkerSize', pole_markersize, ...
        'visible','on');
    end
  else
    if isempty(padepoles_h) || ~isequal( 1, ishandle(padepoles_h) )
      hndl.rlocuspl_PADE_pole_markers = ...
        plot( 0, 0, ...
           'color',[0.7 0.7 0.7], ...
           'linestyle','none', ...
           'LineWidth', pz_linewidth, ...
           'marker','x', ...
           'MarkerSize', pole_markersize, ...
           'hittest','off', ...
           'handlevisibility','off', ...
           'tag','rlocuspl PADE pole markers', ...
           'parent', gca0 );
    else
      hndl.rlocuspl_PADE_pole_markers = padepoles_h;
    end
    set( hndl.rlocuspl_PADE_pole_markers,'xdata',[],'ydata',[]);
  end
elseif strcmp( Domain,'z') && ( PZG(2).PureDelay > 0 )
  if isempty(padepoles_h) || ~isequal( 1, ishandle(padepoles_h) )
    hndl.rlocuspl_PADE_pole_markers = ...
      plot( zeros(PZG(2).PureDelay,1), zeros(PZG(2).PureDelay,1), ...
        'color',[0.7 0.7 0.7], ...
        'linestyle','none', ...
        'LineWidth', pz_linewidth, ...
        'marker','x', ...
        'MarkerSize', pole_markersize, ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'tag','rlocuspl PADE pole markers', ...
        'parent', gca0 );
  else
    set( padepoles_h, ...
      'xdata', zeros(PZG(2).PureDelay,1), ...
      'ydata', zeros(PZG(2).PureDelay,1), ...
      'color',[0.7 0.7 0.7], ...
      'linestyle','none', ...
      'LineWidth', pz_linewidth, ...
      'marker','x', ...
      'MarkerSize', pole_markersize, ...
      'visible','on');
  end
else
  if isempty(padepoles_h) || ~isequal( 1, ishandle(padepoles_h) )
    hndl.rlocuspl_PADE_pole_markers = ...
      plot( 0, 0, ...
         'color',[0.7 0.7 0.7], ...
         'linestyle','none', ...
         'LineWidth', pz_linewidth, ...
         'marker','x', ...
         'MarkerSize', pole_markersize, ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'tag','rlocuspl PADE pole markers', ...
         'parent', gca0 );
  else
    hndl.rlocuspl_PADE_pole_markers = padepoles_h;
  end
  set( hndl.rlocuspl_PADE_pole_markers,'xdata',[],'ydata',[]);
end

if PZG(dom_ndx).PureDelay > 0
  if dom_ndx == 1
    all_zeros = [ PZG(1).ZeroLocs(:); PZG(1).pade.Z(:) ];
    all_poles = [ PZG(1).PoleLocs(:); PZG(1).pade.P(:) ];
  else
    all_zeros = PZG(2).ZeroLocs(:);
    all_poles = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
  end
else
  all_zeros = PZG(dom_ndx).ZeroLocs;
  all_poles = PZG(dom_ndx).PoleLocs;
end
[ hndl, mod_hndl ] = pzg_maprep( all_zeros,'zero', hndl );
if mod_hndl
  setappdata( gcf0,'hndl', hndl );
  PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.zero_repstr_h = hndl.zero_repstr_h;
end
[ hndl, mod_hndl ] = pzg_maprep( all_poles,'pole', hndl );
if mod_hndl
  setappdata( gcf0,'hndl', hndl );
  PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.pole_repstr_h = hndl.pole_repstr_h;
end

if isfield( hndl,'rlocuspl_CL_pole_markers')
  CLpole_markers_h = hndl.rlocuspl_CL_pole_markers;
else
  CLpole_markers_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_CL_pole_markers');
end
if ~isempty(PZG(dom_ndx).CLPoleLocs)
  if isempty(CLpole_markers_h)
    hndl.rlocuspl_CL_pole_markers = ...
      plot( real(PZG(dom_ndx).CLPoleLocs), imag(PZG(dom_ndx).CLPoleLocs), ...
        'color',[0 0.7 0.7], ...
        'linestyle','none', ...
        'LineWidth', pz_linewidth, ...
        'marker','s', ...
        'MarkerSize', pz_markersize-2, ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'tag','rlocuspl CL pole markers', ...
        'parent', gca0 );
  else
    set( CLpole_markers_h, ...
      'xdata', real(PZG(dom_ndx).CLPoleLocs), ...
      'ydata', imag(PZG(dom_ndx).CLPoleLocs), ...
      'color',[0 0.7 0.7], ...
      'linestyle','none', ...
      'LineWidth', pz_linewidth, ...
      'marker','s', ...
      'MarkerSize', pz_markersize-2, ...
      'visible','on')
  end
else
  if isempty(CLpole_markers_h)
    hndl.rlocuspl_CL_pole_markers = ...
      plot( 0, 0, ...
        'color',[0 0.7 0.7], ...
        'linestyle','none', ...
        'LineWidth', pz_linewidth, ...
        'marker','s', ...
        'MarkerSize', pz_markersize-2, ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'tag','rlocuspl CL pole markers', ...
        'parent', gca0 );
  else
    hndl.rlocuspl_CL_pole_markers = CLpole_markers_h;
  end
  set( hndl.rlocuspl_CL_pole_markers,'xdata',[],'ydata',[],'visible','off')
end

% Create a legend for the plot.
line_h = ...
  [ pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_zero_markers'); ...
    pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_OL_pole_markers'); ...
    pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_CL_pole_markers') ];
if isempty(line_h)
  line_h = ...
    [ hndl.rlocuspl_zero_markers; ...
      hndl.rlocuspl_OL_pole_markers; ...
      hndl.rlocuspl_CL_pole_markers ];
end

asymp_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_asymptote');
if isempty(asymp_h) && isfield( hndl,'rlocuspl_asymptote')
  asymp_h = hndl.rlocuspl_asymptote;
end

if strcmpi( PZG(dom_ndx).DefaultBackgroundColor,'k')
  bg_color = [0 0 0];
else
  bg_color = [1 1 1];
end

% Support legend creation in Version 6.5.2.
if ( max(abs(Loci)) ~= 0 )
  ver_nr = version;
  if ver_nr(1) >= '7'
    if isempty(PZG(dom_ndx).ZeroLocs)
      lgd_h = ...
        [ hndl.rlocuspl_OL_pole_markers; ...
          hndl.rlocuspl_CL_pole_markers ];
      lgd_str = {'O.L.poles';'C.L.poles'};
      if nr_asymp > 0
        lgd_h = [ lgd_h; asymp_h ];
        if nr_asymp == 1
          lgd_str = {'O.L.poles';'C.L.poles';'asymptote'};
        else
          lgd_str = {'O.L.poles';'C.L.poles';'asymptotes'};
        end
      end
    else
      lgd_h = ...
        [ hndl.rlocuspl_zero_markers; ...
          hndl.rlocuspl_OL_pole_markers; ...
          hndl.rlocuspl_CL_pole_markers ];
      lgd_str = {'O.L.zeros';'O.L.poles';'C.L.poles'};
      if ( nr_asymp > 0 ) && isequal( 1, numel(asymp_h) ) 
        lgd_h = [ lgd_h; asymp_h ];
        if nr_asymp == 1
          lgd_str = {'O.L.zeros';'O.L.poles';'C.L.poles';'asymptote'};
        else
          lgd_str = {'O.L.zeros';'O.L.poles';'C.L.poles';'asymptotes'};
        end
      end
    end
    
    legend_h = ...
      legend( lgd_h, lgd_str, ...
        'color', bg_color, ...
        'textcolor', 1-bg_color, ...
        'location','northwest', ...
        'hittest','off', ...
        'tag','pzg rtloc legend', ...
        'parent', gcf0 );
  else
    if numel(line_h) == 3
      lgd_str = {'O.L.zeros';'O.L.poles';'C.L.poles'};
    else
      lgd_str = {'O.L.zeros';'O.L.poles';'C.L.poles'};
    end
    legend_h = ...
      legend( line_h, lgd_str, ...
        'color', bg_color, ...
        'textcolor', 1-bg_color, ...
        'location','northwest', ...
        'hittest','off', ...
        'tag','pzg rtloc legend', ...
        'parent', gcf0 );
  end
  hndl.legend = legend_h;
end

% Create the dynamic gain marker (shown during mouse motion).
this_color = 1 - get( gca0,'color');
dyngain_h = pzg_fndo( dom_ndx, 9+dom_ndx,'dynamic_gain_marker');
if isempty(dyngain_h) && isfield( hndl,'dynamic_gain_marker')
  dyngain_h = hndl.dynamic_gain_marker;
end
if isempty(dyngain_h)
  hndl.dynamic_gain_marker = ...
    plot( 0, 0, ...
      'color', this_color, ...
      'linestyle','none', ...
      'linewidth', pz_linewidth+1, ...
      'marker','s', ...
      'markersize', pz_markersize+2, ...
      'hittest','off', ...
      'visible','off', ...
      'parent', gca0, ...
      'tag','dynamic gain marker');
else
  hndl.dynamic_gain_marker = dyngain_h;
end

if ~isempty(BtnDwnFn)
  set(gcf0,'WindowButtonDownFcn', BtnDwnFn );
end
set(gcf0,'windowbuttonmotionfcn', ...
     ['try,' ...
      'if pzg_disab,return,end,' ...
      'pzgcalbk(gcbf,''mouse motion'');pzg_ptr;' ...
      'catch,pzg_err(''mouse motion rlocus'');' ...
      'end'])

if isempty(showgrid_h)
  if strcmp( Domain,'z')
    Callback = ...
      ['global PZG,' ...
       'if~get(gcbo,''Value'');' ...
         'set(PZG(2).plot_h{11}.hndl.rlocuspl_constant_Wn_line,' ...
            '''Visible'',''Off'');' ...
         'set(PZG(2).plot_h{11}.hndl.rlocuspl_constant_zeta_line(2:end),' ...
            '''Visible'',''Off'');' ...
       'else;' ...
         'set(PZG(2).plot_h{11}.hndl.rlocuspl_constant_Wn_line,' ...
            '''Visible'',''On'');' ...
         'set(PZG(2).plot_h{11}.hndl.rlocuspl_constant_zeta_line,' ...
            '''Visible'',''On'');' ...
       'end;' ...
       'clear temp;'];
  else
    Callback = ...
      ['global PZG,' ...
       'if~get(gcbo,''value''),' ...
         'set(PZG(1).plot_h{10}.hndl.Splane_constWn_semicirc,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Splane_constZeta_lines,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Splane_constWn_semicirc_repeated,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Splane_constZeta_lines_repeated,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Splane_halfTS_lines,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Splane_fullTS_lines,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Wplane_constWn_lines,' ...
           '''visible'',''off'');' ...
         'set(PZG(1).plot_h{10}.hndl.Wplane_constZeta_lines,' ...
           '''visible'',''off'');' ...
       'else,' ...
         'pzg_grid(get(PZG(1).plot_h{10}.fig_h,''userdata''),' ...
           'PZG(1).plot_h{10}.fig_h,' ...
           'PZG(1).plot_h{10}.ax_h,' ...
           '10,PZG(1).plot_h{10}.hndl);' ... 
       'end']; 
  end

  showgrid_h = uicontrol( gcf0,'Style','checkbox', ...
      'String','Grid', ...
      'Units','normalized', ...
      'Value', 1, ...
      'Position',[0.89 0.005 0.10 0.05], ...
      'BackgroundColor', get(gcf0,'color'), ...
      'ForegroundColor', 1-get(gcf0,'color'), ...
      'tag','rlocuspl show grid', ...
      'Callback', Callback );
  hndl.rlocuspl_show_grid = showgrid_h;
end

if strcmp( Domain,'z')
  if isfield( hndl,'rlocuspl_constant_zeta_line')     % Z-Plane
    HH1 = hndl.rlocuspl_constant_zeta_line;
  else
    HH1 = [];
  end
  if isfield( hndl,'rlocuspl_constant_Wn_line')     % Z-Plane
    HH2 = hndl.rlocuspl_constant_Wn_line;
  else
    HH2 = [];
  end
  if isempty(HH1) || isempty(HH2)
    Zetas = [ 0; 0.01; 0.02; 0.05; (0.1:0.1:0.9)'];
    normPt = -Zetas + 1i*sqrt(1-Zetas.^2);
    LogBase = [(0:0.0001:0.0099), logspace(-2,0,125),...
               logspace(0,log10(pi),75)]';
    ZLog = zeros(size(LogBase));
    ZLog(:,1) = exp(normPt(1)*LogBase);
    for Ck = 2:numel(Zetas)
      ZLog(:,Ck)=exp(normPt(Ck)*LogBase/imag(normPt(Ck)));
    end
    ZLog = [ ZLog; NaN*ones(1,size(ZLog,2)); ...
             conj( ZLog ); NaN*ones(1,size(ZLog,2)) ];
    if ~isequal( size(ZLog,2), numel(HH1) )
      HH1 = plot( ZLog, ...
        'color',[0.7 0.7 0], ...
        'linestyle',':', ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'parent', gca0, ...
        'tag','rlocuspl constant zeta line');
      set( HH1(1),'Color',[0 1 1],'linestyle','-','tag','');
      hndl.rlocuspl_constant_zeta_line = HH1;
      setappdata( gcf0,'hndl', hndl );
      pzg_cphndl( gcf0, 2, 11 );
    end

    LogBase = logspace(-3,log10(pi/2),150)';
    normPt = pi*( -cos(LogBase)+1i*sin(LogBase) );
    ZLog = zeros( numel(normPt), 10 );
    ZLog(:,1) = exp( 0.1*normPt );
    for Ck = 2:10
      ZLog(:,Ck) = exp( (Ck/10)*normPt );
    end
    ZLog = [ ZLog; NaN*ones(1,size(ZLog,2)); ...
             conj( ZLog ); NaN*ones(1,size(ZLog,2)) ];
    if ~isequal( 1, numel(HH2) )
      HH2 = plot( ZLog(:),'c:', ...
        'hittest','off', ...
        'handlevisibility','off', ...
        'parent', gca0, ...
        'tag','rlocuspl constant Wn line');
      hndl.rlocuspl_constant_Wn_line = HH2;
      setappdata( gcf0,'hndl', hndl );
      pzg_cphndl( gcf0, 2, 11 );
    end
    
    set( gcf0,'userdata', temp0 );
    setappdata( gcf0,'hndl', hndl );
  end
  
elseif strcmp( Domain,'s')
  [ temp0, hndl, mod_hndl ] = pzg_grid( temp0, gcf0, gca0, 10, hndl );
  set( gcf0,'userdata', temp0 );
  if mod_hndl
    setappdata( gcf0,'hndl', hndl );
    pzg_cphndl( gcf0, dom_ndx, 9+dom_ndx );
  end
  HH = []; %#ok<NASGU>
end
pzg_ptr;

if isfield( hndl,'PZmap_xaxis_highlight')
  x_hilite_h = hndl.PZmap_xaxis_highlight;
else
  x_hilite_h = findobj(gca0,'tag','rlocuspl x-axis highlight');
end
if ~isempty(x_hilite_h)
  set( x_hilite_h,'xdata',get(gca0,'XLim'),'ydata',[0 0]) 
end
if isfield( hndl,'PZmap_yaxis_highlight')
  y_hilite_h = hndl.PZmap_yaxis_highlight;
else
  y_hilite_h = findobj(gca0,'tag','rlocuspl y-axis highlight');
end
if ~isempty(y_hilite_h)
  set( y_hilite_h,'xdata',[0 0],'ydata',get(gca0,'ylim')) 
end

HH = [];

if isempty(show_negrloci_h)
  show_negrloci_h = uicontrol( gcf0,'Style','checkbox', ...
    'String','Negative Loci', ...
    'Units','normalized', ...
    'Value', 0, ...
    'Position',[0.62 0.005 0.23 0.05], ...
    'BackgroundColor', get(gcf0,'color'), ...
    'ForegroundColor',1-get(gcf0,'color'), ...
    'tag','rlocuspl show neg root loci', ...
    'userdata', HH, ...
    'Callback','rlocuspl(''Neg. Loci checkbox'');');
  hndl.rlocuspl_show_neg_root_loci = show_negrloci_h;
end

% Keep the x-scale and y-scale reasonable, 
% with respect to the pole/zero locations.
if strcmp( Domain,'s')
    Xmin = min( real( [PZG(1).PoleLocs; ...
                       PZG(1).CLPoleLocs; ...
                       PZG(1).ZeroLocs;
                       PZG(1).pade.P;
                       PZG(1).pade.Z ] ) ) * 10;
    Xmax = max( real( [PZG(1).PoleLocs; ...
                       PZG(1).CLPoleLocs; ...
                       PZG(1).ZeroLocs;
                       PZG(1).pade.P;
                       PZG(1).pade.Z ] ) );
    if isempty(Xmin)
        Xmin = -1;
    end
    if isempty(Xmax)
        Xmax = 0;
    end
    if Xmin > 0
        Xmin = Xmin/10;
    else
        Xmin = Xmin*10;
    end
    if Xmax < 0
        Xmax = Xmax/10;
    else
        Xmax = Xmax*10;
    end
    Ymax = max( imag( [PZG(1).PoleLocs; ...
                       PZG(1).CLPoleLocs; ...
                       PZG(1).ZeroLocs;
                       PZG(1).pade.P;
                       PZG(1).pade.Z ] ) ) * 10;
    if isempty(Ymax)
        Ymax = 3;
    end
else
    Xmin = min( real( [PZG(2).PoleLocs; ...
                       PZG(2).CLPoleLocs; ...
                       PZG(2).ZeroLocs ] ) );
    Xmax = max( real( [PZG(2).PoleLocs; ...
                       PZG(2).CLPoleLocs; ...
                       PZG(2).ZeroLocs ] ) );
    Ymax = max( imag( [PZG(2).PoleLocs; ...
                       PZG(2).CLPoleLocs; ...
                       PZG(2).ZeroLocs ] ) );
    if isempty(Xmin)
        Xmin = -1;
    end
    if isempty(Xmax)
        Xmax = 1;
    end
    if isempty(Ymax)
        Ymax = 1;
    end
    Xmin = min( Xmin, -1 );
    Xmax = max( Xmax, 1 );
    Ymax = max( Ymax, 1 );
end

XLim = get( gca0,'xlim');
XLim(1) = min( XLim(1), Xmax );
XLim(2) = max( 0, max( XLim(2), Xmin ) );

YLim = get( gca0,'YLim');
if ( YLim(1) < -30*Ymax ) && Ymax
    YLim(1) = max( YLim(1), -Ymax );
end
if ( YLim(2) > 30*Ymax ) && Ymax
    YLim(2) = min( YLim(2), Ymax );
end
if isempty(XLimit) || isempty(YLimit)
  set( gca0,'XLim', XLim,'YLim', YLim )
end
x_hilite_h = findobj( gca0,'tag','rlocuspl x-axis highlight');
set( x_hilite_h,'xdata', XLim,'ydata',[0 0] )
y_hilite_h = findobj( gca0,'tag','rlocuspl y-axis highlight');
set( y_hilite_h,'xdata',[0 0],'ydata', YLim )

if strcmp( Domain,'z')
  tempHz = findobj( gcf0,'tag','root locus unit circle button z-domain');
  if isempty(tempHz)
    uicontrol( gcf0,'style','pushbutton', ...
              'units','normalized', ...
              'position',[0.89 0.93 0.10 0.045], ...
              'string','Center', ...
              'tag','root locus unit circle button z-domain', ...
              'tooltipstring', ...
                'zoom in on region around the unit circle', ...
              'callback', ...
                 ['set(get(gcbf,''currentaxes''),' ...
                   '''xlim'',[-1.4 1.4],' ...
                   '''ylim'',[-1.1 1.1]);' ...
                  'PZG(1).plot_h{11}.xlim=[-1.4 1.4];' ...
                  'PZG(1).plot_h{11}.ylim=[-1.1 1.1];' ...
                  'PZG(2).plot_h{11}.xlim=[-1.4 1.4];' ...
                  'PZG(2).plot_h{11}.ylim=[-1.1 1.1];' ...
                  'PZG(1).plot_h{11}.hndl.ax_xlim=[-1.4 1.4];' ...
                  'PZG(1).plot_h{11}.hndl.ax_ylim=[-1.1 1.1];' ...
                  'PZG(2).plot_h{11}.hndl.ax_xlim=[-1.4 1.4];' ...
                  'PZG(2).plot_h{11}.hndl.ax_ylim=[-1.1 1.1];' ...
                  'set(PZG(2).plot_h{11}.hndl.PZmap_xaxis_highlight,' ...
                    '''xdata'',[-1.4 1.4],''ydata'',[0 0]);' ...
                  'set(PZG(2).plot_h{11}.hndl.PZmap_yaxis_highlight,' ...
                    '''xdata'',[0 0],''ydata'',[-1.1 1.1]);' ...
                  'temp_hndl=getappdata(gcbf,''hndl'');' ...
                  'temp_hndl.ax_xlim=[-1.4 1.4];' ...
                  'temp_hndl.ax_ylim=[-1.1 1.1];' ...
                  'setappdata(gcbf,''hndl'',temp_hndl);' ...
                  'clear temp_hndl']);
  end
else
  tempHs = findobj( gcf0,'tag','root locus unit circle button s-domain');
  if isempty(tempHs)
    uicontrol( gcf0,'style','pushbutton', ...
      'units','normalized', ...
      'position',[0.89 0.93 0.10 0.045], ...
      'string','Center', ...
      'tag','root locus unit circle button s-domain', ...
      'tooltipstring','Zoom in to central region of the root locus', ...
      'callback','rlocuspl(''center it'')');
  end
end

% Adjust the background color.
this_bg_color = get( gcf0,'color');
if isequal( this_bg_color, [0 0 0] )
  this_bg_color = 'k';
elseif isequal( this_bg_color, [1 1 1] )
  this_bg_color = 'w';
end
if ~isequal( this_bg_color, PZG(1).DefaultBackgroundColor )
  if isreal(this_bg_color) || ~ismember( this_bg_color, {'k','b','w'} ) 
    if isreal(this_bg_color) && ~ischar(this_bg_color)
      if max(this_bg_color) > 0.5
        this_bg_color = 'w';
      else
        this_bg_color = 'k';
      end
    else
      this_bg_color = PZG(1).DefaultBackgroundColor;
    end
  end
  figopts('this_plot', this_bg_color, gcf0 )
end

if isfield( hndl,'Bode_selection_marker')
  bodesel_h = hndl.Bode_selection_marker;
else
  bodesel_h = pzg_fndo( dom_ndx, 9+dom_ndx,'Bode_selection_marker');
  hndl.Bode_selection_marker = bodesel_h;
end
if isempty(bodesel_h)
  bodesel_h = ...
    plot( 0, 0, ...
         'linestyle','none', ...
         'linewidth', 3, ...
         'marker','o', ...
         'markersize', 4, ...
         'color',[0 0.8 0.8], ...
         'hittest','off', ...
         'handlevisibility','off', ...
         'parent', gca0, ...
         'visible','off', ...
         'tag','Bode selection marker');
  hndl.Bode_selection_marker = bodesel_h;
end
if isempty(PZG(dom_ndx).FrqSelNdx) ...
    || ( PZG(dom_ndx).FrqSelNdx < 1 ) ...
    || ( PZG(dom_ndx).FrqSelNdx > numel(PZG(dom_ndx).BodeFreqs) )
  set( bodesel_h,'visible','off');
else
  sel_point = PZG(dom_ndx).BodeFreqs(PZG(dom_ndx).FrqSelNdx);
  if isinf(sel_point)
    set( bodesel_h,'visible','off');
  else
    if ( dom_ndx == 2) && PZG(dom_ndx).NegSelect
      sel_point = -sel_point;
    end
    if ~PZG(dom_ndx).pzg_show_frf_computation
      tempVis = 'off';
    else
      tempVis = 'on';
    end
    if dom_ndx == 2
      sel_point = exp( 1i*sel_point * PZG(2).Ts );
    else
      sel_point = 1i*sel_point;
    end
    set( bodesel_h, ...
        'xdata', real(sel_point), ...
        'ydata', imag(sel_point), ...
        'visible', tempVis );
  end
end

setappdata( gcf0,'hndl', hndl )
pzg_cphndl( gcf0, dom_ndx, 9+dom_ndx );

if isequal( get(gcf0,'visible'),'off')
  set( gcf0,'visible','on')
end

freqserv('refresh_plot_h', gcf0 );
pzg_seltxt(dom_ndx)
  
if newFigure
  local_center_it( gcf0, dom_ndx )
  pzg_prvw( dom_ndx );
end

if ishandle(wb_h)
  delete(wb_h)
end

if isequal( 1, ishandle(gca0) )
  set( gca0,'tag','pzg root locus plot axes');
end

pzg_cphndl( gcf0, dom_ndx, 9+dom_ndx )

return

% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%
% PRIVATE FUNCTION:
%                    local_rlocserv(Gain)
%
% This function services callbacks from the root locus plots.

function  local_rlocserv(Gain)

global PZG

if ( numel(Gain) ~= 1 ) || ~isreal(Gain)
  display('Input argument GAIN must be a real scalar.');
  return
end

gcf0 = gcbf;
if isempty(gcf0)
  return
end
gcf_name = get(gcf0,'name');
if isempty( strfind( gcf_name,'Root Locus') )
  return
elseif ~isempty(strfind( gcf_name,'Continuous'))
  Domain = 's';
  dom_ndx = 1;
else
  Domain = 'z';
  dom_ndx = 2;
end

temp0 = get( gcf0,'UserData');
if isempty(temp0)
  return
end
if isappdata( gcf0,'hndl')
  hndl = getappdata( gcf0,'hndl');
else
  return
end
if isempty( PZG(dom_ndx).plot_h{9+dom_ndx})
  pzg_cphndl( gcf0, 1, 9+dom_ndx );
  pzg_cphndl( gcf0, 2, 9+dom_ndx );
end

gca0 = hndl.ax;
gain_marker_h = hndl.rlocuspl_gain_marker;
parameterK_h = hndl.rlocuspl_gain_text;

HH = [];

if strcmp( Domain,'z')
  MM = [ hndl.PZmap_xaxis_highlight; ...
         hndl.PZmap_yaxis_highlight ];
else
  MM = [ hndl.PZmap_xaxis_highlight; ...
         hndl.PZmap_yaxis_highlight ];
end

if ~isempty(gcbo) ...
  && strcmpi( get(gcbo,'type'),'uicontrol') ...
  && strcmpi( get(gcbo,'tag'),'rlocuspl gain text')
  if isempty( get(gcbo,'string') )
    set( hndl.rlocuspl_gain_marker,'xdata',[],'ydata',[],'visible','off')
  end
  
  for k = 1:2
    if ( temp0(end-1,k) > 0 ) && ~isequal( temp0(end-1,k), gcbo )
      set(temp0(end-1,k),'Visible','Off')
    end
  end
  set( gcbo,'visible','on','backgroundcolor',[0.9 0.9 0.9])
  
  if ~isempty(HH)
    set(HH,'Visible','Off')
  end
  if ~isempty(MM)
    set(MM,'Visible','Off')
  end
  
  parameter_K = str2num( get(parameterK_h,'string') ); %#ok<ST2NM>
  if ~isequal( numel(parameter_K), 1 ) || ~isreal(parameter_K) ...
    ||( abs(parameter_K) < 1e-15 ) 
    set(gcbo,'string','');
    if ~isempty(gain_marker_h)
      set( gain_marker_h, ...
          'xdata',[], ...
          'ydata',[], ...
          'visible','off' );
      set( parameterK_h,'string','','backgroundcolor',[0.9 0.9 0.9])
    end
  else
    set( parameterK_h,'string', num2str(parameter_K), ...
        'backgroundcolor', [ 0.9 0.9 0])
    AA = [];
    BC = [];
    DD = [];
    if ~isempty(gcbf) && ~isempty(gca0)
      ax_ud = get( gca0,'userdata');
      if ~isempty(ax_ud) && isstruct(ax_ud) ...
        && isfield( ax_ud,'AA') && isfield( ax_ud,'BC') ...
        && isfield( ax_ud,'DD')
        AA = ax_ud.AA;
        BC = ax_ud.BC;
        DD = ax_ud.DD;
      end
    end
    if isempty(AA)
      if strcmp(Domain,'s')
        modalss = pzg_moda( 1, 1, 1, 0,'', 1 );
      else
        modalss = pzg_moda( 2, 1, 1, 0,'', 1 );
      end
      if ~isempty(modalss)
        AA = modalss.a;
        BC = modalss.b * modalss.c;
        DD = modalss.d;
      end
    end
    
    if ~isempty(AA)
      if (DD+1/parameter_K) ~= 0
        CLpoles = eig( AA-BC/(DD+1/parameter_K) );
      else
        CLpoles = inf*ones(size(AA,1),1);
      end
    else
      CLpoles = [];
    end
    if strcmp(Domain,'s')
      OLpoles = PZG(1).PoleLocs;
      OLzeros = PZG(1).ZeroLocs;
      OLgain = parameter_K * PZG(1).Gain;
      if PZG(1).PureDelay ~= 0
        OLpoles = [ OLpoles; PZG(1).pade.P ];
        OLzeros = [ OLzeros; PZG(1).pade.Z ];
        OLgain = OLgain * PZG(1).pade.K;
      end
    else
      OLpoles = PZG(2).PoleLocs;
      OLzeros = PZG(2).ZeroLocs;
      OLgain = parameter_K * PZG(2).Gain;
      if PZG(2).PureDelay ~= 0
        OLpoles = [ OLpoles; ones(PZG(2).PureDelay,1) ];
      end
    end
    if isempty(CLpoles)
      OLnum = OLgain*poly( OLzeros );
      OLden = poly( OLpoles );
      CLden = OLden;
      CLden(end-numel(OLnum)+1:end) = ...
        CLden(end-numel(OLnum)+1:end) + OLnum;
      CLpoles = roots(CLden);
    end
    
    if ~isempty(gain_marker_h)
      set( gain_marker_h, ...
          'xdata', real(CLpoles), ...
          'ydata', imag(CLpoles), ...
          'visible','on' );
      set( parameterK_h, ...
          'string',num2str(parameter_K),'backgroundcolor',[0.9 0.9 0])
    end
  end
  
elseif strcmp( get( gcf0,'SelectionType'),'open')
  set( hndl.rlocuspl_gain_marker,'visible','off')
  local_grids_and_hilites_off(hndl)
  set(gca0,'XLimMode','auto','YLimMode','auto');
  XLims = get( gca0,'XLim');
  YLims = get( gca0,'YLim');
  if ~isempty( strfind( get( gcf0,'Name'),'Discrete-Time') )
    XLims(1) = min( -1.1, XLims(1) );
    XLims(2) = max( 1.1, XLims(2) );
    YLims(1) = min( -1.1, YLims(1) );
    YLims(2) = max( 1.1, YLims(2) );
  else
    %YLims(1) = min( YLims(1), -pi/PZG(1).Ts );
    %YLims(2) = max( YLims(2), pi/PZG(1).Ts );
    XLims(2) = max( 0, XLims(2) );
    XLims(1) = min( XLims(1), YLims(1) );
    temp = [ findobj( allchild(0),'type','uicontrol', ...
                     'style','popupmenu','Tag','D-T LinkMethod'); ...
             findobj( allchild(0),'type','uicontrol', ...
                     'style','popupmenu','Tag','C-T LinkMethod') ];
    DTFig = findobj(allchild(0),'Name',PZG(2).PZGUIname );
    if ~isempty(temp) && ~isempty(DTFig)
      if get(temp(1),'Value') == 3
        if YLims(1) >= -pi/PZG(1).Ts
          YLims = YLims * 3;
        end
          XLims(1) = min( 1.4*YLims(1), XLims(1) );
      end
    end
  end
  set( gca0,'XLimMode','manual','XLim', XLims, ...
            'YLimMode','manual','YLim', YLims );
  hndl.ax_xlim = XLims;
  hndl.ax_ylim = YLims;
  setappdata( gcf0,'hndl', hndl );
  PZG(1).plot_h{9+dom_ndx}.xlim = XLims;
  PZG(2).plot_h{9+dom_ndx}.xlim = XLims;
  PZG(1).plot_h{9+dom_ndx}.ylim = YLims;
  PZG(2).plot_h{9+dom_ndx}.ylim = YLims;
  PZG(1).plot_h{9+dom_ndx}.hndl.ax_xlim = XLims;
  PZG(2).plot_h{9+dom_ndx}.hndl.ax_xlim = XLims;
  PZG(1).plot_h{9+dom_ndx}.hndl.ax_ylim = YLims;
  PZG(2).plot_h{9+dom_ndx}.hndl.ax_ylim = YLims;
  if isfield( hndl,'PZmap_xaxis_highlight')
    set( hndl.PZmap_xaxis_highlight,'xdata', XLims,'ydata',[0 0]);
  end
  if isfield( hndl,'PZmap_yaxis_highlight')
    set( hndl.PZmap_yaxis_highlight,'xdata', [0 0],'ydata', YLims );
  end
  if ~isempty( get( hndl.rlocuspl_gain_text,'string') )
    set( hndl.rlocuspl_gain_marker,'visible','on')
  end
  if dom_ndx == 1
    [ temp0, hndl, mod_hndl ] = ...
        pzg_grid( temp0, gcf0, gca0, 9+dom_ndx, hndl );
    if mod_hndl
      set( gcf0,'userdata', temp0 );
      setappdata( gcf0,'hndl', hndl );
    end
  end

elseif ~isempty( strfind( get(gcf0,'SelectionType'),'ext') ) ...
      ||~isempty( strfind( get(gcf0,'SelectionType'),'alt') )
  if isfield( hndl,'ax_xlim')
    hndl.ax_xlim = get( gca0,'xlim');
    hndl.ax_ylim = get( gca0,'ylim');
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.xlim = hndl.ax_xlim;
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.ylim = hndl.ax_ylim;
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_xlim = hndl.ax_xlim;
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_ylim = hndl.ax_ylim;
    setappdata( gcf0,'hndl', hndl );
  end
  XLims = hndl.ax_xlim;
  XLims(1) = XLims(1)-0.5*(XLims(2)-XLims(1));
  XLims(2) = XLims(2)+0.5*(XLims(2)-XLims(1));
  YLims = hndl.ax_ylim;
  YLims(1) = YLims(1)-0.5*(YLims(2)-YLims(1));
  YLims(2) = YLims(2)+0.5*(YLims(2)-YLims(1));
  set( gca0,'XLim', XLims,'YLim', YLims );
  hndl.ax_xlim = XLims;
  hndl.ax_ylim = YLims;
  PZG(1).plot_h{9+dom_ndx}.xlim = XLims;
  PZG(2).plot_h{9+dom_ndx}.xlim = XLims;
  PZG(1).plot_h{9+dom_ndx}.ylim = YLims;
  PZG(2).plot_h{9+dom_ndx}.ylim = YLims;
  PZG(1).plot_h{9+dom_ndx}.hndl.ax_xlim = XLims;
  PZG(2).plot_h{9+dom_ndx}.hndl.ax_xlim = XLims;
  PZG(1).plot_h{9+dom_ndx}.hndl.ax_ylim = YLims;
  PZG(2).plot_h{9+dom_ndx}.hndl.ax_ylim = YLims;
  if dom_ndx == 1
    [ temp0, hndl, mod_hndl ] = ...
        pzg_grid( temp0, gcf0, gca0, 9+dom_ndx, hndl );
    if mod_hndl
      set( gcf0,'userdata', temp0 );
      setappdata( gcf0,'hndl', hndl );
    end
  end

elseif strcmp( get(gcf0,'SelectionType'),'normal')
  if isfield( hndl,'ax_xlim')
    hndl.ax_xlim = get( gca0,'xlim');
    hndl.ax_ylim = get( gca0,'ylim');
    setappdata( gcf0,'hndl', hndl );
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.xlim = hndl.ax_xlim;
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.ylim = hndl.ax_ylim;
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_xlim = hndl.ax_xlim;
    PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_ylim = hndl.ax_ylim;
    if isfield( hndl,'PZmap_xaxis_highlight')
      set( hndl.PZmap_xaxis_highlight,'xdata', hndl.ax_xlim );
    end
    if isfield( hndl,'PZmap_yaxis_highlight')
      set( hndl.PZmap_yaxis_highlight,'ydata', hndl.ax_ylim );
    end
  end
  
  axes_currpt = get( gca0,'currentpoint');
  CurrPt = axes_currpt(1,1) + 1i*axes_currpt(1,2);
  
  % Evaluate the transfer function at this point.
  if Domain == 'z'
    all_poles = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
    cplx_ol_at_currpt = ...
      PZG(2).Gain ...
      * exp( sum( log( CurrPt - PZG(2).ZeroLocs ) ) ...
            -sum( log( CurrPt - all_poles ) ) );
  else
    all_zeros = PZG(1).ZeroLocs;
    all_poles = PZG(1).PoleLocs;
    all_gain = PZG(1).Gain;
    if PZG(1).PureDelay > 0
      [ pade_N, pade_D ] = pade( PZG(1).PureDelay, 4 );
      all_zeros = [ all_zeros; roots(pade_N) ];
      all_poles = [ all_poles; roots(pade_D) ];
      if pade_N(1) ~= 1
        all_gain = all_gain * pade_N(1);
      end
    end
    cplx_ol_at_currpt = ...
      all_gain ...
      * exp( sum( log( CurrPt - all_zeros ) ) ...
            -sum( log( CurrPt - all_poles ) ) );
  end
  cplx_ol_mag = abs(cplx_ol_at_currpt); 
  cplx_ol_angle = 180/pi*angle( cplx_ol_at_currpt );
  
  smallcirc_ptr = 0;
  if strcmpi( get(gcbf,'pointer'),'custom')
    ptr_shape_data = get(gcbf,'PointerShapeCData');
    if sum( isnan( ptr_shape_data(:) ) ) == 216
      smallcirc_ptr = 1;
    end
  end
  if smallcirc_ptr ...
    &&( ( abs( abs(cplx_ol_angle) - 180 ) < 25 ) ...
       ||( abs( abs(cplx_ol_angle) ) < 25 ) )
    
    set( hndl.rlocuspl_gain_marker,'visible','off')
    local_grids_and_hilites_off(hndl)
    
    if abs( abs(cplx_ol_angle) - 180 ) < 25
      this_gain = 1 / cplx_ol_mag;
    else
      this_gain = -1 / cplx_ol_mag;
    end
    disp_gain = this_gain;
    % Determine the closed-loop poles at this gain.
    ax_ud = get( gca0,'userdata');
    if ~isempty(ax_ud) && isstruct(ax_ud) ...
      && isfield( ax_ud,'AA') && isfield( ax_ud,'BC') ...
      && isfield( ax_ud,'DD')
      AA = ax_ud.AA;
      BC = ax_ud.BC;
      DD = ax_ud.DD;
    else
      AA = [];
      BC = [];
      DD = [];
    end
    if isempty(AA)
      if strcmp(Domain,'s')
        modalss = pzg_moda( 1, 1, 1, 0,'', 1 );
      else
        modalss = pzg_moda( 2, 1, 1, 0,'', 1 );
      end
      if ~isempty(modalss)
        AA = modalss.a;
        BC = modalss.b * modalss.c;
        DD = modalss.d;
      end
    end
    if ~isempty(AA)
      if (DD+1/this_gain) ~= 0
        CLpoles = eig( AA-BC/(DD+1/this_gain) );
      else
        CLpoles = inf*ones(size(AA,1),1);
      end
    else
      CLpoles = [];
    end
    if isempty(CLpoles)
      if Domain == 'z'
        N = poly( PZG(2).ZeroLocs ) * this_gain;
        P = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
        D = poly(P);
        D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
        CLpoles = roots(D);
      else
        Z = PZG(1).ZeroLocs;
        P = PZG(1).PoleLocs;
        if PZG(1).PureDelay > 0
          this_gain = this_gain * PZG(1).pade.K;
          Z = [ Z; PZG(1).pade.Z ];
          P = [ P; PZG(1).pade.P ];
        end
        N = this_gain * poly(Z);
        D = poly(P);
        % Close the loop.
        D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
        CLpoles = roots(D);
      end
    end
    
    % Make sure the cursor is near one of the closed-loop poles.
    CLpole_dist = inf;
    if ~isempty(CLpoles)
      if strcmpi( Domain,'z') ...
        && ( numel(PZG(2).plot_h) >= 10 ) ...
        && isfield( PZG(2).plot_h{11},'ax_h') ...
        && isequal( 1, ishandle(PZG(2).plot_h{11}.ax_h) )
        
        CLpole_xdist = ...
          abs( real(CurrPt) - real(CLpoles) ) ...
          /diff( get(PZG(2).plot_h{11}.ax_h,'xlim') );
        CLpole_ydist = ...
          abs( imag(CurrPt) - imag(CLpoles) ) ...
          /diff( get(PZG(2).plot_h{11}.ax_h,'ylim') );
        CLpole_dist = min( sqrt( CLpole_xdist.^2 + CLpole_ydist.^2 ) );
      elseif strcmpi( Domain,'s') ...
        && ( numel(PZG(1).plot_h) >= 10 ) ...
        && isfield( PZG(1).plot_h{10},'ax_h') ...
        && isequal( 1,ishandle(PZG(1).plot_h{10}.ax_h) )
        CLpole_xdist = ...
          abs( real(CurrPt) - real(CLpoles) ) ...
          /diff( get(PZG(1).plot_h{10}.ax_h,'xlim') );
        CLpole_ydist = ...
          abs( imag(CurrPt) - imag(CLpoles) ) ...
          /diff( get(PZG(1).plot_h{10}.ax_h,'ylim') );
        CLpole_dist = min( sqrt( CLpole_xdist.^2 + CLpole_ydist.^2 ) );
      end
    end
    
    if CLpole_dist < 0.025
      gainstr_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_gain_text');
      if ~isempty(gainstr_h)
        set( gainstr_h,'String', pzg_efmt( disp_gain, 4 ), ...
            'visible','on','backgroundcolor',[0.9 0.9 0]);
      end
      gain_marker_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_gain_marker');
      if ~isempty(gain_marker_h)
        set( gain_marker_h, ...
            'xdata', real(CLpoles), ...
            'ydata', imag(CLpoles), ...
            'visible','on');
      end      
    else
      % Mouse click is intended to be a one-click zoom-in.
      x_lim = get( PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h,'xlim');
      y_lim = get( PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h,'ylim');
      new_xlim = real(CurrPt) + [-1 1]*diff( x_lim )/4;
      new_ylim = imag(CurrPt) + [-1 1]*diff( y_lim )/4;
      set( PZG(dom_ndx).plot_h{9+dom_ndx}.ax_h, ...
          'xlim', new_xlim,'ylim', new_ylim );
      if ~isempty(hndl)
        hndl.ax_xlim = new_xlim;
        hndl.ax_ylim = new_ylim;
        setappdata( PZG(dom_ndx).plot_h{9+dom_ndx}.fig_h,'hndl', hndl );
      end
      PZG(1).plot_h{9+dom_ndx}.xlim = new_xlim;
      PZG(2).plot_h{9+dom_ndx}.xlim = new_xlim;
      PZG(1).plot_h{9+dom_ndx}.hndl.ax_xlim = new_xlim;
      PZG(2).plot_h{9+dom_ndx}.hndl.ax_xlim = new_xlim;
      PZG(1).plot_h{9+dom_ndx}.ylim = new_ylim;
      PZG(2).plot_h{9+dom_ndx}.ylim = new_ylim;
      PZG(1).plot_h{9+dom_ndx}.hndl.ax_ylim = new_ylim;
      PZG(2).plot_h{9+dom_ndx}.hndl.ax_ylim = new_ylim;
      if isfield( hndl,'PZmap_xaxis_highlight')
        set( hndl.PZmap_xaxis_highlight, ...
            'xdata', new_xlim,'ydata',[0 0] );
      end
      if isfield( hndl,'PZmap_yaxis_highlight')
        set( hndl.PZmap_yaxis_highlight, ...
            'xdata',[0 0],'ydata', new_ylim );
      end
    end
  else
    [ pd, plot_h, dom_ndx, fig_h_ndx ] = freqserv( gcbf, 1 ); %#ok<ASGLU>
    PZG(dom_ndx).plot_h{fig_h_ndx} = plot_h{fig_h_ndx};
    if ~isempty(plot_h) ...
      && ( plot_h{fig_h_ndx}.mindist < 0.025 )
      hndl.ax_xlim = get( gca0,'xlim');
      hndl.ax_ylim = get( gca0,'ylim');
      setappdata( gcf0,'hndl', hndl );
      PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.xlim = hndl.ax_xlim;
      PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.ylim = hndl.ax_ylim;
      PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_xlim = hndl.ax_xlim;
      PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_ylim = hndl.ax_ylim;
      if isfield( hndl,'PZmap_xaxis_highlight')
        set( hndl.PZmap_xaxis_highlight,'xdata', hndl.ax_xlim );
      end
      if isfield( hndl,'PZmap_yaxis_highlight')
        set( hndl.PZmap_yaxis_highlight,'ydata', hndl.ax_ylim );
      end
      if dom_ndx == 1
        [ temp0, hndl, mod_hndl ] = ...
            pzg_grid( temp0, gcf0, gca0, 9+dom_ndx, hndl );
        if mod_hndl
          set( gcf0,'userdata', temp0 );
          setappdata( gcf0,'hndl', hndl );
        end
      end
      return
    end
  end
  
  hndl.ax_xlim = get( gca0,'xlim');
  hndl.ax_ylim = get( gca0,'ylim');
  setappdata( gcf0,'hndl', hndl );
  PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.xlim = hndl.ax_xlim;
  PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.ylim = hndl.ax_ylim;
  PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_xlim = hndl.ax_xlim;
  PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx}.hndl.ax_ylim = hndl.ax_ylim;
  if isfield( hndl,'PZmap_xaxis_highlight')
    set( hndl.PZmap_xaxis_highlight,'xdata', hndl.ax_xlim );
  end
  if isfield( hndl,'PZmap_yaxis_highlight')
    set( hndl.PZmap_yaxis_highlight,'ydata', hndl.ax_ylim );
  end
  if dom_ndx == 1
    [ temp0, hndl, mod_hndl ] = ...
        pzg_grid( temp0, gcf0, gca0, 9+dom_ndx, hndl );
    if mod_hndl
      set( gcf0,'userdata', temp0 );
      setappdata( gcf0,'hndl', hndl );
    end
  end
  pzg_ptr
end

x_hilite_h = hndl.PZmap_xaxis_highlight;
set( x_hilite_h,'xdata',hndl.ax_xlim,'ydata',[0 0],'Visible','On')

y_hilite_h = hndl.PZmap_yaxis_highlight;
set( y_hilite_h,'xdata',[0 0],'ydata', hndl.ax_ylim,'Visible','On')

if ~isfield( hndl,'rlocuspl_gain_text') ...
  || ~isequal( 1, ishandle(hndl.rlocuspl_gain_text) )
  gain_str_h = ...
    findobj( gcf0,'type','uicontrol', ...
            'tag','rlocuspl gain text');
  hndl.rlocuspl_gain_text = gain_str_h;
end

setappdata( gcf0,'hndl', hndl );

return

function local_center_it( rloc_h, dom_ndx )
  global PZG
    
  if ~nargin
    rloc_h = gcbf;
  end
  if isempty(rloc_h) || ~ishandle(rloc_h) ...
    || ~strcmpi( get(rloc_h,'type'),'figure') ...
    || isempty( strfind( get(rloc_h,'name'),'Root Locus') )
    return
  end
  if ( nargin < 2 ) || ( ~isequal( dom_ndx, 1 ) && ~isequal( dom_ndx, 2 ) )
    dom_ndx = 1;
    if isempty( strfind( get(rloc_h,'name'),'ontinuous') )
      dom_ndx = 2;
    end
  end
  
  if isappdata( rloc_h,'hndl')
    hndl = getappdata( rloc_h,'hndl');
  else
    hndl = [];
  end
  if isfield( hndl,'ax') && isequal( 1, ishandle(hndl.ax) )
    ax_h = hndl.ax;
  else
    ax_h = get( rloc_h,'currentaxes');
  end
  if isempty(ax_h)
    return
  end

  PP = [ PZG(dom_ndx).PoleLocs; PZG(dom_ndx).CLPoleLocs ];
  ZZ = PZG(dom_ndx).ZeroLocs;
  if ( dom_ndx == 2 )
    max_imag = max( 1.1, 1.05*max( [imag(PP(:));imag(ZZ(:))] ) );
    max_real = max( 1.2, 1.05*max([real(PP(:));real(ZZ(:))]) );
    min_real = min( -1.1, 1.05*min([real(PP(:));real(ZZ(:))]) );
    x_lim = [ min_real max_real ];
    y_lim = max_imag*[-1 1];
    set( ax_h,'xlim', x_lim,'ylim', y_lim )
    PZG(1).plot_h{11}.xlim = x_lim;
    PZG(2).plot_h{11}.xlim = x_lim;
    PZG(1).plot_h{11}.hndl.ax_xlim = x_lim;
    PZG(2).plot_h{11}.hndl.ax_xlim = x_lim;
    PZG(1).plot_h{11}.ylim = y_lim;
    PZG(2).plot_h{11}.ylim = y_lim;
    PZG(1).plot_h{11}.hndl.ax_ylim = y_lim;
    PZG(2).plot_h{11}.hndl.ax_ylim = y_lim;
    if ~isempty(hndl)
      hndl.ax_xlim = x_lim;
      hndl.ax_ylim = y_lim;
      setappdata( rloc_h,'hndl', hndl );
    end
  else
    % For the S-plane:
    %max_real = 0.2;
    max_real = max( 0.2, max( real([PP;ZZ]) ) );
    %min_real = -1;
    min_real = min( -1, 3*min( real([PP;ZZ]) ) );
    %max_imag = 1;
    max_imag = max( abs(min_real)/2, max(imag([PP;ZZ])) );
    if numel(PP) == numel(ZZ)
      % Finite root loci only.
      loci_h = findobj( ax_h,'tag','rlocuspl root loci');
      %neg_h = findobj( ax_h,'tag','rlocuspl neg root loci');
      for k = 1:numel(loci_h)
        xdata = get( loci_h(k),'xdata');
        inf_ndx = find( abs(xdata) > 1e12 );
        if ~isempty(inf_ndx) && ( numel(inf_ndx) < numel(xdata) )
          xdata(inf_ndx) = [];
        end
        [ temp, min_ndx ] = min(xdata); %#ok<ASGLU>
        if min_ndx == 1
          min_ndx = 2;
        else
          min_ndx = min_ndx - 1;
        end
        [ temp, max_ndx ] = max(xdata); %#ok<ASGLU>
        if max_ndx == 1
          max_ndx = 2;
        else
          max_ndx = max_ndx - 1;
        end
        min_real = min( min_real, xdata(min_ndx) );
        max_real = max( max_real, xdata(max_ndx) );

        ydata = get( loci_h(k),'ydata');
        inf_ndx = find( abs(ydata) > 1e12 );
        if ~isempty(inf_ndx) && ( numel(inf_ndx) < numel(ydata) )
          ydata(inf_ndx) = [];
        end
        [ temp, max_ndx ] = max(ydata); %#ok<ASGLU>
        if max_ndx == 1
          max_ndx = 2;
        else
          max_ndx = max_ndx - 1;
        end
        max_imag = max( max_imag, ydata(max_ndx) );
      end
      min_real = max( min_real, 10*min(-1, min(real([PP;ZZ])) ) );
      max_real = min( max_real, 10*max(1, max(real([PP;ZZ])) ) );
      max_imag = min( max_imag, 10*max(imag([PP;ZZ])) );
    else
      % Show all the poles and zeros.
      min_real = min( min_real, 3*min(real([PP(:);ZZ(:)])) );
      max_real = max( max_real, max(real([PP(:);ZZ(:)])) );
      if max_real <= 0
        max_real = abs(min_real)/10;
      end
      if min_real >= 0
        min_real = -max_real/10;
      end
      if max_real > abs(min_real)
        min_real = -max_real;
      end
      max_imag = max( max_imag, max(imag([PP(:);ZZ(:)])) );
      if PZG(1).PureDelay > 0
        max_zp = max( 1, max(abs([PP(:);ZZ(:)])) );
        if max(abs(PZG(1).pade.P)) < 2*max_zp
          min_real = ...
            min( min_real, min(real([PZG(1).pade.P(:);PZG(1).pade.Z(:)])) );
          max_real = ...
            max( max_real, max(real([PZG(1).pade.P(:);PZG(1).pade.Z(:)])) );
          max_imag = ...
            max( max_imag, max(imag([PZG(1).pade.P(:);PZG(1).pade.Z(:)])) );
        end
      end
      scaling = max( 1.3*(max_real-min_real), 1.3*max_imag );
      min_real = min( -scaling/2, 1.3*min_real );
      max_real = max( min_real+scaling, abs(min_real)/10 );
      max_imag = max( 1.3*max_imag, (max_real-min_real)/2 );
      max_real = max( max_real, abs(min_real)/8 );
    end

    ax_ud = get( PZG(1).plot_h{10}.ax_h,'userdata');
    K1k_ndx = sum( ax_ud.GAINS < 100 );
    locline_h = findobj( ax_h,'tag','rlocuspl root loci');
    max_x = max( max_real, abs(min_real)/5 );
    min_x = max_real;
    max_y = max_imag;
    for k = 1:numel(locline_h)
      xdata = get( locline_h(k),'xdata');
      xdata = xdata(1:K1k_ndx);
      max_x = ...
        max( max_x, min( 2*max_real, max( max(xdata(:)), abs(max_real) ) ) );
      min_x = ...
        min( min_x, max( 2*min_real, min( min(xdata(:)), -abs(min_real) ) ) );
      ydata = get( locline_h(k),'ydata');
      ydata = ydata(1:K1k_ndx);
      max_y = max( max_y, max( max(ydata(:)), max_imag ) );
    end
    min_real = min( min_real, min_x );
    min_real = min( -1, min_real );
    max_real = max( max( max_real, max_x ), abs(min_real)/8 );
    max_imag = max( max_y, (max_real-min_real)/2 );

    if 2*max_imag > (max_real-min_real)
      min_real = min( min_real, -max_imag );
      max_real = max( max_real, max_imag/8 );
    elseif (max_real-min_real) > 2*max_imag
      max_imag = 0.5*(max_real-min_real);
    end

    max_imag = max( max_imag, max( abs(min_real),abs(max_real) )/2 );

    if min_real == 0
      min_real = -1;
      max_real = max( 1, max_real );
    end
    if max_imag == 0
      max_imag = max( abs(min_real), abs(max_real) )/2;
    end
    
    x_lim = 1.1*[ min_real  max_real ];
    y_lim = max_imag*[-1.1  1.1];
    set( ax_h,'xlim', x_lim,'ylim', y_lim )
    
    PZG(1).plot_h{9+dom_ndx}.xlim = x_lim;
    PZG(2).plot_h{9+dom_ndx}.xlim = x_lim;
    PZG(1).plot_h{9+dom_ndx}.hndl.ax_xlim = x_lim;
    PZG(2).plot_h{9+dom_ndx}.hndl.ax_xlim = x_lim;
    PZG(1).plot_h{9+dom_ndx}.ylim = y_lim;
    PZG(2).plot_h{9+dom_ndx}.ylim = y_lim;
    PZG(1).plot_h{9+dom_ndx}.hndl.ax_ylim = y_lim;
    PZG(2).plot_h{9+dom_ndx}.hndl.ax_ylim = y_lim;
    if ~isempty(hndl)
      hndl.ax_xlim = x_lim;
      hndl.ax_ylim = y_lim;
      setappdata( rloc_h,'hndl', hndl );
    end
    % Set x-axis and y-axis highlights to the same range.
    if isfield( hndl,'PZmap_xaxis_highlight')
      set( hndl.PZmap_xaxis_highlight,'xdata', x_lim );
    end
    if isfield( hndl,'PZmap_yaxis_highlight')
      set( hndl.PZmap_yaxis_highlight,'ydata', y_lim );
    end
  end
  
return

function local_grids_and_hilites_off( hndl )

if ~isstruct(hndl) || ~isfield( hndl,'Splane_constWn_semicirc')
  return
end

set( hndl.Splane_constWn_semicirc,'visible','off');
set( hndl.Splane_constWn_semicirc_repeated,'visible','off');
set( hndl.Splane_constZeta_lines,'visible','off');
set( hndl.Splane_constZeta_lines_repeated,'visible','off');
set( hndl.Wplane_constWn_lines,'visible','off');
set( hndl.Wplane_constZeta_lines,'visible','off');
set( hndl.PZmap_xaxis_highlight,'visible','off');
set( hndl.PZmap_yaxis_highlight,'visible','off');
set( hndl.Splane_halfTS_lines,'visible','off');
set( hndl.Splane_fullTS_lines,'visible','off');

return

function local_neg_loci_cb

  if isempty(gcbf) || isempty(gcbo)
    return
  end
  hndl = getappdata( gcbf,'hndl');
  dom_ndx = hndl.dom_ndx;
  ploth_ndx = hndl.ploth_ndx;

  negline_h = ...
    [ pzg_fndo( dom_ndx, ploth_ndx,'rlocuspl_neg_root_loci'); ...
      pzg_fndo( dom_ndx, ploth_ndx,'rlocuspl_neg_asymptote') ];
  if ~isempty(negline_h)
    if get(gcbo,'value')
      set(negline_h,'visible','on');
    else
      set(negline_h,'visible','off');
    end
  end
  
  [ which_tool, toolfig_h, preview ] = pzg_tools( dom_ndx );    %#ok<ASGLU>
  if ~sum( which_tool(2:3) )
    return
  end
  if which_tool(2)
    negline_h = pzg_fndo( dom_ndx, ploth_ndx,'LDLG_Preview');
    negline_h = negline_h(6:7);
  else
    negline_h = pzg_fndo( dom_ndx, ploth_ndx,'PID_Preview');
    negline_h = negline_h(6:7);
  end
  
  if get(gcbo,'value') && preview
    set(negline_h,'visible','on');
  else
    set(negline_h,'visible','off');
  end
return

function local_apply_gain
  global PZG
  
  if isempty(gcbf) || ~isappdata( gcbf,'hndl')
    return
  end
  
  hndl = getappdata( gcbf,'hndl');
  dom_ndx = hndl.dom_ndx;
  ploth_ndx = hndl.ploth_ndx;
  gaintext_h = pzg_fndo( dom_ndx, ploth_ndx,'rlocuspl_gain_text');
  if isempty(gaintext_h)
    return
  end
  new_gain = str2double( get(gaintext_h,'string') );
  if isempty(new_gain) && isempty( get(gaintext_h,'string') )
    errdlg_h = ...
      errordlg( ...
        {'There is nothing entered in the text entry window'; ...
         'to the left of the "Apply" button that you clicked.'; ...
         ' '; ...
         'Enter a single, nonzero real number as the parameter "K",'; ...
         ' '}, ...
        'Invalid Gain Entry','modal');
    uiwait(errdlg_h)
    return
  elseif ~isreal(new_gain) || isequal( new_gain, 0 )
    errdlg_h = ...
      errordlg( ...
        {'The entry to the left of the "Apply" button that you clicked'; ...
         'could not be interpreted into a valid value for parameter "K".'; ...
         '.'; ...
         ' '; ...
         'Enter a single, nonzero real number for the parameter "K".'; ...
         ' '}, ...
        'Invalid Gain Entry','modal');
    uiwait(errdlg_h)
    return
  end
  
  pzg_onoff(0)
  set( gaintext_h,'string','','backgroundcolor',[0.9 0.9 0.9]);
  
  ystar_h = pzg_fndo( dom_ndx, ploth_ndx,'rlocuspl_gain_marker');
  if ~isempty(ystar_h)
    set( ystar_h,'visible','off');
  end
  
  temp_undo = [];
  temp_undo.PoleLocs = PZG(dom_ndx).PoleLocs;
  temp_undo.ZeroLocs = PZG(dom_ndx).ZeroLocs;
  temp_undo.Gain = PZG(dom_ndx).Gain;
  temp_undo.Ts = PZG(dom_ndx).Ts;
  temp_undo.PureDelay = PZG(dom_ndx).PureDelay;
  temp_undo.DCgain = PZG(dom_ndx).DCgain;
  if ~isfield(PZG(dom_ndx),'undo_info')
    PZG(dom_ndx).undo_info = {};
  end
  if isempty(PZG(dom_ndx).undo_info) ...
    ||~isequal(PZG(dom_ndx).undo_info{end},temp_undo)
    PZG(dom_ndx).undo_info{end+1} = temp_undo;
  end
  if ~isempty(PZG(dom_ndx).DCgain)
    PZG(dom_ndx).DCgain = new_gain*PZG(dom_ndx).DCgain;
  end
  PZG(dom_ndx).Gain = new_gain*PZG(dom_ndx).Gain;
  PZG(dom_ndx).recompute_frf = 0;
  pzg_cntr(dom_ndx);
  pzg_bodex(dom_ndx);
  if dom_ndx == 1
    if pzg_islink(2)
      link_h = pzg_fndo(2,13,'LinkCheckbox');
      if ~isempty(link_h)
        bg_color = get( get(link_h,'parent'),'color');
        set( link_h, 'value', 0,'backgroundcolor', bg_color )
        link_h2 = pzg_fndo(2,13,'LinkMethod');
        if ~isempty(link_h2)
          set( link_h2,'backgroundcolor', bg_color )
        end        
      end
    end
    pzgui
    updatepl
  else
    if pzg_islink(1)
      link_h = pzg_fndo(1,12,'LinkCheckbox');
      if ~isempty(link_h)
        bg_color = get( get(link_h,'parent'),'color');
        set( link_h, 'value', 0,'backgroundcolor', bg_color )
        link_h2 = pzg_fndo(1,12,'LinkMethod');
        if ~isempty(link_h2)
          set( link_h2,'backgroundcolor', bg_color )
        end        
      end
    end
    dpzgui;
    dupdatep;
  end

return
